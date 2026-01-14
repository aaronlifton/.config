-- iglob treesitter picker
local M = {}

-- Helpers
local H = {}

H.is_executable = function(tool)
  if tool == "fallback" then return true end
  return vim.fn.executable(tool) == 1
end
H.is_array_of = function(x, ref_type)
  if not vim.tbl_islist(x) then return false end
  for i = 1, #x do
    if type(x[i]) ~= ref_type then return false end
  end
  return true
end
H.get_config = function(config)
  return vim.tbl_deep_extend("force", MiniPick.config, vim.b.minipick_config or {}, config or {})
end
H.full_path = function(path)
  return (vim.fn.fnamemodify(path, ":p"):gsub("(.)/$", "%1"))
end
local FlagManager = require("util.minipick_registry.flag_manager")
local Grep = require("util.minipick_registry.grep")

local function create_rg_live_grep_picker(MiniPick)
  return function(local_opts, opts)
    local function rg_live(local_opts, opts)
      local_opts = vim.tbl_extend("force", { tool = "rg", globs = {}, flags = {} }, local_opts or {})
      local tool = local_opts.tool -- or H.grep_get_tool()
      if tool == "fallback" or not H.is_executable(tool) then
        H.error("`grep_live` needs non-fallback executable tool.")
      end

      local globs = H.is_array_of(local_opts.globs, "string") and local_opts.globs or {}
      local flags = { "hidden" }
      if H.is_array_of(local_opts.flags, "string") then flags = vim.list_extend({}, local_opts.flags) end
      local custom_name = opts.source.name or "Grep live"

      -- Show options (can be set via local_opts)
      local show_opts = {
        ts_highlight = local_opts.ts_highlight, -- nil = use global, false = disabled, true = enabled
        path_max_width = local_opts.path_max_width, -- nil = use global or no truncation
        path_truncate_mode = local_opts.path_truncate_mode, -- "head", "middle", "smart" (default)
      }

      local function build_name_suffix()
        local parts = {}
        if #globs > 0 then parts[#parts + 1] = table.concat(globs, ", ") end
        local flag_parts = {}
        for _, flag in ipairs(flags) do
          flag_parts[#flag_parts + 1] = FlagManager.rg_flags[flag] or flag
        end
        if show_opts.ts_highlight == false then flag_parts[#flag_parts + 1] = "no-ts" end
        if show_opts.path_max_width then flag_parts[#flag_parts + 1] = "path:" .. show_opts.path_max_width end
        if #flag_parts > 0 then parts[#parts + 1] = table.concat(flag_parts, ", ") end
        return #parts == 0 and "" or (" | " .. table.concat(parts, " | "))
      end

      local function build_name()
        local name_suffix = build_name_suffix()
        return string.format("%s (%s%s)", custom_name, tool, name_suffix)
      end

      local function get_show_func()
        return function(buf_id, items, query)
          Grep.grep_ts_show(buf_id, items, query, show_opts)
        end
      end

      local name = build_name()
      local default_source = {
        name = name,
        show = get_show_func(),
        choose_marked = require("util.minipick_registry.trouble").trouble_choose_marked,
      }

      opts = vim.tbl_deep_extend("force", { source = default_source }, opts or {})
      opts.source.name = default_source.name

      local cwd = H.full_path(opts.source.cwd or vim.fn.getcwd())
      local set_items_opts, spawn_opts = { do_match = false, querytick = MiniPick.get_querytick() }, { cwd = cwd }
      local process
      local match = function(_, _, query)
        ---@diagnostic disable-next-line: undefined-field
        pcall(vim.loop.process_kill, process)

        local querytick = MiniPick.get_querytick()
        if querytick == set_items_opts.querytick then return end
        local preset_pattern = type(local_opts.pattern) == "string" and local_opts.pattern or nil
        if not preset_pattern and #query == 0 then return MiniPick.set_picker_items({}, set_items_opts) end

        set_items_opts.querytick = querytick

        local full_query = preset_pattern or table.concat(query)
        local search_pattern, iglob_patterns = Grep.parse_query(full_query)

        if search_pattern == "" then return MiniPick.set_picker_items({}, set_items_opts) end

        local all_globs = vim.list_extend(vim.list_extend({}, iglob_patterns), globs)

        local command = Grep.grep_get_command(search_pattern, all_globs, flags)

        process = MiniPick.set_picker_items_from_cli(command, {
          set_items_opts = set_items_opts,
          spawn_opts = spawn_opts,
        })
      end

      local add_glob = function()
        local ok, glob = pcall(vim.fn.input, "iglob pattern: ")
        if ok then table.insert(globs, glob) end
        MiniPick.set_picker_opts({ source = { name = build_name() } })
        MiniPick.set_picker_query(MiniPick.get_picker_query())
      end

      local remove_glob = function()
        if #globs > 0 then
          table.remove(globs)
          MiniPick.set_picker_opts({ source = { name = build_name() } })
          MiniPick.set_picker_query(MiniPick.get_picker_query())
        end
      end

      local toggle_no_ignore = function()
        FlagManager.toggle_flag(flags, "no_ignore")
        MiniPick.set_picker_opts({ source = { name = build_name() } })
        MiniPick.set_picker_query(MiniPick.get_picker_query())
      end

      local toggle_hidden = function()
        FlagManager.toggle_flag(flags, "hidden")
        MiniPick.set_picker_opts({ source = { name = build_name() } })
        MiniPick.set_picker_query(MiniPick.get_picker_query())
      end

      local function toggle_extra_flag(flag_key)
        return function()
          FlagManager.toggle_flag(flags, flag_key)
          MiniPick.set_picker_opts({ source = { name = build_name() } })
          MiniPick.set_picker_query(MiniPick.get_picker_query())
        end
      end

      local function toggle_dotall()
        -- local dotall_pattern = "(?s)."
        -- local dotall_pattern = "(?s:.)"
        local dotall_pattern = ".*\\n(?s:.).*"
        FlagManager.toggle_flag(flags, "dotall")
        local dotall_enabled = FlagManager.has_flag(flags, "dotall")
        local query = MiniPick.get_picker_query()
        local query_str = table.concat(query)

        if dotall_enabled then
          -- Add (?s:.) after current query
          if not query_str:find(vim.pesc(dotall_pattern), 1, true) then query_str = query_str .. dotall_pattern end
        else
          -- Remove (?s:.) from query
          query_str = query_str:gsub(vim.pesc(dotall_pattern), "")
        end

        MiniPick.set_picker_opts({ source = { name = build_name() } })
        MiniPick.set_picker_query(vim.split(query_str, ""))
      end

      local function toggle_ts_highlight()
        -- Cycle: nil (use global) -> false (disabled) -> nil
        if show_opts.ts_highlight == nil then
          show_opts.ts_highlight = false
        else
          show_opts.ts_highlight = nil
        end
        MiniPick.set_picker_opts({ source = { name = build_name(), show = get_show_func() } })
        MiniPick.set_picker_query(MiniPick.get_picker_query())
      end

      local function toggle_path_width()
        -- Cycle: nil -> 60 -> 40 -> 80 -> nil
        local widths = { nil, 60, 40, 80 }
        local current_idx = 1
        for i, w in ipairs(widths) do
          if show_opts.path_max_width == w then
            current_idx = i
            break
          end
        end
        show_opts.path_max_width = widths[(current_idx % #widths) + 1]
        MiniPick.set_picker_opts({ source = { name = build_name(), show = get_show_func() } })
        MiniPick.set_picker_query(MiniPick.get_picker_query())
      end

      local function toggle_iglob_pattern(pattern_key)
        return function()
          local pattern = Grep.iglob_patterns[pattern_key]
          if not FlagManager.toggle_glob_pattern(globs, pattern) then return end
          MiniPick.set_picker_opts({ source = { name = build_name() } })
          MiniPick.set_picker_query(MiniPick.get_picker_query())
        end
      end

      -- Mnemonics (from fzf-extended.lua):
      --   alt-j: js/ts (non-tests)
      --   alt-o: only js/ts tests
      --   alt-t: tests/specs
      --   alt-x: e(x)clude (all except tests/specs)
      --   alt-s: scripts (js/ts)
      --   alt-m: exclude bundle modules (umd/cjs/esm)
      --   alt-c: conf type
      --   alt-w: web type
      ------------------------------------------------
      --   alt-g: glob case-insensitive
      --   alt-k: context (2 lines)
      --   alt-n: max count (1 per file)
      --   alt-d: max depth (3)
      --   alt-p: pcre2
      --   alt-u: unrestricted (rg -U)
      --   alt-l: lua type
      --   alt-r: ruby type
      --   alt-f: filepath sort
      --   alt-y: toggle treesitter s(y)ntax highlighting
      --   alt-z: toggle path truncation (cycles: off -> 60 -> 40 -> 80)

      local mappings = FlagManager.build_flag_mappings({
        add_glob = add_glob,
        remove_glob = remove_glob,
        toggle_no_ignore = toggle_no_ignore,
        toggle_hidden = toggle_hidden,
        toggle_iglob_pattern = toggle_iglob_pattern,
        toggle_extra_flag = toggle_extra_flag,
        toggle_dotall = toggle_dotall,
        toggle_ts_highlight = toggle_ts_highlight,
        toggle_path_width = toggle_path_width,
      })

      opts = vim.tbl_deep_extend("force", opts or {}, { source = { items = {}, match = match }, mappings = mappings })
      return MiniPick.start(opts)
    end
    return rg_live(local_opts, opts)
  end
end

M.setup = function(MiniPick)
  MiniPick.registry.rg_live_grep = create_rg_live_grep_picker(MiniPick)
end

return M

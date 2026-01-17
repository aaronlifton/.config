local M = {}

local H = {}
local P = require("util.minipick_registry.picker").H

local FlagManager = require("util.minipick_registry.flag_manager")
local Grep = require("util.minipick_registry.grep")

local function create_rg_grep_picker(MiniPick)
  return function(local_opts, opts)
    local_opts = vim.tbl_extend("force", { tool = "rg", pattern = nil, globs = {}, flags = {} }, local_opts or {})
    local tool = local_opts.tool
    if tool == "fallback" or not P.is_executable(tool) then H.error("`rg_grep` needs non-fallback executable tool.") end

    local globs = P.is_array_of(local_opts.globs, "string") and local_opts.globs or {}
    local flags = FlagManager.resolve_rg_flags(P.is_array_of(local_opts.flags, "string") and local_opts.flags or nil)
    local formatted_name
    if opts and opts.source and opts.source.name then
      formatted_name = opts.source.name and (opts.source.name):format(" %s ") or nil
    end

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

    local function build_name(pattern)
      local name_suffix = build_name_suffix()
      if formatted_name then
        return string.format("Grep '%s' (%s%s) | %s | %s", pattern, tool, name_suffix, formatted_name)
      end
      return string.format("Grep '%s' (%s%s)", pattern, tool, name_suffix)
    end

    local function get_show_func()
      return function(buf_id, items, query)
        Grep.grep_ts_show(buf_id, items, query, show_opts)
      end
    end

    local pattern = type(local_opts.pattern) == "string" and local_opts.pattern

    local name = build_name(pattern)
    local default_source = {
      name = name,
      show = get_show_func(),
      choose_marked = require("util.minipick_registry.trouble").trouble_choose_marked,
    }

    opts = vim.tbl_deep_extend("force", { source = default_source }, opts or {})
    opts.source.name = default_source.name

    local function refresh_items()
      local command = Grep.grep_get_command(pattern, globs, flags)
      MiniPick.set_picker_items_from_cli(command, { set_items_opts = { do_match = false } })
    end

    local function add_glob()
      local ok, glob = pcall(vim.fn.input, "iglob pattern: ")
      if ok then table.insert(globs, glob) end
      MiniPick.set_picker_opts({ source = { name = build_name() } })
      refresh_items()
    end

    local function remove_glob()
      if #globs > 0 then
        table.remove(globs)
        MiniPick.set_picker_opts({ source = { name = build_name() } })
        refresh_items()
      end
    end

    local function toggle_no_ignore()
      FlagManager.toggle_flag(flags, "no_ignore")
      MiniPick.set_picker_opts({ source = { name = build_name() } })
      refresh_items()
    end

    local function toggle_hidden()
      FlagManager.toggle_flag(flags, "hidden")
      MiniPick.set_picker_opts({ source = { name = build_name() } })
      refresh_items()
    end

    local function toggle_extra_flag(flag_key)
      return function()
        FlagManager.toggle_flag(flags, flag_key)
        MiniPick.set_picker_opts({ source = { name = build_name() } })
        refresh_items()
      end
    end

    local function toggle_dotall()
      FlagManager.toggle_flag(flags, "dotall")
      MiniPick.set_picker_opts({ source = { name = build_name() } })
      refresh_items()
    end

    local function toggle_ts_highlight()
      if show_opts.ts_highlight == nil then
        show_opts.ts_highlight = false
      else
        show_opts.ts_highlight = nil
      end
      MiniPick.set_picker_opts({ source = { name = build_name(), show = get_show_func() } })
    end

    local function toggle_path_width()
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
        local pattern_value = FlagManager.iglob_patterns[pattern_key]
        if not FlagManager.toggle_glob_pattern(globs, pattern_value) then return end
        MiniPick.set_picker_opts({ source = { name = build_name() } })
        refresh_items()
      end
    end

    local mappings = FlagManager.build_rg_flag_mappings({
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

    opts = vim.tbl_deep_extend("force", opts or {}, { mappings = mappings })
    MiniPick.builtin.cli({ command = Grep.grep_get_command(pattern, globs, flags) }, opts)
  end
end

M.setup = function(MiniPick)
  MiniPick.registry.rg_grep = create_rg_grep_picker(MiniPick)
end

return M

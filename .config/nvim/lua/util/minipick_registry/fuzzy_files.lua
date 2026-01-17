local M = {}

-- Helpers
local H = {}

local FlagManager = require("util.minipick_registry.flag_manager")
local FileTool = require("util.minipick_registry.file_tool")
local P = require("util.minipick_registry.picker").H

local excl_flags = { time = { "week", "two_days", "today" } }

local function get_path_cache()
  if H._path_cache ~= nil then return H._path_cache end
  H._path_cache = {
    ns = vim.api.nvim_create_namespace("minipick-fuzzy-files"),
  }
  return H._path_cache
end

local function is_hidden_path(path)
  if path:sub(1, 1) == "." then return true end
  return path:find("/%.") ~= nil
end

-- Inspired by ~/.local/share/nvim/lazy/snacks.nvim/lua/snacks/picker/format.lua:42
local function highlight_path(buf_id, row, path, col_offset)
  if path == "" then return end

  local base_hl = P.hl_group_or("SnacksPickerFile", "MiniPickNormal")
  local dir_hl = P.hl_group_or("SnacksPickerDir", "MiniPickNormal")
  if is_hidden_path(path) then base_hl = P.hl_group_or("SnacksPickerPathHidden", base_hl) end

  local dir, base = path:match("^(.*)/([^/]+)$")
  local ext_opts = { hl_mode = "combine", priority = 120 }
  if dir and base then
    ext_opts.hl_group = dir_hl
    ext_opts.end_row = row
    ext_opts.end_col = col_offset + #dir + 1
    vim.api.nvim_buf_set_extmark(buf_id, get_path_cache().ns, row, col_offset, ext_opts)

    ext_opts.hl_group = base_hl
    ext_opts.end_row = row
    ext_opts.end_col = col_offset + #dir + 1 + #base
    vim.api.nvim_buf_set_extmark(buf_id, get_path_cache().ns, row, col_offset + #dir + 1, ext_opts)
  else
    ext_opts.hl_group = base_hl
    ext_opts.end_row = row
    ext_opts.end_col = col_offset + #path
    vim.api.nvim_buf_set_extmark(buf_id, get_path_cache().ns, row, col_offset, ext_opts)
  end
end

-- Truncate path to max_width, preserving filename
-- Modes: "head" (truncate start), "middle" (truncate middle), "smart" (keep first + last dirs)
---@param path string
---@param max_width number
---@param mode? "head"|"middle"|"smart"
---@return string
local function truncate_path(path, max_width, mode)
  if #path <= max_width then return path end
  mode = mode or "smart"

  local dir, filename = path:match("^(.*)/([^/]+)$")
  if not dir then return path:sub(1, max_width - 1) .. "…" end

  -- Reserve space for filename + separator + ellipsis
  local available = max_width - #filename - 2 -- "…/"
  if available <= 0 then
    -- Filename alone is too long, truncate it
    return "…" .. filename:sub(-(max_width - 1))
  end

  if mode == "head" then
    -- Truncate from start: …/rest/of/path/file.lua
    return "…" .. dir:sub(-available) .. "/" .. filename
  elseif mode == "middle" then
    -- Truncate from middle: start/…/end/file.lua
    local half = math.floor(available / 2)
    local left = dir:sub(1, half)
    local right = dir:sub(-(available - half - 1))
    return left .. "…" .. right .. "/" .. filename
  else -- "smart"
    -- Keep first directory and filename: first/…/file.lua
    local first_dir = dir:match("^([^/]+)")
    if first_dir and #first_dir + 3 < available then
      local rest_available = available - #first_dir - 2 -- "/…"
      local rest = dir:sub(#first_dir + 2) -- skip "first_dir/"
      if #rest > rest_available then rest = "…" .. rest:sub(-rest_available + 1) end
      return first_dir .. "/" .. rest .. "/" .. filename
    else
      -- Fall back to head truncation
      return "…" .. dir:sub(-available) .. "/" .. filename
    end
  end
end

local function create_fuzzy_files_picker(MiniPick)
  -- Example override:
  -- MiniPick.registry.fuzzy_files({
  --   matcher = "auto", -- "fzf" | "fzf_dp" | "auto"
  --   fzf = { smartcase = false, filename_bonus = false },
  --   auto = { threshold = 20000 },
  -- }, {})
  return function(local_opts, opts)
    opts.source = opts.source or {}

    local matcher = ((local_opts and local_opts.matcher) or (opts and opts.matcher) or "fzf")
    local tool_key = (local_opts and local_opts.tool) or "fd"
    local tool = FileTool.get(tool_key)
    local auto_opts = vim.tbl_deep_extend("force", { threshold = 20000 }, (local_opts and local_opts.auto) or {})
    local fzf_opts = vim.tbl_deep_extend("force", {}, (local_opts and local_opts.fzf) or {})

    local last_regex_query
    local fzf = nil
    local dp = nil

    local function get_matcher(use_dp)
      if use_dp then
        if not dp then dp = require("util.minipick_registry.fzf_dp").new(fzf_opts) end
        return dp
      end
      if not fzf then fzf = require("util.minipick_registry.fzf").new(fzf_opts) end
      return fzf
    end

    -- State for toggleable options
    local excludes = vim.deepcopy((local_opts and local_opts.excludes) or {})
    -- Default: hidden files ON (matches typical usage)
    local default_flags = vim.tbl_extend(
      "force",
      { hidden = true },
      (local_opts and local_opts.fd_flags) or {},
      (local_opts and local_opts.tool_flags) or {}
    )
    local flags
    if P.is_array_of(local_opts and local_opts.flags, "string") then
      flags = vim.list_extend({}, local_opts.flags)
    else
      flags = {}
      for key, enabled in pairs(default_flags) do
        if enabled then table.insert(flags, key) end
      end
    end
    flags = FileTool.filter_flags(tool, flags)
    local regex_mode = false

    local function build_name_suffix()
      local parts = {}
      if #excludes > 0 then parts[#parts + 1] = "excl:" .. #excludes end
      local flag_parts = {}
      for _, flag in ipairs(flags) do
        flag_parts[#flag_parts + 1] = FileTool.flag_label(tool, flag)
      end
      if #flag_parts > 0 then parts[#parts + 1] = table.concat(flag_parts, ", ") end
      if regex_mode then parts[#parts + 1] = "regex" end
      return #parts == 0 and "" or (" | " .. table.concat(parts, " | "))
    end

    local base_name = (opts.source and opts.source.name) or "Files"
    local function build_name()
      local suffix = build_name_suffix()
      local custom_desc = local_opts.custom_desc or "fuzzy"
      return ("%s (%s, %s, %s%s)"):format(base_name, custom_desc, tool.key, matcher, suffix)
    end

    local name = build_name()
    local cwd = (opts.source and opts.source.cwd) or vim.fn.getcwd()
    local spawn_opts = { cwd = cwd }
    local set_items_opts = { do_match = false }
    local process

    local function refresh_items(pattern)
      ---@diagnostic disable-next-line: undefined-field
      pcall(vim.loop.process_kill, process)
      local command = tool.build_command({
        pattern = pattern,
        flags = flags,
        excludes = excludes,
        regex_mode = regex_mode,
      })
      local current_query = MiniPick.get_picker_query() or {}
      set_items_opts = { do_match = #current_query > 0 }
      process = MiniPick.set_picker_items_from_cli(command, {
        set_items_opts = set_items_opts,
        spawn_opts = spawn_opts,
      })
    end

    local schedule_regex_refresh
    local function refresh_for_query()
      if regex_mode then
        local prompt = table.concat(MiniPick.get_picker_query() or {})
        last_regex_query = prompt
        schedule_regex_refresh(prompt)
      else
        refresh_items()
      end
    end

    local function toggle_tool_exclude_patterns(pattern_key)
      return function()
        local patterns = FlagManager.file_exclude_patterns[pattern_key]
        if not patterns then return end
        FlagManager.toggle_patterns(excludes, patterns)
        MiniPick.set_picker_opts({ source = { name = build_name() } })
        refresh_for_query()
        MiniPick.set_picker_query(MiniPick.get_picker_query() or {})
      end
    end

    local function toggle_tool_flag(flag_key)
      return function()
        FlagManager.toggle_flag(flags, flag_key)
        MiniPick.set_picker_opts({ source = { name = build_name() } })
        refresh_for_query()
        ---@diagnostic disable-next-line: param-type-mismatch
        MiniPick.set_picker_query(MiniPick.get_picker_query() or {})
      end
    end

    local function toggle_excl_flag(flag_key, key)
      return function()
        local enabled = FlagManager.has_flag(flags, flag_key)
        local excl = excl_flags[key] or {}
        if enabled then
          FlagManager.toggle_flag(flags, flag_key)
        else
          for _, other in ipairs(excl) do
            if other ~= flag_key and FlagManager.has_flag(flags, other) then FlagManager.toggle_flag(flags, other) end
          end
          FlagManager.toggle_flag(flags, flag_key)
        end
        MiniPick.set_picker_opts({ source = { name = build_name() } })
        refresh_for_query()
        ---@diagnostic disable-next-line: param-type-mismatch
        MiniPick.set_picker_query(MiniPick.get_picker_query() or {})
      end
    end

    local function cycle_flag(flag_keys, key)
      return function()
        FlagManager.cycle_flag(flags, flag_keys, excl_flags[key])
        MiniPick.set_picker_opts({ source = { name = build_name() } })
        refresh_for_query()
        ---@diagnostic disable-next-line: param-type-mismatch
        MiniPick.set_picker_query(MiniPick.get_picker_query() or {})
      end
    end
    local function toggle_regex_mode()
      if not tool.supports.regex then
        vim.notify("Regex mode is not supported by " .. tool.key)
        return
      end
      regex_mode = not regex_mode
      MiniPick.set_picker_opts({ source = { name = build_name() } })
      local prompt = table.concat(MiniPick.get_picker_query() or {})
      if regex_mode then
        last_regex_query = prompt
        schedule_regex_refresh(prompt)
      else
        refresh_items()
      end
      MiniPick.set_picker_query(MiniPick.get_picker_query() or {})
    end

    -- Mnemonics:
    --   alt-h: toggle hidden files
    --   alt-i: toggle no-ignore (show gitignored files)
    --   alt-x: exclude tests/specs
    --   alt-l: lua extension
    --   alt-r: ruby extension
    --   alt-j: js/ts extension
    --   alt-m: markdown extension
    --   alt-n: week (within 7 days)
    --   alt-t: today (within 1 day)
    --   alt-d: max depth 3
    --   alt-s: small files only (<100k)
    --   alt-p: regex match (fd regex) for the query

    local mappings = {}
    local function add_mapping(key, entry, enabled)
      if enabled then mappings[key] = entry end
    end

    -- Visibility
    add_mapping(
      "toggle_hidden",
      { char = "<M-h>", func = toggle_tool_flag("hidden") },
      FileTool.is_flag_supported(tool, "hidden")
    )
    add_mapping(
      "toggle_no_ignore",
      { char = "<M-i>", func = toggle_tool_flag("no_ignore") },
      FileTool.is_flag_supported(tool, "no_ignore")
    )
    -- Exclude patterns
    add_mapping(
      "toggle_no_tests",
      { char = "<M-x>", func = toggle_tool_exclude_patterns("no_tests") },
      tool.supports.excludes
    )
    -- Extension filters
    add_mapping(
      "toggle_ext_lua",
      { char = "<M-l>", func = toggle_tool_flag("ext_lua") },
      FileTool.is_flag_supported(tool, "ext_lua")
    )
    add_mapping(
      "toggle_ext_rb",
      { char = "<M-r>", func = toggle_tool_flag("ext_rb") },
      FileTool.is_flag_supported(tool, "ext_rb")
    )
    add_mapping(
      "toggle_ext_js",
      { char = "<M-j>", func = toggle_tool_flag("ext_js") },
      FileTool.is_flag_supported(tool, "ext_js")
    )
    add_mapping(
      "toggle_ext_md",
      { char = "<M-m>", func = toggle_tool_flag("ext_md") },
      FileTool.is_flag_supported(tool, "ext_md")
    )
    -- Time filters
    add_mapping(
      "toggle_week",
      -- { char = "<M-n>", func = toggle_excl_flag("today", "time") },
      { char = "<M-n>", func = cycle_flag({ "today", "two_days" }, "time") },
      FileTool.is_flag_supported(tool, "week")
    )
    -- Cycle time
    add_mapping(
      "cycle_time",
      { char = "<M-t>", func = cycle_flag({ "week", "two_days", "today" }, "time") },
      FileTool.is_flag_supported(tool, "today")
    )
    -- Depth/size
    add_mapping(
      "toggle_max_depth",
      { char = "<M-d>", func = toggle_tool_flag("max_depth_3") },
      FileTool.is_flag_supported(tool, "max_depth_3")
    )
    add_mapping(
      "toggle_small",
      { char = "<M-s>", func = toggle_tool_flag("small") },
      FileTool.is_flag_supported(tool, "small")
    )
    add_mapping("toggle_regex", { char = "<M-p>", func = toggle_regex_mode }, tool.supports.regex)

    local function show(buf_id, items, query)
      local path_max_width = local_opts.path_max_width or vim.g.minipick_path_max_width
      local path_truncate_mode = local_opts.path_truncate_mode or vim.g.minipick_path_truncate_mode or "smart"

      local display_items = items
      if path_max_width and path_max_width > 0 then
        display_items = vim.tbl_map(function(item)
          return truncate_path(item, path_max_width, path_truncate_mode)
        end, items)
      end

      MiniPick.default_show(buf_id, display_items, query, { show_icons = true })

      local cache = get_path_cache()
      vim.api.nvim_buf_clear_namespace(buf_id, cache.ns, 0, -1)
      local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
      for i, item in ipairs(display_items) do
        local line = lines[i] or ""
        local prefix_len = #line - #item
        if prefix_len < 0 then prefix_len = 0 end
        highlight_path(buf_id, i - 1, item, prefix_len)
      end
    end

    local debounce_ms = local_opts.regex_debounce_ms or vim.g.minipick_regex_debounce_ms or 80
    local refresh_token = 0
    schedule_regex_refresh = function(prompt)
      refresh_token = refresh_token + 1
      local token = refresh_token
      if debounce_ms <= 0 then
        refresh_items(prompt)
        return
      end
      vim.defer_fn(function()
        if not regex_mode then return end
        if token ~= refresh_token then return end
        if last_regex_query ~= prompt then return end
        refresh_items(prompt)
      end, debounce_ms)
    end

    local default_match = function(stritems, indices, query)
      local prompt = table.concat(query)
      if regex_mode then
        if last_regex_query ~= prompt then
          last_regex_query = prompt
          schedule_regex_refresh(prompt)
        end
        return indices
      end
      if prompt == "" then return indices end
      local tokens = vim.split(prompt, "%s+", { trimempty = true })
      if #tokens == 0 then return indices end

      local use_dp = matcher == "fzf_dp" or (matcher == "auto" and #indices <= (auto_opts.threshold or 20000))
      local matcher_impl = get_matcher(use_dp)

      local result = {}
      for _, index in ipairs(indices) do
        local path = stritems[index]
        local total_score = 0
        local matched = true

        for _, token in ipairs(tokens) do
          local score = matcher_impl:match_score(path, token, { is_file = true })
          if not score then
            matched = false
            break
          end
          total_score = total_score + score
        end

        if matched then table.insert(result, { index = index, score = total_score }) end
      end

      table.sort(result, function(a, b)
        if a.score == b.score then return a.index < b.index end
        return a.score > b.score
      end)

      return vim.tbl_map(function(item)
        return item.index
      end, result)
    end

    if opts.source.match == nil then opts.source.match = default_match end

    opts = vim.tbl_deep_extend("force", opts, {
      choose_marked = require("util.minipick_registry.trouble").trouble_choose_marked,
      source = { name = name, show = show },
      mappings = mappings,
    })

    MiniPick.registry.files_ext(local_opts, opts)
  end
end

M.setup = function(MiniPick)
  MiniPick.registry.fuzzy_files = create_fuzzy_files_picker(MiniPick)
end

return M

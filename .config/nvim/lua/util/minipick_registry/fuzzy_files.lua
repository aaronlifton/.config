local M = {}

-- Helpers
local FlagManager = require("util.flag_manager")
local FileTool = require("util.minipick_registry.file_tool")
local PickerState = require("util.minipick_registry.state")
local P = require("util.minipick_registry.picker").H

local excl_flags = { time = { "week", "two_days", "today" } }

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
    local fzf_opts = local_opts and local_opts.fzf or {}
    local show = require("util.minipick_registry.truncate_path_show").show(local_opts)

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
    -- TODO: hidden ON or OFF?
    -- Default: hidden files ON (matches typical usage)
    local default_flags = vim.tbl_extend(
      "force",
      { hidden = false },
      (local_opts and local_opts.fd_flags) or {},
      (local_opts and local_opts.tool_flags) or {}
    )
    local flags = {}
    if P.is_array_of(local_opts and local_opts.flags, "string") then
      for _, f in ipairs(local_opts.flags) do
        flags[f] = true
      end
    else
      for key, enabled in pairs(default_flags) do
        if enabled then flags[key] = true end
      end
    end
    flags = FileTool.filter_flags(tool, flags)

    local state = PickerState.reset("fuzzy_files", {
      excludes = excludes,
      flags = flags,
      regex_mode = false,
      last_regex_query = nil,
    })

    local_opts.flags = state.flags

    local function build_name_suffix()
      local parts = {}
      if #state.excludes > 0 then parts[#parts + 1] = "excl:" .. #state.excludes end
      local flag_parts = {}
      for flag, _ in pairs(state.flags) do
        flag_parts[#flag_parts + 1] = FileTool.flag_label(tool, flag)
      end
      if #flag_parts > 0 then parts[#parts + 1] = table.concat(flag_parts, ", ") end
      if state.regex_mode then parts[#parts + 1] = "regex" end
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
        flags = state.flags,
        excludes = state.excludes,
        regex_mode = state.regex_mode,
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
      if state.regex_mode then
        local prompt = table.concat(MiniPick.get_picker_query() or {})
        state.last_regex_query = prompt
        schedule_regex_refresh(prompt)
      else
        refresh_items()
      end
    end

    local function sync_query()
      ---@diagnostic disable-next-line: param-type-mismatch
      MiniPick.set_picker_query(MiniPick.get_picker_query() or {})
    end

    local function apply_change(mutator, refresh)
      if mutator then mutator() end
      MiniPick.set_picker_opts({ source = { name = build_name() } })
      if refresh ~= false then
        if refresh then
          refresh()
        else
          refresh_for_query()
        end
      end
      sync_query()
    end

    local function toggle_regex_mode()
      if not tool.supports.regex then
        vim.notify("Regex mode is not supported by " .. tool.key)
        return
      end
      apply_change(function()
        state.regex_mode = not state.regex_mode
        local prompt = table.concat(MiniPick.get_picker_query() or {})
        if state.regex_mode then
          state.last_regex_query = prompt
          schedule_regex_refresh(prompt)
        else
          refresh_items()
        end
      end, false)
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
    local mapping_specs = {
      {
        key = "toggle_hidden",
        char = "<M-h>",
        enabled = FileTool.is_flag_supported(tool, "hidden"),
        action = function()
          FlagManager.toggle_flag(state.flags, "hidden")
        end,
      },
      {
        key = "toggle_no_ignore",
        char = "<M-i>",
        enabled = FileTool.is_flag_supported(tool, "no_ignore"),
        action = function()
          FlagManager.toggle_flag(state.flags, "no_ignore")
        end,
      },
      {
        key = "toggle_no_tests",
        char = "<M-x>",
        enabled = tool.supports.excludes,
        action = function()
          FlagManager.toggle_patterns(state.excludes, FlagManager.file_exclude_patterns.no_tests)
        end,
      },
      {
        key = "toggle_ext_lua",
        char = "<M-l>",
        enabled = FileTool.is_flag_supported(tool, "ext_lua"),
        action = function()
          vim.notify("here")
          FlagManager.toggle_flag(state.flags, "ext_lua")
        end,
      },
      {
        key = "toggle_ext_rb",
        char = "<M-r>",
        enabled = FileTool.is_flag_supported(tool, "ext_rb"),
        action = function()
          FlagManager.toggle_flag(state.flags, "ext_rb")
        end,
      },
      {
        key = "toggle_ext_js",
        char = "<M-j>",
        enabled = FileTool.is_flag_supported(tool, "ext_js"),
        action = function()
          FlagManager.toggle_flag(state.flags, "ext_js")
        end,
      },
      {
        key = "toggle_ext_md",
        char = "<M-m>",
        enabled = FileTool.is_flag_supported(tool, "ext_md"),
        action = function()
          FlagManager.toggle_flag(state.flags, "ext_md")
        end,
      },
      {
        key = "toggle_week",
        char = "<M-n>",
        enabled = FileTool.is_flag_supported(tool, "week"),
        action = function()
          FlagManager.cycle_flag(state.flags, { "today", "two_days" }, excl_flags.time)
        end,
      },
      {
        key = "cycle_time",
        char = "<M-t>",
        enabled = FileTool.is_flag_supported(tool, "today"),
        action = function()
          FlagManager.cycle_flag(state.flags, { "week", "two_days", "today" }, excl_flags.time)
        end,
      },
      {
        key = "toggle_max_depth",
        char = "<M-d>",
        enabled = FileTool.is_flag_supported(tool, "max_depth_3"),
        action = function()
          FlagManager.toggle_flag(state.flags, "max_depth_3")
        end,
      },
      {
        key = "toggle_small",
        char = "<M-s>",
        enabled = FileTool.is_flag_supported(tool, "small"),
        action = function()
          FlagManager.toggle_flag(state.flags, "small")
        end,
      },
    }

    for _, spec in ipairs(mapping_specs) do
      if spec.enabled then
        local action = spec.action
        mappings[spec.key] = {
          char = spec.char,
          func = function()
            apply_change(action)
          end,
        }
      end
    end

    if tool.supports.regex then mappings.toggle_regex = { char = "<M-p>", func = toggle_regex_mode } end

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
        if not state.regex_mode then return end
        if token ~= refresh_token then return end
        if state.last_regex_query ~= prompt then return end
        refresh_items(prompt)
      end, debounce_ms)
    end

    local default_match = function(stritems, indices, query)
      local prompt = table.concat(query)
      if state.regex_mode then
        if state.last_regex_query ~= prompt then
          state.last_regex_query = prompt
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

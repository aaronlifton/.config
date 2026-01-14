local M = {}

-- Helpers
local H = {}

local FlagManager = require("util.minipick_registry.flag_manager")

local function get_path_cache()
  if H._path_cache ~= nil then return H._path_cache end
  H._path_cache = {
    ns = vim.api.nvim_create_namespace("minipick-fuzzy-files"),
  }
  return H._path_cache
end

H.is_array_of = function(x, ref_type)
  if not vim.tbl_islist(x) then return false end
  for i = 1, #x do
    if type(x[i]) ~= ref_type then return false end
  end
  return true
end

local function hl_group_or(group, fallback)
  if vim.fn.hlexists(group) == 1 then return group end
  return fallback
end

local function is_hidden_path(path)
  if path:sub(1, 1) == "." then return true end
  return path:find("/%.") ~= nil
end

local function highlight_path(buf_id, row, path, col_offset)
  if path == "" then return end

  local base_hl = hl_group_or("SnacksPickerFile", "MiniPickNormal")
  local dir_hl = hl_group_or("SnacksPickerDir", "MiniPickNormal")
  if is_hidden_path(path) then base_hl = hl_group_or("SnacksPickerPathHidden", base_hl) end

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

local function create_fuzzy_files_picker()
  -- Example override:
  -- MiniPick.registry.fuzzy_files({
  --   matcher = "auto", -- "fzf" | "fzf_dp" | "auto"
  --   fzf = { smartcase = false, filename_bonus = false },
  --   auto = { threshold = 20000 },
  -- }, {})
  return function(local_opts, opts)
    local matcher = ((local_opts and local_opts.matcher) or (opts and opts.matcher) or "fzf")
    local auto_opts = vim.tbl_deep_extend(
      "force",
      { threshold = 20000 },
      (local_opts and local_opts.auto) or {},
      (opts and opts.auto) or {}
    )
    local fzf_opts = vim.tbl_deep_extend("force", {}, (local_opts and local_opts.fzf) or {}, (opts and opts.fzf) or {})

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
    local default_flags = vim.tbl_extend("force", { hidden = true }, (local_opts and local_opts.fd_flags) or {})
    local flags
    if H.is_array_of(local_opts and local_opts.flags, "string") then
      flags = vim.list_extend({}, local_opts.flags)
    else
      flags = {}
      for key, enabled in pairs(default_flags) do
        if enabled then table.insert(flags, key) end
      end
    end

    local function build_name_suffix()
      local parts = {}
      if #excludes > 0 then parts[#parts + 1] = "excl:" .. #excludes end
      local flag_parts = {}
      for _, flag in ipairs(flags) do
        flag_parts[#flag_parts + 1] = FlagManager.fd_flags[flag] or flag
      end
      if #flag_parts > 0 then parts[#parts + 1] = table.concat(flag_parts, ", ") end
      return #parts == 0 and "" or (" | " .. table.concat(parts, " | "))
    end

    local function build_name()
      local suffix = build_name_suffix()
      if opts.source and opts.source.name then
        local custom_desc = local_opts.custom_desc or "fuzzy"
        return ("%s (%s, %s%s)"):format(opts.source.name, custom_desc, matcher, suffix)
      end
      return ("Files (fuzzy, %s%s)"):format(matcher, suffix)
    end

    local function build_fd_command()
      local cmd = { "fd", "--type", "f", "--color", "never", "--follow", "--exclude", ".git" }
      -- Add flags (including --hidden if enabled)
      for _, flag in ipairs(flags) do
        local flag_value = FlagManager.fd_flags[flag] or flag
        for _, part in ipairs(vim.split(flag_value, "%s+", { trimempty = true })) do
          table.insert(cmd, part)
        end
      end
      -- Add excludes
      for _, pattern in ipairs(excludes) do
        table.insert(cmd, "--exclude")
        table.insert(cmd, pattern)
      end
      return cmd
    end

    local name = build_name()
    local cwd = (opts.source and opts.source.cwd) or vim.fn.getcwd()
    local spawn_opts = { cwd = cwd }
    local set_items_opts = { do_match = false }
    local process

    local function refresh_items()
      ---@diagnostic disable-next-line: undefined-field
      pcall(vim.loop.process_kill, process)
      local command = build_fd_command()
      process = MiniPick.set_picker_items_from_cli(command, {
        set_items_opts = set_items_opts,
        spawn_opts = spawn_opts,
      })
    end

    local function toggle_fd_exclude_patterns(pattern_key)
      return function()
        local patterns = FlagManager.fd_exclude_patterns[pattern_key]
        if not patterns then return end
        -- Check if all patterns are present
        local all_present = true
        for _, pattern in ipairs(patterns) do
          local found = false
          for _, e in ipairs(excludes) do
            if e == pattern then
              found = true
              break
            end
          end
          if not found then
            all_present = false
            break
          end
        end
        if all_present then
          -- Remove all patterns
          for _, pattern in ipairs(patterns) do
            for i = #excludes, 1, -1 do
              if excludes[i] == pattern then
                table.remove(excludes, i)
                break
              end
            end
          end
        else
          -- Add missing patterns
          for _, pattern in ipairs(patterns) do
            local found = false
            for _, e in ipairs(excludes) do
              if e == pattern then
                found = true
                break
              end
            end
            if not found then table.insert(excludes, pattern) end
          end
        end
        MiniPick.set_picker_opts({ source = { name = build_name() } })
        refresh_items()
      end
    end

    local function toggle_fd_flag(flag_key)
      return function()
        FlagManager.toggle_flag(flags, flag_key)
        MiniPick.set_picker_opts({ source = { name = build_name() } })
        refresh_items()
      end
    end

    -- Mnemonics:
    --   alt-h: toggle hidden files
    --   alt-i: toggle no-ignore (show gitignored files)
    --   alt-x: exclude tests/specs
    --   alt-l: lua extension
    --   alt-r: ruby extension
    --   alt-j: js/ts extension
    --   alt-m: markdown extension
    --   alt-n: newer (within 7 days)
    --   alt-t: today (within 1 day)
    --   alt-d: max depth 3
    --   alt-s: small files only (<100k)

    local mappings = {
      -- Visibility
      toggle_hidden = { char = "<M-h>", func = toggle_fd_flag("hidden") },
      toggle_no_ignore = { char = "<M-i>", func = toggle_fd_flag("no_ignore") },
      -- Exclude patterns
      toggle_no_tests = { char = "<M-x>", func = toggle_fd_exclude_patterns("no_tests") },
      -- Extension filters
      toggle_ext_lua = { char = "<M-l>", func = toggle_fd_flag("ext_lua") },
      toggle_ext_rb = { char = "<M-r>", func = toggle_fd_flag("ext_rb") },
      toggle_ext_js = { char = "<M-j>", func = toggle_fd_flag("ext_js") },
      toggle_ext_md = { char = "<M-m>", func = toggle_fd_flag("ext_md") },
      -- Time filters
      toggle_newer = { char = "<M-n>", func = toggle_fd_flag("newer") },
      toggle_two_days = { char = "<M-2>", func = toggle_fd_flag("two_days") },
      toggle_today = { char = "<M-t>", func = toggle_fd_flag("today") },
      -- Depth/size
      toggle_max_depth = { char = "<M-d>", func = toggle_fd_flag("max_depth_3") },
      toggle_small = { char = "<M-s>", func = toggle_fd_flag("small") },
    }

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

    local default_match = function(stritems, indices, query)
      local prompt = table.concat(query)
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

    -- MiniPick.builtin.files
    MiniPick.registry.files_ext(
      local_opts,
      vim.tbl_deep_extend("force", opts or {}, {
        source = {
          match = opts.source.match or default_match,
          choose_marked = require("util.minipick_registry.trouble").trouble_choose_marked,
          name = name,
          show = show,
        },
        mappings = mappings,
      })
    )
  end
end

M.setup = function(MiniPick)
  MiniPick.registry.fuzzy_files = create_fuzzy_files_picker(MiniPick)
end

return M

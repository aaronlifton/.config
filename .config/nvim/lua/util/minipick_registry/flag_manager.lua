local M = {}

-- Predefined fd exclude patterns
M.fd_exclude_patterns = {
  no_tests = { "spec/**/*", "**{__tests__,tests?}**", "{test,tests}/" },
}

-- Predefined fd flags
M.fd_flags = {
  -- Core visibility flags
  hidden = "--hidden",
  no_ignore = "--no-ignore",
  -- Extension filters
  ext_lua = "-e lua",
  ext_rb = "-e rb",
  ext_js = "-e js -e ts -e tsx -e jsx",
  ext_json = "-e json",
  ext_md = "-e md",
  -- Time filters
  newer = "--changed-within 7d",
  today = "--changed-within 1d",
  two_days = "--changed-within 2d",
  -- Depth limits
  max_depth_3 = "--max-depth 3",
  max_depth_5 = "--max-depth 5",
  -- Size filters
  small = "--size -100k", -- files < 100KB
  regex = "--regex",
}

M.rg_flags = {
  glob_case_insensitive = "--glob-case-insensitive",
  context = "--context 2",
  max_count = "--max-count 1",
  max_depth = "--max-depth 3",
  pcre2 = "--pcre2",
  fixed_strings = "--fixed-strings",
  dotall = "-U", -- dotall (?s:.) ; regular (?-s:.)
  sort_path = "--sort path",
  type_lua = "-t lua",
  type_ruby = "-t ruby",
  type_conf = "--type-add 'conf:*.{toml,yaml,yml,ini,json}' -t conf",
  type_web = "--type-add 'web:*.{js,ts,tsx,css,scss,html,vue,svelte}' -t web",
  hidden = "--hidden",
  no_ignore = "--no-ignore",
}

function M.flag_index(flags, flag)
  for i, value in ipairs(flags) do
    if value == flag then return i end
  end
  return nil
end

function M.has_flag(flags, flag)
  return M.flag_index(flags, flag) ~= nil
end

function M.toggle_flag(flags, flag)
  local idx = M.flag_index(flags, flag)
  if idx then
    table.remove(flags, idx)
  else
    table.insert(flags, flag)
  end
end

function M.toggle_glob_pattern(globs, pattern)
  if not pattern then return false end
  local pattern_parts = vim.split(pattern, "%s+", { trimempty = true })
  local all_present = true
  for _, part in ipairs(pattern_parts) do
    local found = false
    for _, g in ipairs(globs) do
      if g == part then
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
    for _, part in ipairs(pattern_parts) do
      for i = #globs, 1, -1 do
        if globs[i] == part then
          table.remove(globs, i)
          break
        end
      end
    end
  else
    for _, part in ipairs(pattern_parts) do
      local found = false
      for _, g in ipairs(globs) do
        if g == part then
          found = true
          break
        end
      end
      if not found then table.insert(globs, part) end
    end
  end

  return true
end

function M.build_flag_mappings(opts)
  return {
    add_glob = { char = "<C-o>", func = opts.add_glob },
    remove_glob = { char = "<C-k>", func = opts.remove_glob },
    toggle_no_ignore = { char = "<M-i>", func = opts.toggle_no_ignore },
    toggle_hidden = { char = "<M-h>", func = opts.toggle_hidden },
    -- Iglob pattern toggles
    toggle_js_no_tests = { char = "<M-j>", func = opts.toggle_iglob_pattern("js_no_tests") },
    toggle_js_tests = { char = "<M-o>", func = opts.toggle_iglob_pattern("js_tests") },
    toggle_tests = { char = "<M-t>", func = opts.toggle_iglob_pattern("tests") },
    toggle_no_tests = { char = "<M-x>", func = opts.toggle_iglob_pattern("no_tests") },
    toggle_js_ts = { char = "<M-s>", func = opts.toggle_iglob_pattern("js_ts") },
    toggle_no_bundle = { char = "<M-m>", func = opts.toggle_iglob_pattern("no_bundle") },
    -- Extra flag toggles
    toggle_type_conf = { char = "<M-c>", func = opts.toggle_extra_flag("type_conf") },
    toggle_type_web = { char = "<M-w>", func = opts.toggle_extra_flag("type_web") },
    toggle_glob_case = { char = "<M-g>", func = opts.toggle_extra_flag("glob_case_insensitive") },
    toggle_context = { char = "<M-k>", func = opts.toggle_extra_flag("context") },
    toggle_max_count = { char = "<M-n>", func = opts.toggle_extra_flag("max_count") },
    toggle_max_depth = { char = "<M-d>", func = opts.toggle_extra_flag("max_depth") },
    toggle_pcre2 = { char = "<M-p>", func = opts.toggle_extra_flag("pcre2") },
    toggle_dotall = { char = "<M-u>", func = opts.toggle_dotall },
    toggle_type_lua = { char = "<M-l>", func = opts.toggle_extra_flag("type_lua") },
    toggle_type_ruby = { char = "<M-r>", func = opts.toggle_extra_flag("type_ruby") },
    toggle_sort_path = { char = "<M-f>", func = opts.toggle_extra_flag("sort_path") },
    toggle_ts_highlight = { char = "<M-y>", func = opts.toggle_ts_highlight },
    toggle_path_width = { char = "<M-z>", func = opts.toggle_path_width },
  }
end

return M

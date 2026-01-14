local M = {}

local function map_gsub(items, pattern, replacement)
  return vim.tbl_map(function(item)
    item, _ = string.gsub(item, pattern, replacement)
    return item
  end, items)
end

local function split_grep_item(item)
  if type(item) ~= "string" then return nil end
  local parts = vim.split(item, "\0", { plain = true })
  if #parts < 4 then return nil end
  return {
    path = parts[1],
    lnum = tonumber(parts[2]),
    col = tonumber(parts[3]),
    text = parts[4],
  }
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

local function find_last(haystack, needle)
  if needle == "" then return nil end
  local last, init = nil, 1
  while true do
    local s = string.find(haystack, needle, init, true)
    if not s then break end
    last, init = s, s + 1
  end
  return last
end

local function get_ts_cache()
  if M._ts_cache ~= nil then return M._ts_cache end
  M._ts_cache = {
    ns = vim.api.nvim_create_namespace("minipick-iglob-ts"),
    bufs = {},
    queries = {},
  }
  return M._ts_cache
end

local function ensure_scratch_buf(lang)
  local cache = get_ts_cache()
  if cache.bufs[lang] and vim.api.nvim_buf_is_valid(cache.bufs[lang]) then return cache.bufs[lang] end
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].bufhidden = "wipe"
  cache.bufs[lang] = buf
  return buf
end

local function get_highlight_query(lang)
  local cache = get_ts_cache()
  if cache.queries[lang] ~= nil then return cache.queries[lang] end
  local query = vim.treesitter.query.get(lang, "highlights")
  cache.queries[lang] = query
  return query
end

local function highlight_line_ts(buf_id, row, text, lang, col_offset)
  local cache = get_ts_cache()
  local scratch = ensure_scratch_buf(lang)
  vim.api.nvim_buf_set_lines(scratch, 0, -1, false, { text })

  local ok_parser, parser = pcall(vim.treesitter.get_parser, scratch, lang, { error = false })
  if not ok_parser or not parser then return end

  local query = get_highlight_query(lang)
  if not query then return end

  local tree = parser:parse()[1]
  if not tree then return end

  local root = tree:root()
  local ext_opts = { hl_mode = "combine", priority = 150 }
  for id, node in query:iter_captures(root, scratch, 0, 1) do
    local capture = query.captures[id]
    local srow, scol, erow, ecol = node:range()
    if srow == 0 and erow == 0 and ecol > scol then
      ext_opts.hl_group = "@" .. capture
      ext_opts.end_row = row
      ext_opts.end_col = col_offset + ecol
      vim.api.nvim_buf_set_extmark(buf_id, cache.ns, row, col_offset + scol, ext_opts)
    end
  end
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
    vim.api.nvim_buf_set_extmark(buf_id, get_ts_cache().ns, row, col_offset, ext_opts)

    ext_opts.hl_group = base_hl
    ext_opts.end_row = row
    ext_opts.end_col = col_offset + #dir + 1 + #base
    vim.api.nvim_buf_set_extmark(buf_id, get_ts_cache().ns, row, col_offset + #dir + 1, ext_opts)
  else
    ext_opts.hl_group = base_hl
    ext_opts.end_row = row
    ext_opts.end_col = col_offset + #path
    vim.api.nvim_buf_set_extmark(buf_id, get_ts_cache().ns, row, col_offset, ext_opts)
  end
end

local function get_minipick()
  return require("mini.pick")
end

M.default_show_with_icons = function(buf_id, items, query)
  local sep = string.char(31)
  local sep_pattern = vim.pesc(sep)
  items = map_gsub(items, "%z", sep)
  items = require("mini.align").align_strings(items, {
    justify_side = { "left", "right", "right" },
    merge_delimiter = { "", " ", "", " ", "" },
    split_pattern = sep_pattern,
  })
  items = map_gsub(items, sep, "\0")
  get_minipick().default_show(buf_id, items, query, { show_icons = true })
end

-- Configuration:
--   vim.g.minipick_ts_highlight = true/false (default: true)
--   vim.g.minipick_max_ts_items = number (default: 200)
--   vim.g.minipick_path_max_width = number (default: nil, no truncation)
--   vim.g.minipick_path_truncate_mode = "head"|"middle"|"smart" (default: "smart")
M.grep_ts_show = function(buf_id, items, query, show_opts)
  show_opts = show_opts or {}
  local ts_highlight_override = show_opts.ts_highlight
  local path_max_width = show_opts.path_max_width or vim.g.minipick_path_max_width
  local path_truncate_mode = show_opts.path_truncate_mode or vim.g.minipick_path_truncate_mode or "smart"

  -- Apply path truncation if configured
  local display_items = items
  if path_max_width and path_max_width > 0 then
    display_items = vim.tbl_map(function(item)
      local parts = vim.split(item, "\0", { plain = true })
      if #parts >= 1 then
        parts[1] = truncate_path(parts[1], path_max_width, path_truncate_mode)
        return table.concat(parts, "\0")
      end
      return item
    end, items)
  end

  local sep = string.char(31)
  local sep_pattern = vim.pesc(sep)
  local aligned_items = map_gsub(display_items, "%z", sep)
  aligned_items = require("mini.align").align_strings(aligned_items, {
    justify_side = { "left", "right", "right" },
    merge_delimiter = { "", " ", "", " ", "" },
    split_pattern = sep_pattern,
  })
  aligned_items = map_gsub(aligned_items, sep, "│")

  local tab_spaces = string.rep(" ", vim.o.tabstop)
  local aligned_lines = vim.tbl_map(function(l)
    return l:gsub("%z", "│"):gsub("[\r\n]", " "):gsub("\t", tab_spaces)
  end, aligned_items)

  get_minipick().default_show(buf_id, aligned_items, query, { show_icons = true })

  -- Check if TS highlighting is enabled (override > global > default true)
  local ts_enabled = ts_highlight_override
  if ts_enabled == nil then ts_enabled = vim.g.minipick_ts_highlight end
  if ts_enabled == nil then ts_enabled = true end
  if not ts_enabled then return end

  local cache = get_ts_cache()
  vim.api.nvim_buf_clear_namespace(buf_id, cache.ns, 0, -1)
  local max_ts_items = vim.g.minipick_max_ts_items or 200
  if #items > max_ts_items then return end

  local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
  for i, item in ipairs(items) do
    local parsed = split_grep_item(item)
    if parsed and parsed.text then
      local display_parsed = split_grep_item(display_items[i] or item)
      local display_path = display_parsed and display_parsed.path or parsed.path or ""
      local line = lines[i] or ""
      local aligned_line = aligned_lines[i] or ""
      local prefix_len = #line - #aligned_line
      highlight_path(buf_id, i - 1, display_path, prefix_len)

      local ft = vim.filetype.match({ filename = parsed.path })
      if ft and ft ~= "" then
        local ok_lang, lang = pcall(vim.treesitter.language.get_lang, ft)
        lang = ok_lang and lang or ft
        local text_start = find_last(aligned_line, parsed.text) or (#aligned_line - #parsed.text + 1)
        if text_start < 1 then text_start = 1 end
        local col_offset = prefix_len + text_start - 1
        highlight_line_ts(buf_id, i - 1, parsed.text, lang, col_offset)
      end
    end
  end
end

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

M.iglob_patterns = {
  js_no_tests = "*.{js,ts,tsx} !*{test,spec}*",
  js_tests = "*.{js,ts,tsx} **test**",
  tests = "**{test,spec}**",
  no_tests = "!**{test,spec}** !spec/**/* !**/test*/** !__tests__",
  js_ts = "*.{js,ts,tsx}",
  no_bundle = "!**{umd,cjs,esm}**",
}

function M.parse_query(raw)
  local search, iglob = raw:match("^(.-)%s+%-%-%s+(.*)$")
  if not search then return vim.trim(raw), {} end

  local patterns = {}
  for _, part in ipairs(vim.split(vim.trim(iglob), "%s+", { trimempty = true })) do
    patterns[#patterns + 1] = part
  end

  return vim.trim(search), patterns
end

function M.grep_get_command(pattern, globs, flags)
  local res = {
    "rg",
    "--column",
    "--line-number",
    "--no-heading",
    "--field-match-separator",
    "\\x00",
    "--color=never",
  }
  if flags then
    for _, flag in ipairs(flags) do
      local rg_flag = M.rg_flags[flag] or flag
      for _, part in ipairs(vim.split(rg_flag, "%s+", { trimempty = true })) do
        table.insert(res, part)
      end
    end
  end
  for _, g in ipairs(globs) do
    table.insert(res, "--iglob")
    -- NOTE: no `*` as default is important to not "override" ignoring files
    table.insert(res, g)
  end
  local case = vim.o.ignorecase and (vim.o.smartcase and "smart-case" or "ignore-case") or "case-sensitive"
  vim.list_extend(res, { "--" .. case, "--", pattern })
  return res
end

return M

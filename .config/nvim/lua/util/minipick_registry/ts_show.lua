local M = {}

local function get_ts_cache()
  if M._ts_cache ~= nil then return M._ts_cache end
  M._ts_cache = {
    ns = vim.api.nvim_create_namespace("minipick-iglob-ts"),
    bufs = {},
    queries = {},
  }
  return M._ts_cache
end

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

M.ts_show = function(buf_id, items, query)
  local sep = string.char(31)
  local sep_pattern = vim.pesc(sep)
  local aligned_items = map_gsub(items, "%z", sep)
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

  MiniPick.default_show(buf_id, aligned_items, query, { show_icons = true })

  local cache = get_ts_cache()
  vim.api.nvim_buf_clear_namespace(buf_id, cache.ns, 0, -1)

  local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
  for i, item in ipairs(items) do
    local parsed = split_grep_item(item)
    if parsed and parsed.text then
      local ft = vim.filetype.match({ filename = parsed.path })
      if ft and ft ~= "" then
        local ok_lang, lang = pcall(vim.treesitter.language.get_lang, ft)
        lang = ok_lang and lang or ft
        local line = lines[i] or ""
        local aligned_line = aligned_lines[i] or ""
        local prefix_len = #line - #aligned_line
        local text_start = find_last(aligned_line, parsed.text) or (#aligned_line - #parsed.text + 1)
        if text_start < 1 then text_start = 1 end
        local col_offset = prefix_len + text_start - 1
        highlight_line_ts(buf_id, i - 1, parsed.text, lang, col_offset)
      end
    end
  end
end

return M

---@class util.selection
---@field last_selection table<string, any>|nil
local M = {
  last_selection = nil,
}
local function get_cursor()
  local cursor = vim.api.nvim_win_get_cursor(0)
  return { row = cursor[1], col = cursor[2] }
end
local function get_selection_lines()
  local vpos = vim.fn.getpos("v")
  local begin_pos = { row = vpos[2], col = vpos[3] - 1 }
  local end_pos = get_cursor()
  local cond = (begin_pos.row < end_pos.row) or (begin_pos.row == end_pos.row and begin_pos.col <= end_pos.col)
  if cond then
    return { start_line = begin_pos, end_line = end_pos }
  else
    return { start_line = end_pos, end_line = begin_pos }
  end
end

M.get_selection2 = function()
  local vpos = vim.fn.getpos("v")
  local cursor = vim.api.nvim_win_get_cursor(0)
  local start = { row = cursor[1], col = cursor[2] }
  local stop = { row = vpos[2] + 1, col = vpos[3] }
  -- vim.api.nvim_echo({ { vim.inspect({ start = start, stop = stop }), "Normal" } }, true, {})

  return {
    start = start,
    stop = stop,
  }
end

--- 0-based index for row and col
M.get_selection3 = function()
  local vpos = vim.fn.getpos("v")
  local cursor = vim.api.nvim_win_get_cursor(0)
  local start = { row = cursor[1] - 1, col = cursor[2] }
  local stop = { row = vpos[2] - 1, col = vpos[3] }
  -- vim.api.nvim_echo({ { vim.inspect({ start = start, stop = stop }), "Normal" } }, true, {})

  return {
    start = start,
    stop = stop,
  }
end

M.get_selection4 = function()
  local start = vim.fn.getpos("'v")
  local stop = vim.fn.getpos("'.")
  local mode = vim.fn.visualmode()
  vim.api.nvim_echo({
    { "start stop\n", "Title" },
    { vim.inspect({ start = start, stop = stop }), "Normal" },
  }, true, {})

  -- For linewise selection ('V'), we want to include the entire lines

  if mode == "V" then
    -- local start = vim.fn.getpos("'<")
    -- local stop = vim.fn.getpos("'>")
    vim.api.nvim_echo({ { "Here: V", "Normal" } }, true, {})
    return {
      start = {
        row = stop[2] - start[2],
        col = stop[3] - start[3],
      },
      stop = {
        -- row = stop[2] - 1,
        row = stop[2],
        col = vim.v.maxcol,
      },
    }
  end

  -- For characterwise selection ('v')
  return {
    start = {
      row = start[2] - 1,
      col = start[3] - 1,
    },
    stop = {
      row = stop[2] - 1,
      col = stop[3], -- stop col can be vim.v.maxcol which means entire line
    },
  }
end

M.save_selection = function()
  -- local mode = vim.fn.visualmode()
  -- if mode == "V" then
  --   local start = vim.fn.getpos("'<")
  --   local stop = vim.fn.getpos("'>")
  --   local selection = {
  --     start_row = start[2],
  --     start_col = start[3],
  --     finish_row = stop[2],
  --     finish_col = stop[3],
  --   }
  --   M.last_selection = selection
  --   return selection
  -- end
  local bufnr = vim.api.nvim_get_current_buf()
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(bufnr, "<"))
  local finish_row, finish_col = unpack(vim.api.nvim_buf_get_mark(bufnr, ">"))
  -- if finish_col == vim.v.maxcol then
  --   local finish_row_last_char_position = vim.api.nvim_buf_get_lines(bufnr, finish_row, finish_row + 1, false)[1]:len()
  --   finish_col = finish_row_last_char_position
  -- end
  if start_row == 0 or finish_row == 0 then return nil end
  if start_row > finish_row then
    start_row, finish_row = finish_row, start_row
  end
  local selection = {
    start_row = start_row,
    start_col = start_col,
    finish_row = finish_row,
    finish_col = finish_col,
  }
  M.last_selection = selection
  return selection
end

M.restore_selection = function(bufnr)
  local sel = M.last_selection
  if sel then
    -- vim.api.nvim_buf_set_mark(bufnr, "<", sel.start_row, sel.start_col, {})
    -- vim.api.nvim_buf_set_mark(bufnr, ">", sel.finish_row, sel.finish_col, {})
    vim.fn.setpos("'<", { 0, sel.start_row, sel.start_col, 0 })
    vim.fn.setpos("'>", { 0, sel.finish_row, sel.finish_col, 0 })
  end
end

-- M.restore_selection_0_based = function(bufnr)
--   local sel = M.last_selection
--   vim.api.nvim_echo({
--     { "M.restore_selection_0_based", "Special" },
--     { vim.inspect(sel), "Normal" },
--   }, true, {})
--   if sel then
--     vim.fn.setpos("'<", { 0, sel.start_row, sel.start_col, 0 })
--     vim.fn.setpos("'>", { 0, sel.finish_row, sel.finish_col, 0 })
--   end
-- end

local function normalize_indentation(lines)
  local min_indent = nil
  local use_tabs = false
  -- measure minimal common indentation for lines with content
  for i, line in ipairs(lines) do
    lines[i] = line
    -- skip whitespace only lines
    if not line:match("^%s*$") then
      local indent = line:match("^%s*")
      -- contains tabs
      if indent:match("\t") then use_tabs = true end
      if min_indent == nil or #indent < min_indent then min_indent = #indent end
    end
  end
  if min_indent == nil then min_indent = 0 end
  local prefix = string.rep(use_tabs and "\t" or " ", min_indent)

  for i, line in ipairs(lines) do
    lines[i] = line:sub(min_indent + 1)
  end
  return lines
end

--- Get the current selection text and range, with common indentation removed
--- Indentation code from parrot.nvim/lua/parrot/chat_handler.lua:1156
-- TODO: compare with model.nvim/lua/model/util/init.lua:340
--- @param opts { normalize_indentation: boolean }
--- @return { selection: string, start_line: number, end_line: number }|nil
M.get_selection = function(opts)
  local defaults = {
    normalize_indentation = true,
  }
  opts = vim.tbl_extend("force", defaults, opts or {})
  local buf = vim.api.nvim_get_current_buf()
  -- local start_pos = vim.fn.getpos("'<")
  -- local end_pos = vim.fn.getpos("'>")
  -- local start_line = start_pos[2]
  -- local end_line = end_pos[2]
  local selection_lines = get_selection_lines()
  local start_line = selection_lines.start_line.row
  local end_line = selection_lines.end_line.row
  local lines = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)

  if normalize_indentation then lines = normalize_indentation(lines) end

  local selection = table.concat(lines, "\n")

  if selection == "" then return nil end
  return { selection = selection, start_line = start_line, end_line = end_line }
end

M.markdown_code_fence = function()
  local selection = M.get_selection()
  if not selection then return end

  local buf = vim.api.nvim_get_current_buf()
  local filetype = vim.bo[buf].filetype
  local filename = vim.fn.bufname(buf)

  local position = string.format("(%s-%s)", selection.start_line, selection.end_line)
  return string.format(
    "File: `%s` %s\n```%s\n%s\n```\n\n",
    vim.fn.fnamemodify(filename, ":~:."),
    position,
    filetype,
    selection.selection
  )
end

return M

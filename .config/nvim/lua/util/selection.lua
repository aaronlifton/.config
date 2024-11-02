---@class util.selection
local M = {}
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

-- TODO: compare with model.nvim/lua/model/util/init.lua:340
--- Get the current selection text and range, with common indentation removed
--- @return { selection: string, start_line: number, end_line: number }
M.get_selection = function()
  local buf = vim.api.nvim_get_current_buf()
  -- local start_pos = vim.fn.getpos("'<")
  -- local end_pos = vim.fn.getpos("'>")
  -- local start_line = start_pos[2]
  -- local end_line = end_pos[2]
  local selection_lines = get_selection_lines()
  local start_line = selection_lines.start_line.row
  local end_line = selection_lines.end_line.row
  local lines = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)

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
  prefix = string.rep(use_tabs and "\t" or " ", min_indent)

  for i, line in ipairs(lines) do
    lines[i] = line:sub(min_indent + 1)
  end

  selection = table.concat(lines, "\n")

  if selection == "" then
    vim.notify("Please select some text to rewrite", vim.log.levels.ERROR, { title = "get_selection" })
    return
  end
  return { selection = selection, start_line = start_line, end_line = end_line }
end

return M

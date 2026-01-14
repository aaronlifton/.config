---@class util.selection
---@field last_selection table<string, any>|nil
local M = {
  last_selection = nil,
}

---@class SelectionResult
---@field content string Selected content
---@field range SelectionRange Selection range
local SelectionResult = {}
SelectionResult.__index = SelectionResult

-- Create a selection content and range
---@param content string Selected content
---@param range SelectionRange Selection range
function SelectionResult:new(content, range)
  local instance = setmetatable({}, SelectionResult)
  instance.content = content
  instance.range = range
  return instance
end

---@class SelectionRange
---@field start RangeSelection start point
---@field finish RangeSelection Selection end point
local SelectionRange = {}
SelectionRange.__index = SelectionRange

---@class RangeSelection: table<string, integer>
---@field lnum number
---@field col number

---Create a selection range
---@param start RangeSelection Selection start point
---@param finish RangeSelection Selection end point
function SelectionRange:new(start, finish)
  local instance = setmetatable({}, SelectionRange)
  instance.start = start
  instance.finish = finish
  return instance
end

function M.normalize_indentation(lines)
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

--- Returns the current selection surrounded by a markdown code fence
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

--- Get the current selection text and range, with common indentation removed
--- Indentation code from parrot.nvim/lua/parrot/chat_handler.lua:1156
--- @param opts? { normalize_indentation: boolean }
--- @return { selection: string, start_line: number, end_line: number }|nil
-- TODO: compare with model.nvim/lua/model/util/init.lua:340
function M.get_selection(opts)
  local defaults = {
    normalize_indentation = true,
  }
  opts = vim.tbl_extend("force", defaults, opts or {})

  local buf = vim.api.nvim_get_current_buf()
  local selection_lines = get_selection_lines()
  local start_line = selection_lines.start_line.row
  local end_line = selection_lines.end_line.row
  local lines = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)

  lines = M.normalize_indentation(lines)

  local selection = table.concat(lines, "\n")

  if selection == "" then return nil end
  return { selection = selection, start_line = start_line, end_line = end_line }
end

-- Also handles columns from visual mode selections, not just full lines
function M.get_selection2()
  local buf = vim.api.nvim_get_current_buf()
  local selection_lines = get_selection_lines()
  local start_pos = selection_lines.start_line
  local end_pos = selection_lines.end_line

  -- Get all the lines in the selection
  local lines = vim.api.nvim_buf_get_lines(buf, start_pos.row - 1, end_pos.row, false)

  -- If selection is within a single line
  if start_pos.row == end_pos.row then
    lines[1] = lines[1]:sub(start_pos.col + 1, end_pos.col + 1)
  else
    -- First line: from start column to end
    lines[1] = lines[1]:sub(start_pos.col + 1)
    -- Last line: from start to end column
    lines[#lines] = lines[#lines]:sub(1, end_pos.col + 1)
  end

  local selection = table.concat(lines, "\n")
  if selection == "" then return nil end

  return {
    selection = selection,
    start_line = start_pos.row,
    end_line = end_pos.row,
    start_pos = start_pos,
    end_pos = end_pos,
  }
end

function M.in_visual_mode()
  local current_mode = vim.fn.mode()
  return current_mode == "v" or current_mode == "V" or current_mode == ""
end

---@return SelectionRange|nil
function M.get_selection_range()
  if not M.in_visual_mode() then return nil end

  -- Get the start and end positions of Visual mode
  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")

  -- Get the start and end line and column numbers
  local start_line = start_pos[2]
  local start_col = start_pos[3]
  local end_line = end_pos[2]
  local end_col = end_pos[3]
  -- If the start point is after the end point, swap them
  if start_line > end_line or (start_line == end_line and start_col > end_col) then
    start_line, end_line = end_line, start_line
    start_col, end_col = end_col, start_col
  end
  return SelectionRange:new({ lnum = start_line, col = start_col }, { lnum = end_line, col = end_col })
end

-- From avante.nvim
function M.get_selection3()
  if not M.in_visual_mode() then return nil end

  -- Get the start and end positions of Visual mode
  local start_pos = vim.fn.getpos("v")
  local end_pos = vim.fn.getpos(".")

  -- Get the start and end line and column numbers
  local start_line = start_pos[2]
  local start_col = start_pos[3]
  local end_line = end_pos[2]
  local end_col = end_pos[3]
  -- If the start point is after the end point, swap them
  if start_line > end_line or (start_line == end_line and start_col > end_col) then
    start_line, end_line = end_line, start_line
    start_col, end_col = end_col, start_col
  end
  local content = "" -- luacheck: ignore
  local range = SelectionRange:new({ lnum = start_line, col = start_col }, { lnum = end_line, col = end_col })
  -- Check if it's a single-line selection
  if start_line == end_line then
    -- Get partial content of a single line
    local line = vim.fn.getline(start_line)
    -- content = string.sub(line, start_col, end_col)
    content = line
  else
    -- Multi-line selection: Get all lines in the selection
    local lines = vim.fn.getline(start_line, end_line)
    -- Extract partial content of the first line
    -- lines[1] = string.sub(lines[1], start_col)
    -- Extract partial content of the last line
    -- lines[#lines] = string.sub(lines[#lines], 1, end_col)
    -- Concatenate all lines in the selection into a string
    if type(lines) == "table" then
      content = table.concat(lines, "\n")
    else
      content = lines
    end
  end
  if not content then return nil end
  -- Return the selected content and range
  return SelectionResult:new(content, range)
end

--- from grug-far.nvim
--- get text lines in visual selection
---@return string[]
function M.getVisualSelectionLines()
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
  local lines = vim.fn.getline(start_row, end_row) --[[ @as string[] ]]
  if #lines > 0 and start_col and end_col and end_col < string.len(lines[#lines]) then
    if start_row == end_row then
      lines[1] = lines[1]:sub(start_col + 1, end_col + 1)
    else
      lines[1] = lines[1]:sub(start_col + 1, -1)
      lines[#lines] = lines[#lines]:sub(1, end_col + 1)
    end
  end
  return lines
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

M.is_visual_mode = function(mode)
  mode = mode or vim.fn.mode()
  -- '\22' is an escaped `<C-v>`
  return mode == "v" or mode == "V" or mode == "\22", mode
end

-- ~/.local/share/nvim/lazy/fzf-lua/lua/fzf-lua/utils.lua:855
function M.get_visual_selection()
  -- this will exit visual mode
  -- use 'gv' to reselect the text
  local _, csrow, cscol, cerow, cecol
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "" then
    -- if we are in visual mode use the live position
    _, csrow, cscol, _ = unpack(vim.fn.getpos("."))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("v"))
    if mode == "V" then
      -- visual line doesn't provide columns
      cscol, cecol = 0, 999
    end
    -- NOTE: not required since commit: e8b2093
    -- exit visual mode
    -- vim.api.nvim_feedkeys(
    --   vim.api.nvim_replace_termcodes("<Esc>",
    --     true, false, true), "n", true)
  else
    -- otherwise, use the last known visual position
    _, csrow, cscol, _ = unpack(vim.fn.getpos("'<"))
    _, cerow, cecol, _ = unpack(vim.fn.getpos("'>"))
  end
  -- swap vars if needed
  if cerow < csrow then
    csrow, cerow = cerow, csrow
  end
  if cecol < cscol then
    cscol, cecol = cecol, cscol
  end
  local lines = vim.fn.getline(csrow, cerow)
  ---@cast lines -string
  -- local n = cerow-csrow+1
  local n = #lines
  if n <= 0 then return "" end
  lines[n] = string.sub(assert(lines[n]), 1, cecol)
  lines[1] = string.sub(assert(lines[1]), cscol)
  return table.concat(lines, "\n"),
    {
      start = { line = csrow, char = cscol },
      ["end"] = { line = cerow, char = cecol },
    }
end

return M

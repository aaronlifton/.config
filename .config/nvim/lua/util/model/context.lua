---@class ai.context
---@field config {max_lines: number}
Context = {
  config = {
    max_lines = 10,
  },
}

---@return ai.context
function Context:new(ctx)
  ctx = ctx or {}
  setmetatable(ctx, self)
  self.__index = self
  return ctx
end

---@param bufnr number
---@return {lines_before: number, lines_after: number, cursor: {row: number, col: number}}
function Context:get(bufnr)
  local max_lines = self.config.max_lines
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  local cur_line = vim.fn.getline(".")
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local col = vim.api.nvim_win_get_cursor(0)[2]

  -- local cursor = ctx.context.cursor
  -- local cur_line = ctx.context.row
  -- properly handle utf8
  -- local cur_line_before = string.sub(cur_line, 1, col - 1)
  local cur_line_before = vim.fn.strpart(cur_line, 0, math.max(col - 1, 0), true)

  -- properly handle utf8
  -- local cur_line_after = string.sub(cur_line, col) -- include current character
  local cur_line_after = vim.fn.strpart(cur_line, math.max(col - 1, 0), vim.fn.strdisplaywidth(cur_line), true) -- include current character

  local lines_before = vim.api.nvim_buf_get_lines(0, math.max(0, row - max_lines), row, false)
  table.insert(lines_before, cur_line_before)
  local before = table.concat(lines_before, "\n")

  local lines_after = vim.api.nvim_buf_get_lines(0, row + 1, row + max_lines, false)
  table.insert(lines_after, 1, cur_line_after)
  local after = table.concat(lines_after, "\n")

  return {
    lines_before = before,
    lines_after = after,
    cursor = {
      row = row,
      col = col,
    },
  }
end

function Context:test()
  return {
    lines_before = {
      "def factorial(n)\n    if",
      "    return ans\n",
    },
  }
end

function Context:whole_file_context()
  local buf = vim.api.nvim_get_current_buf()
  local first_row = 0
  local first_col = 0
  local last_row = vim.api.nvim_buf_line_count(buf)
  local last_col = vim.api.nvim_buf_get_lines(buf, last_row - 1, last_row, true)[1]:len()
  local selection = {
    ["start"] = { row = first_row, col = first_col },
    ["stop"] = { row = last_row, col = last_col },
  }
  local context = {
    selection = selection,
    -- before_range = {
    --   ["start"] = { row = 0, col = 0 },
    --   ["stop"] = selection.start,
    -- },
    -- after_range = {
    --   ["start"] = selection.stop,
    --   ["stop"] = { row = -1, col = -1 },
    -- },
  }
  local source = require("model.core.input").get_source(false)
  local input_context = require("model.core.input").get_input_context(source, {})
  input_context = vim.tbl_deep_extend("force", input_context, { context = context })
  return input_context.context
end

--- Returns context needed for prompt builders
---@param want_visual_selection boolean
---@param args string[]
---@return {input: string, context: InputContext}
function Context:context(want_visual_selection, args)
  want_visual_selection = want_visual_selection or false
  args = args or nil
  local source = require("model.core.input").get_source(want_visual_selection)
  return require("model.core.input").get_input_context(source, args)
end

return Context

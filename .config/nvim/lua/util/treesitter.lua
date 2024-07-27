local M = {}

local ts_utils = require("nvim-treesitter.ts_utils")

M.parent_node_type_at_cursor = function()
  local node = ts_utils.get_node_at_cursor()

  if node == nil then
    return false
  end

  -- local node_type = node:type()
  local parent_type = node:parent():type()

  local function_want_types = {
    "function_call",
    "call",
  }
  local function_declaration_want_types = {
    "function_declaration",
    "singleton_method",
    "method",
  }
  local class_want_types = {
    "class",
    "module",
  }

  if vim.list_contains(function_want_types, parent_type) then
    return "function_call"
  elseif vim.list_contains(function_declaration_want_types, parent_type) then
    return "function_declaration"
  elseif vim.list_contains(class_want_types, parent_type) then
    return "class"
  else
    return nil
  end
end

M.parent_node_type_at_position = function(win, line, col)
  local buf = vim.api.nvim_win_get_buf(win)
  local root_lang_tree = require("nvim-treesitter.parsers").get_parser(buf)
  local root = ts_utils.get_root_for_position(line, col, root_lang_tree)
  local cursor = vim.api.nvim_win_get_cursor(win)
  local cursor_range = { cursor[1] - 1, cursor[2] }
  local descendant = root:named_descendant_for_range(cursor_range[1], cursor_range[2], cursor_range[1], cursor_range[2])
  local parent = descendant:parent()
  return parent:type()
end

M.get_cword_next_char = function()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local current_line = vim.api.nvim_get_current_line()
  local cword = vim.fn.expand("<cword>")
  local start_col, end_col = string.find(current_line, cword)
  local next_char = vim.fn.strcharpart(current_line, end_col, end_col)
  return vim.fn.strcharpart(next_char, 0, 1)
end

return M

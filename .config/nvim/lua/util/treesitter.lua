local M = {}

local ts_utils = require("nvim-treesitter.ts_utils")

function M.get_node_text(node, source, opts)
  if not node then return "" end

  return vim.treesitter.get_node_text(node, source or 0, opts or {})
end

function M.ancestor(node, depth)
  depth = depth or 0
  while node and depth > 0 do
    node = node:parent()
    depth = depth - 1
  end

  return node
end

function M.node_at_cursor()
  require("nvim-treesitter.ts_utils").get_node_at_cursor()
end

--- Usage:
--- require("util.treesitter").get_parent_type(require("nvim-treesitter.ts_utils").get_node_at_cursor(), 1)
function M.get_parent_type(node, counter)
  local parent_node = M.ancestor(node, counter)

  if parent_node ~= nil then return parent_node:type() end
end

function M.next_children_text(node, separator, types)
  if not node then return "" end

  return vim
    .iter(node:iter_children())
    :filter(function(child)
      return vim.tbl_contains(types, child:type())
    end)
    :map(function(child)
      return M.get_node_text(child)
    end)
    :join(separator)
end

--- Get the text of the previous sibling node
--- Usage require("util.treesitter").prev_sibling_text(require("nvim-treesitter.ts_utils").get_node_at_cursor(), 2)
---@param node TSNode The current node
---@param types? string[] Optional list of node types to filter by
---@return string The text of the previous sibling or empty string if none exists
function M.prev_sibling_text(node, depth)
  if not node then return "" end
  depth = depth or 1

  local current = node
  while depth > 0 and current do
    current = current:prev_sibling()
    depth = depth - 1
  end

  return current and M.get_node_text(current) or ""
end

--- Usage require("util.treesitter").ancestor_text(require("nvim-treesitter.ts_utils").get_node_at_cursor(), 1)
function M.ancestor_text(node, depth)
  local parent = M.ancestor(node, depth)
  if parent then return M.get_node_text(parent) end
end

function M.ancestors_by_type(node, types)
  while node do
    node = node:parent()

    if node and vim.tbl_contains(types, node:type()) then return node end
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

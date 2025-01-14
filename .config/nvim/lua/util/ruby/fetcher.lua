local tsutils = require("util.treesitter")
local ts = vim.treesitter

local default_options = {
  enabled = true,
  indicator_size = 100,
  type_patterns = { "class", "function", "method" },
  transform_fn = tsutils.get_node_text,
  separator = " 〉",
}

local filetype_options = setmetatable({}, {
  __index = function(tbl, ft)
    local ok, opts = pcall(require, "plugins.treesitter.fetcher." .. ft)
    local result

    if ok then
      result = vim.tbl_deep_extend("keep", opts, default_options)
    else
      result = default_options
    end

    tbl[ft] = result
    return result
  end,
})

local M = {}

--- Transforms node into module syntax
---@param node TSNode
local function transform_fn(node)
  local type = node:type()

  local text
  if
    (
      vim.tbl_contains({ "module", "class", "singleton_class" }, tsutils.get_parent_type(node, 2))
      or tsutils.get_parent_type(node, 1) == "program"
    ) and vim.tbl_contains({ "assignment" }, type)
  then
    -- constant assignment
    text = tsutils.next_children_text(node, "::", { "constant" })
  elseif vim.tbl_contains({ "class", "module" }, type) then
    -- constant nesting
    text = tsutils.next_children_text(node, "::", { "constant" })
  elseif vim.tbl_contains({ "method", "singleton_method" }, type) then
    -- singleton method
    text = tsutils.next_children_text(node, "::", { "identifier" })
  end

  if not text then
    -- Remove connection symbols from non-constant assignment and singleton_class
    return ""
  elseif tsutils.get_parent_type(node, 1) == "program" then
    -- Remove first `::`
    return text
  elseif type == "method" and tsutils.get_parent_type(node, 2) == "singleton_class" then
    -- When inside a class << self block
    return "." .. text
  elseif type == "singleton_method" then
    return "." .. text
  elseif type == "method" then
    return "#" .. text
  else
    return "::" .. text
  end
end

local opts = {
  type_patterns = { "comment", "assignment", "class", "module", "method" },
  separator = "",
  indicator_size = 100,
}
--- Usage:
--- require("util.ruby.fetcher").fetch()
function M.fetch()
  local ok, parser = pcall(ts.get_parser, 0)
  if not ok or not parser then return "" end

  local current_node = ts.get_node()
  if not current_node then return "" end

  local node = current_node
  local parts = {}

  while node do
    local text = transform_fn(node)
    if text ~= "" then table.insert(parts, 1, text) end

    node = tsutils.ancestors_by_type(node, opts.type_patterns)
  end

  local text = table.concat(require("util.table").compact_list(parts), opts.separator)
  local text_len = #text
  if text_len > opts.indicator_size then return "..." .. text:sub(text_len - opts.indicator_size, text_len) end

  return text
end

return M

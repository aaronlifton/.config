local M = {}

-- return {
--   type_patterns = { "class", "module" },
--   separator = "",
--   transform_fn = function(value, node)
--     value, _ = string.gsub(value, "%s*def%s*", "")
--     value, _ = string.gsub(value, "%s*class%s*", "")
--     value, _ = string.gsub(value, "%s*module%s*", "")
--     value, _ = string.gsub(value, "%s*<.*", "")
--
--     if node:type() == "class" then
--       return "::" .. value
--     elseif node:type() == "singleton_class" then
--       return ""
--     else
--       return "::" .. value
--     end
--   end,
-- }

function M.get_node_text(node, source, opts)
  if not node then
    return ""
  end

  return vim.treesitter.get_node_text(node, source or 0, opts or {})
end

function M.ancestor(node, counter)
  counter = counter or 0
  while node and counter > 0 do
    node = node:parent()
    counter = counter - 1
  end

  return node
end

function M.next_children_text(node, separator, types)
  if not node then
    return ""
  end

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

function M.ancestors_by_type(node, types)
  while node do
    node = node:parent()

    if node and vim.tbl_contains(types, node:type()) then
      return node
    end
  end
end

local tsutils = M

local function get_parent_type(node, counter)
  local parent_node = tsutils.ancestor(node, counter)

  if parent_node ~= nil then
    return parent_node:type()
  end
end

return {
  type_patterns = { "comment", "assignment", "class", "module", "method" },
  separator = "",
  transform_fn = function(value, node)
    -- stylua: ignore
    if not node then return end
    local type = node:type()

    local text
    if vim.tbl_contains({ "assignment", "class", "module" }, type) then
      text = tsutils.next_children_text(node, "::", { "constant" })
    elseif vim.tbl_contains({ "method", "singleton_method" }, type) then
      text = tsutils.next_children_text(node, "::", { "identifier" })
    end

    if not text then
      -- Remove connection symbols from non-constant assignment and singleton_class
      return ""
    elseif get_parent_type(node, 1) == "program" then
      -- Remove first `::`
      return text
    elseif type == "method" and get_parent_type(node, 2) == "singleton_class" then
      -- When inside a class << self block
      return "." .. text
    elseif type == "singleton_method" then
      return "." .. text
    elseif type == "method" then
      return "#" .. text
    else
      return "::" .. text
    end
  end,
}

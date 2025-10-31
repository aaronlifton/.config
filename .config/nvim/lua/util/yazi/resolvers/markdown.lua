---@class util.yazi.resolvers.markdown
local M = {}

local function ensure_relative_prefix(rel)
  if rel:sub(1, 1) == "." then return rel end
  return "./" .. rel
end

local function markdown_link(rel, selected_abs_path)
  local label = vim.fn.fnamemodify(selected_abs_path, ":t")
  return string.format("[%s](%s)", label, ensure_relative_prefix(rel))
end

function M.resolve(selected_abs_path, relative_from_cwd)
  return markdown_link(relative_from_cwd, selected_abs_path)
end

return M

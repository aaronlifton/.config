---@class util.conform
---@field first fun(bufnr:string, ...:string[]):string
local M = {}

---@param bufnr integer
---@param ... string[]
---@return string
function M.first(bufnr, ...)
  local conform = require("conform")
  for i = 1, select("#", ...) do
    local formatter = select(i, ...)
    if conform.get_formatter_info(formatter, bufnr).available then
      return formatter
    end
  end
  return select(1, ...)
end

return M

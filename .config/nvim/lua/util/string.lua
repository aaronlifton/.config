---@class util.string
local M = {}

function M.first_to_upper(str)
  return (str:gsub("^%l", string.upper))
end

return M

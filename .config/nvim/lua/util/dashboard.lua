local M = {}

local pad = string.rep(" ", 22)

--- Creates a new section for mini.starter dashboard
---@param name string
---@param action string
---@param section string
M.new_section = function(name, action, section)
  return { name = name, action = action, section = pad .. section }
end

return M

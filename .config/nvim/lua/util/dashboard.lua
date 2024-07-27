local M = {}

local pad = string.rep(" ", 22)
M.new_section = function(name, action, section)
  return { name = name, action = action, section = pad .. section }
end

return M

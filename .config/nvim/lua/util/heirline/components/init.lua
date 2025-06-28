local M = {}

local options = {}

setmetatable(M, {
  __index = function(_, key)
    return require("util.heirline.components." .. key)
  end,
})

return M

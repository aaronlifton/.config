---@class hs.util.table
---@field string hs.util.string
---@field table hs.util.table
local M = {}

setmetatable(M, {
  __index = function(t, k)
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require("util." .. k)
    return rawget(t, k)
  end,
})

_G.Util = M

return M

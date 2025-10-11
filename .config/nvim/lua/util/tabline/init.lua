---@class util.tabline
---@field sort util.tabline.sort
---@field complete util.tabline.complete
---@field functions util.tabline.functions
local M = {}

local mods = { sort = true, complete = true }
setmetatable(M, {
  __index = function(t, k)
    if mods[k] then
      ---@diagnostic disable-next-line: no-unknown
      t[k] = require("util.tabline." .. k)
    end
    return rawget(t, k)
  end,
})

return M

---@class util.bufferline
---@field sort util.bufferline.sort
---@field complete util.bufferline.complete
---@field functions util.bufferline.functions
local M = {}

local mods = { sort = true, complete = true }
setmetatable(M, {
  __index = function(t, k)
    if mods[k] then
      ---@diagnostic disable-next-line: no-unknown
      t[k] = require("util.bufferline." .. k)
    end
    return rawget(t, k)
  end,
})

return M

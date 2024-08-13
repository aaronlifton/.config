---@class util.telescope
---@field finders util.telescope.finders
---@field pickers util.telescope.pickers
local M = {
  finders = require("util.telescope.finders"),
  pickers = require("util.telescope.pickers"),
}

return M

---@class Config: ConfigOptions
_G.Config = require("util")

local M = {}

---@class ConfigOptions
local options = {
  lsp_goto_source = "glance",
}

setmetatable(M, {
  __index = function(_, key)
    ---@cast options ConfigOptions
    return options[key]
  end,
})

return M

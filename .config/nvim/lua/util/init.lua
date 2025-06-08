---@class util
---@field git util.git
---@field leap util.leap
---@field lsp util.lsp
---@field writing util.writing
---@field table util.table
---@field win util.win
---@field ui util.ui
---@field system util.system
---@field selection util.selection
---@field model util.model
---@field ai util.ai
---@field nui util.nui
---@field fzf util.fzf
---@field treesitter util.treesitter
---@field bufferline util.bufferline
---@field format util.format
---@field path util.path
---@field lazy util.lazy
local M = {}

setmetatable(M, {
  __index = function(t, k)
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require("util." .. k)
    return rawget(t, k)
  end,
})

_G.Util = M

local config = {}

M.config = setmetatable({}, {
  __index = function(_, k)
    config[k] = config[k] or {}
    return config[k]
  end,
  __newindex = function(_, k, v)
    config[k] = v
  end,
})

-- TODO: remove
---@param extra string
function M.has_extra(extra)
  local Config = require("lazyvim.config")
  local modname = "plugins.extras." .. extra
  return vim.tbl_contains(require("lazy.core.config").spec.modules, modname)
    or vim.tbl_contains(Config.json.data.extras, modname)
end

return M

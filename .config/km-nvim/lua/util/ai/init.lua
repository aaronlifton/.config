---@class util
---@field lazy util.lazy
-- ---@field leap util.leap
-- ---@field lsp util.lsp
-- ---@field writing util.writing
-- ---@field table util.table
-- ---@field win util.win
-- ---@field ui util.ui
-- ---@field system util.system
-- ---@field selection util.selection
-- ---@field model util.model
-- ---@field ai util.ai
-- ---@field nui util.nui
-- ---@field fzf util.fzf
-- ---@field treesitter util.treesitter
-- ---@field bufferline util.bufferline
-- ---@field format util.format
-- ---@field path util.path
local M = {}

setmetatable(M, {
  __index = function(t, k)
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require('util.' .. k)
    return rawget(t, k)
  end,
})

_G.Util = M

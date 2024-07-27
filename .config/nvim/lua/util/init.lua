---@class util: UtilCore
---@field config ConfigOptions
---@field git util.git
---@field leap util.leap
---@field lsp util.lsp
---@field debug util.debug
---@field editor util.editor
---@field table util.table
---@field ui util.ui
---@field pickers util.pickers
---@field system util.system
local M = {
  git = require("util.git"),
  leap = require("util.leap"),
  lsp = require("util.lsp"),
  debug = require("util.debug"),
  editor = require("util.editor"),
  table = require("util.table"),
  ui = require("util.ui"),
  pickers = require("util.pickers"),
  system = require("util.system"),
}

---@param extra string
function M.has_extra(extra)
  local Config = require("lazyvim.config")
  local modname = "plugins.extras." .. extra
  return vim.tbl_contains(require("lazy.core.config").spec.modules, modname)
    or vim.tbl_contains(Config.json.data.extras, modname)
end

return M

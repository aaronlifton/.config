---@class util: Util
---@field config ConfigOptions
---@field git util.git
---@field leap util.leap
---@field lsp util.lsp
---@field debug util.debug
---@field writing util.writing
---@field table util.table
---@field win util.win
---@field ui util.ui
---@field system util.system
---@field selection util.selection

local M = {}

setmetatable(M, {
  __index = function(t, k)
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require("util." .. k)
    return rawget(t, k)
  end,
})

---@param extra string
function M.has_extra(extra)
  local Config = require("lazyvim.config")
  local modname = "plugins.extras." .. extra
  return vim.tbl_contains(require("lazy.core.config").spec.modules, modname)
    or vim.tbl_contains(Config.json.data.extras, modname)
end

return M

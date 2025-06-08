---@class util.lazy
---@field has_plugin fun(n: string): LazyPluginSpec
---@field safe_keymap_set
---@field config LazyCoreConfig
---@field loader LazyCoreLoader
---@field util LazyUtilCore
local M = {
  config = {
    init = require("util.lazy.core.config").init,
  },
  loader = require("util.lazy.core.loader"),
  util = require("util.lazy.core.util"),
  format = require("util.lazy.util.format"),
  lsp = require("util.lazy.util.lsp"),
  root = require("util.lazy.util.root"),
  plugin = require("util.lazy.util.plugin"),
}

-- Create a metatable to look up functions from require("util.lazy.util") if they don't exist in M
local lazy_util = require("util.lazy.util")
setmetatable(M, {
  __index = function(_, key)
    return lazy_util[key]
  end,
})

function M.setup()
  M.plugin.setup()
end

function M.has_plugin(name)
  return require("lazy.core.config").spec.plugins[name]
end

function M.safe_keymap_set(mode, lhs, rhs, opts)
  local keys = require("lazy.core.handler").handlers.keys or {}
  ---@cast keys LazyKeysHandler
  local modes = type(mode) == "string" and { mode } or mode

  ---@param m string
  modes = vim.tbl_filter(function(m)
    return not (keys.have and keys:have(lhs, m))
  end, modes)

  -- do not create the keymap if a lazy keys handler exists
  if #modes > 0 then
    opts = opts or {}
    opts.silent = opts.silent ~= false
    if opts.remap and not vim.g.vscode then
      ---@diagnostic disable-next-line: no-unknown
      opts.remap = nil
    end
    vim.keymap.set(modes, lhs, rhs, opts)
  end
end

---@return string
function M.norm(path)
  if path:sub(1, 1) == "~" then
    local home = vim.uv.os_homedir()
    if home:sub(-1) == "\\" or home:sub(-1) == "/" then home = home:sub(1, -2) end
    path = home .. path:sub(2)
  end
  path = path:gsub("\\", "/"):gsub("/+", "/")
  return path:sub(-1) == "/" and path:sub(1, -2) or path
end

---@param fn fun()
function M.on_very_lazy(fn)
  vim.api.nvim_create_autocmd("User", {
    pattern = "VeryLazy",
    callback = function()
      fn()
    end,
  })
end

return M

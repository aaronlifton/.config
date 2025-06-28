---@class util
---@field async util.async
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
---@field lang util.lang
---@field lint util.lint
---@field snacks util.snacks
---@field string util.string
---@field colors util.colors
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

--- Convenient wapper to save code when we Trigger events.
--- To listen for an event triggered by this function you can use `autocmd`.
--- @param event string Name of the event.
--- @param is_urgent boolean|nil If true, trigger directly instead of scheduling. Useful for startup events.
-- @usage To run a User event:   `trigger_event("User MyUserEvent")`
-- @usage To run a Neovim event: `trigger_event("BufEnter")
function M.trigger_event(event, is_urgent)
  -- define behavior
  local function trigger()
    local is_user_event = string.match(event, "^User ") ~= nil
    if is_user_event then
      event = event:gsub("^User ", "")
      vim.api.nvim_exec_autocmds("User", { pattern = event, modeline = false })
    else
      vim.api.nvim_exec_autocmds(event, { modeline = false })
    end
  end

  -- execute
  if is_urgent then
    trigger()
  else
    vim.schedule(trigger)
  end
end

return M

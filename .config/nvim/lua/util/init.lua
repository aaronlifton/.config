---@class util
---@field ai util.ai
---@field async util.async
---@field bind util.bind
---@field bufferline util.bufferline
---@field colors util.colors
---@field format util.format
---@field fzf util.fzf
---@field git util.git
---@field lang util.lang
---@field leap util.leap
---@field lint util.lint
---@field llmContext util.llmContext
---@field lsp util.lsp
---@field model util.model
---@field nui util.nui
---@field path util.path
---@field selection util.selection
---@field snacks util.snacks
---@field string util.string
---@field system util.system
---@field table util.table
---@field treesitter util.treesitter
---@field ui util.ui
---@field win util.win
---@field writing util.writing
local M = {
  verbose = false,
}

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

function M.notify(msg, level)
  if M.verbose then vim.notify(msg, level or vim.log.levels.INFO) end
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

M.lazy_require = function(module)
  local mod = nil

  local function load()
    if not mod then
      mod = require(module)
      package.loaded[module] = mod
    end
    return mod
  end
  -- if already loaded, return the module
  -- otherwise return a lazy module
  return type(package.loaded[module]) == "table" and package.loaded[module]
    or setmetatable({}, {
      __index = function(_, key)
        return load()[key]
      end,
      __newindex = function(_, key, value)
        load()[key] = value
      end,
      __call = function(_, ...)
        return load()(...)
      end,
    })
end

return M

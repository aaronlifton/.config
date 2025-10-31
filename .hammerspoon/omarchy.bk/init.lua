local M = {}

M.restorable_frames = {}
M.config = {
  nvimMappings = {
    superShiftH = false,
    superShiftL = false,
  },
  terminalApps = { "Kitty", "Terminal", "iTerm2", "Alacritty", "WezTerm" },
}

K = {
  mod = {
    hyper = { "cmd", "alt", "ctrl", "shift" },
    super = { "cmd" },
    superShift = { "cmd", "shift" },
    superAlt = { "cmd", "alt" },
    superCtrl = { "cmd", "ctrl" },
    superShiftAlt = { "cmd", "shift", "alt" },
    alt = { "alt" },
    ctrl = { "ctrl" },
    shift = { "shift" },
  },
}

local default_mod = {
  super = { "cmd" },
  superShift = { "cmd", "shift" },
  superAlt = { "cmd", "alt" },
  superCtrl = { "cmd", "ctrl" },
  superShiftAlt = { "cmd", "shift", "alt" },
  alt = { "alt" },
  ctrl = { "ctrl" },
  shift = { "shift" },
  hyper = { "cmd", "alt", "ctrl", "shift" },
}

local window_focus = require("omarchy.bk.window_focus")
local window_movement = require("omarchy.bk.window_movement")
local window_resize = require("omarchy.bk.window_resize")
local workspace = require("omarchy.bk.workspace")
local layouts = require("omarchy.bk.layouts")
local applications = require("omarchy.bk.applications")
local keybindings = require("omarchy.bk.keybindings")

function M.init(mod, config)
  mod = mod or default_mod
  if config then
    for k, v in pairs(config) do
      if type(v) == "table" then
        for nk, nv in pairs(v) do
          M.config[k][nk] = nv
        end
      else
        M.config[k] = v
        -- Logger.w(("Unknown config key: %s"):format(k))
      end
    end
  end

  Logger.d("ERROR Initializing Omarchy-inspired keybindings", hs.inspect(mod))

  workspace.setup()
  keybindings.setup(mod, {
    window_focus = window_focus,
    window_movement = window_movement,
    window_resize = window_resize,
    workspace = workspace,
    layouts = layouts,
    applications = applications,
  }, M)

  Logger.d("ERROR Omarchy-inspired keybindings initialized")
end

function M.disable()
  Logger.d("Disabling Omarchy-inspired keybindings")
end

function M.cleanup()
  Logger.d("Cleaning up Omarchy-inspired keybindings")
  workspace.teardown()
end

return M

-- Docs
-- Keycodes:
-- https://github.com/Hammerspoon/hammerspoon/blob/master/extensions/keycodes/keycodes.lua#L72-L81
-- hs.application - https://www.hammerspoon.org/docs/hs.application.html

hs.allowAppleScript(true)

Logger = require("functions.logger")
Theme = require("theme")
local aerospace_watcher = require("aerospace_watcher")

Util = require("Util")
Screens = {
  main = "Studio Display",
  -- secondary = "Built-in Retina Display",
}
Config = {
  aerospaceEnabled = true,
  screenCount = #hs.screen.allScreens(),
  username = os.getenv("USER"),
  theme = "catppuccin_macchiato",
}
Theme.setTheme(Config.theme)
aerospace_watcher.initConfig(Config)

-- install hammerspoon cli
---@diagnostic disable: inject-field
local brewPrefixOutput, _, _, _ = hs.execute("brew --prefix", true)

if brewPrefixOutput then
  require("hs.ipc")
  if not hs.ipc.cliStatus(brewPrefixOutput) then
    local brewPrefix = string.gsub(brewPrefixOutput, "%s+", "")
    hs.ipc.cliInstall(brewPrefix)
  else
    Logger.d("ipc status: connected")
  end
end

-- To test IPC status manually:
-- local function checkIpcStatus()
--   hs.execute('hs -A -n -q -t 0.1 -c "hs.ipc.cliStatus("/opt/homebrew/", true)"')
-- end

K = {
  mod = {
    hyper = { "cmd", "alt", "ctrl", "shift" },
    cmd = { "cmd" },
    cmdShift = { "cmd", "shift" },
    cmdAlt = { "cmd", "alt" },
    cmdCtrl = { "cmd", "ctrl" },
    cmdShiftAlt = { "cmd", "shift", "alt" },
    alt = { "alt" },
    ctrl = { "ctrl" },
    shift = { "shift" },
    extra = {
      cmdCtrlAlt = { "cmd", "alt", "ctrl", "shift" },
    },
  },
}

-- Make animations fast
-- https://github.com/Hammerspoon/hammerspoon/blob/master/extensions/alert/alert.lua#L17
hs.alert.defaultStyle = {
  strokeWidth = 2,
  -- strokeColor = { white = 0, alpha = 0 },
  strokeColor = { hex = Theme.base, alpha = 0 },
  -- fillColor = { white = 1, alpha = 0.5 },
  fillColor = { hex = Theme.mantle, alpha = 1 },
  -- textColor = { black = 1, alpha = 1 },
  textColor = { hex = Theme.text, alpha = 1 },
  textFont = ".AppleSystemUIFont",
  textSize = 18,
  radius = 2,
  atScreenEdge = 0, -- 1 for top, 2 for bottom
  fadeInDuration = 0.15,
  fadeOutDuration = 0.15,
  padding = nil,
}

hs.hotkey.alertDuration = 0
hs.hints.showTitleThresh = 0
hs.window.animationDuration = 0

-- Grid
hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.grid.GRIDWIDTH = 8
hs.grid.GRIDHEIGHT = 4
-- Grid
Grid = {
  bottomHalf = "0,1 2x1",
  leftHalf = "0,0 1x2",
  rightHalf = "1,0 1x2",
  topHalf = "0,0 2x1",
  fullScreen = "0,0 2x2",
  rightTopHalf = "1,0 1x1", -- Right top quarter
  rightBottomHalf = "1,1 1x1", -- Right bottom quarter
}
-- hs.grid.setMargins({ x = 0, y = 0 })
hs.grid.setMargins(hs.geometry.size(0, 0))
hs.grid.setGrid("2x2")

local appWatcher = require("functions.application_watcher")
local shutdownCallback = function()
  appWatcher:stop()
  aerospace_watcher.cleanup()
end
hs.shutdownCallback = shutdownCallback

-- SPOONS
-- Load SpoonInstall, so we can easily load our other Spoons
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.repos.official = {
  url = "https://github.com/Hammerspoon/Spoons",
  desc = "Official spoon repository",
}

Install = spoon.SpoonInstall
Install.use_syncinstall = true

Install:andUse("ReloadConfiguration")
Logger.d("ReloadConfiguration spoon loaded")

hs.loadSpoon("EmmyLua")

-- KEYBINDINGS
HyperBinding = K.mod.hyper
-- Also <C-c>?
hs.hotkey.bind(HyperBinding, "escape", function()
  ExitHyperMode()
end)
-- hs.hotkey.bind(HyperBinding, "1", function()
--   require("functions.layouts_example").customLayouts["1"]()
-- end)

-- HYPER MODE
Hyper = hs.hotkey.modal.new({}, "F19")

-- Enter Hyper Mode when F19 (Hyper/Capslock) is pressed
function EnterHyperMode()
  Hyper.triggered = false
  Hyper:enter()
end

-- Leave Hyper Mode when F19 (Hyper/Capslock) is pressed,
function ExitHyperMode()
  Hyper:exit()
end

-- Bind the Hyper key
F18 = hs.hotkey.bind({}, "F18", EnterHyperMode, ExitHyperMode)
-- double-right-shift-mode -> [:a :z]
F19 = hs.hotkey.bind({}, "F19", ExitHyperMode, nil)

-- CHROME MODE
local browser = require("functions.browser")
ChromeModal = hs.hotkey.modal.new({}, nil, nil)
ChromeModal:bind({ "alt" }, "t", "Opening tab to the right", browser.newTabToRight)

local keys = require("keys")
keys.bind()

require("ax_hotfix")

spoon.ReloadConfiguration:start()

appWatcher:start()

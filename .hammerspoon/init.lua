local M = {}

-- Docs
-- Keycodes:
-- https://github.com/Hammerspoon/hammerspoon/blob/master/extensions/keycodes/keycodes.lua#L72-L81
-- hs.application - https://www.hammerspoon.org/docs/hs.application.html

hs.allowAppleScript(true)

Logger = require("functions.logger")
Theme = require("theme")
local configurator = require("configurator")

Util = require("Util")
ProcessManager = require("functions.process_manager")
Window = require("functions.window")
Screens = {
  main = "Studio Display",
  -- secondary = "Built-in Retina Display",
}
Config = {
  aerospaceEnabled = false,
  screenCount = #hs.screen.allScreens(),
  username = os.getenv("USER"),
  useOmarchy = false,
  theme = "catppuccin_macchiato",
}
Theme.setTheme(Config.theme)

---@diagnostic disable: inject-field
-- install hammerspoon cli
local brewPrefixOutput, _, _, _ = hs.execute("brew --prefix", true)

-- local function checkIpcStatus()
--   hs.execute('hs -A -n -q -t 0.1 -c "hs.ipc.cliStatus("/opt/homebrew/", true)"')
-- end

if brewPrefixOutput then
  require("hs.ipc")
  if not hs.ipc.cliStatus(brewPrefixOutput) then
    local brewPrefix = string.gsub(brewPrefixOutput, "%s+", "")
    hs.ipc.cliInstall(brewPrefix)
  else
    Logger.d("ipc status: connected")
  end
end

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

-- 913794
-- Make all our animations really fast
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

-- Load SpoonInstall, so we can easily load our other Spoons
hs.loadSpoon("SpoonInstall")
spoon.SpoonInstall.repos.official = {
  url = "https://github.com/Hammerspoon/Spoons",
  desc = "Official spoon repository",
}

if Config.useOmarchy then
  spoon.SpoonInstall.repos.wwmoraes = {
    url = "https://github.com/wwmoraes/spoons",
    desc = "wwmoraes' spoons",
    branch = "release",
  }
  spoon.SpoonInstall.repos.mogenson = {
    url = "https://github.com/mogenson/Drag.spoon",
    desc = "mogenson' spoons",
    branch = "main",
  }

  -- https://github.com/Hammerspoon/Spoons/blob/master/Source/SpoonInstall.spoon/init.lua#L369
  -- Install:installSpoonFromRepo("mogenson", "Drag.spoon")
  -- Install:installSpoonFromZipURL("https://github.com/mogenson/Drag.spoon/archive/refs/heads/main.zip")
  Drag = hs.loadSpoon("Drag")
end

Install = spoon.SpoonInstall
Install.use_syncinstall = true

Install:andUse("ReloadConfiguration")
Logger.d("ReloadConfiguration spoon loaded")

Install:andUse("ModalMgr")
Logger.d("ModalMgr spoon loaded")

if hs.spoons.isLoaded("ModalMgr") then
  spoon.ModalMgr.modal_tray[1] = {
    type = "circle",
    action = "fill",
    fillColor = { hex = Theme.base, alpha = 0.9 },
  }

  local screenWidth = hs.screen.mainScreen():frame().w
  local whichKeyWidth = math.max(screenWidth * spoon.ModalMgr.width_factor, spoon.ModalMgr.min_width)
  -- spoon.ModalMgr.which_key = hs.canvas.new({ x = 0, y = 0, w = 0, h = 0 })
  spoon.ModalMgr.which_key = hs.canvas.new({ x = screenWidth - whichKeyWidth, h = 0 })
  spoon.ModalMgr.which_key:level(hs.canvas.windowLevels.tornOffMenu)

  spoon.ModalMgr.which_key[1] = {
    type = "rectangle",
    action = "fill",
    frame = { x = screenWidth - whichKeyWidth },
    fillColor = { hex = Theme.crust, alpha = 0.95 },
    roundedRectRadii = { xRadius = 10, yRadius = 10 },
  }
end

---
---Inspo: https://github.com/orionpax1997/hugo-blog/blob/a070d7464b810e4ad1b4670e43a45d0e038e5667/content/posts/hammerspoon.md?plain=1#L55
---https://github.com/rickysaurav/dotfiles/blob/326b3027fcb3a758c3ebea4f56526d2ce4633062/modules/home-manager/dots/hammerspoon/init.lua#L104
---https://github.com/aesadde/dotfiles/blob/335673bffe757b0c4656d1d3a46e413b33a47ab0/ARCHIVE/hammerspoon/init.lua#L55
---https://github.com/ashfinal/awesome-hammerspoon/tree/master/Spoons
---https://github.com/wwmoraes/dotfiles/blob/ab0f83ff97ce975e4193900092d7983f75b95599/.shadow.d/.hammerspoon/init.lua
---
---@param mouse_follows_focus spoon.MouseFollowsFocus
-- Install:andUse("MouseFollowsFocus", {
--   start = true,
--   fn = function(mouse_follows_focus)
--     ---@type spoon.ModalMgr
--     local modal_mgr = spoon.ModalMgr
--     modal_mgr:new("MouseFollowsFocus")
--     ---@type hs.hotkey.modal
--     local cmodal = modal_mgr.modal_list["MouseFollowsFocus"]
--     ---@type hs.hotkey.modAl
--     local supervisor = modal_mgr.supervisor
--     cmodal:bind("", "escape", "Exit", function()
--       Logger.d("Deactivating cmodal")
--       modal_mgr:deactivate({ "MouseFollowsFocus" })
--       supervisor:exit()
--     end)
--     cmodal:bind("", "M", "Start mouse follow focus", function()
--       mouse_follows_focus:start()
--       hs.alert.show("Mouse Follows Focus Started")
--       supervisor:exit()
--     end)
--     cmodal:bind("shift", "M", "Stop mouse follow focus", function()
--       mouse_follows_focus:stop()
--       hs.alert.show("Mouse Follows Focus Stopped")
--       supervisor:exit()
--     end)
--     cmodal:bind("shift", "/", "Cheatsheet", function()
--       modal_mgr:toggleCheatsheet()
--     end)
--     supervisor:bind("", "m", "Enter Mouse Focus Management", function()
--       modal_mgr:deactivateAll()
--       Logger.d("Activating cmodal")
--       modal_mgr:activate({ "MouseFollowsFocus" }, nil, true)
--     end)
--   end,
-- })
-- Logger.d("MouseFollowsFocus spoon loaded")
-- Install:andUse("AppWindowSwitcher")

hs.loadSpoon("EmmyLua")

-- hs.loadSpoon("HSearch")
-- Install:andUse("HSearch")
-- logger.d("HSearch spoon loaded")

-- Configure HSearch hotkeys
-- require("Modes.HSearch")

-- hs.loadSpoon("ClipboardTool")
-- if spoon.ClipboardTool then
--   -- spoon.ClipboardTool.hist_size = 10
--   spoon.ClipboardTool.hist_size = 50
--   spoon.ClipboardTool.show_copied_alert = false
--   spoon.ClipboardTool.show_in_menubar = false
--   spoon.ClipboardTool:start()
--   spoon.ClipboardTool:bindHotkeys({
--     toggle_clipboard = { { "ctrl", "alt", "cmd" }, "v" },
--   })
-- end

-- local EnhancedSpaces = hs.loadSpoon("EnhancedSpaces")
-- EnhancedSpaces:new({
-- 	mSpaces = { "1", "2", "3" }, -- default { '1', '2', '3' }
-- 	startmSpace = "2", -- default 2
-- 	modifierSnap1 = { "" }, -- default: { 'cmd', 'alt' }
-- 	modifierSnap2 = { "" }, -- default: { 'cmd', 'ctrl' }
-- 	modifierSnap3 = { "" }, -- default: { 'cmd', 'shift' }
-- })

-- NOTE: This needs to be updated to the latest hammerspoon. Trying Aerospace instead.
-- can use hs.loadSpoon when it fits the spoon format
-- HWM = require("functions/hhtwm") -- it's recommended to make `hhtwm` a global object so it's not garbage collected.
-- HWM.start()

-- local configWatcher = require("functions/config_watcher")
local appWatcher = require("functions.application_watcher")
local browser = require("functions.browser")
local keys = require("keys")
HyperBinding = K.mod.hyper
hs.hotkey.bind(HyperBinding, "escape", function()
  ExitHyperMode()
end)
-- hs.hotkey.bind(HyperBinding, "1", function()
--   require("functions.layouts_example").customLayouts["1"]()
-- end)

hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.grid.GRIDWIDTH = 8
hs.grid.GRIDHEIGHT = 4

-- hyper f18 - https://ritam.me/posts/hammerspoon-hyper-key/
-- local FRemap = require("foundation_remapping")
-- FoundationRemapper = FRemap.new()

-- https://github.com/posky/dev-configs/blob/a611d509bb56e95fa331d083df449b59abb2eca8/hammerspoon/.hammerspoon/init.lua#L13
-- capslock to F19
-- FoundationRemapper:remap(0x39, "F19")
-- FoundationRemapper:unregister()
-- right ctrl to F18
-- FoundationRemapper:remap(0xe4, "F18")
-- FoundationRemapper:remap("rcmd", "F18")
-- FoundationRemapper.remap("ralt", "F19")
-- FoundationRemapper.remap("rcmd", "F19")
-- FoundationRemapper:register()

local shutdownCallback = function()
  -- FoundationRemapper:unregister()
  appWatcher:stop()
  -- configWatcher:stop()
  configurator.cleanup()
  spoon.ModalMgr:deactivateAll()

  if Config.useOmarchy and hs.spoons.isLoaded("Omarchy") then Omarchy.teardown() end
end
hs.shutdownCallback = shutdownCallback

require("app_switcher")

-- A global variable for the Hyper Mode
Hyper = hs.hotkey.modal.new({}, "F19")

-- Enter Hyper Mode when F19 (Hyper/Capslock) is pressed
function EnterHyperMode()
  Hyper.triggered = false
  Hyper:enter()
  hs.alert.show("Hyper on")
end

-- Leave Hyper Mode when F19 (Hyper/Capslock) is pressed,
-- send ESCAPE if no other keys are pressed.
function ExitHyperMode()
  Hyper:exit()
  -- if not hyper.triggered then
  --   hs.eventtap.keyStroke({}, 'ESCAPE')
  -- end
  hs.alert.show("Hyper off")
end

-- Hyper:bind({}, "o", nil, function()
--   local app = hs.application.frontmostApplication()
--   if app:name() == "Finder" then
--     hs.eventtap.keyStroke({ "cmd" }, "o", 0)
--   else
--     hs.eventtap.keyStroke({}, "Return", 0)
--   end
-- end)
Hyper:bind({}, "k", nil, function()
  hs.application.launchOrFocus("net.kovidgoyal.kitty")
end)

-- Bind the Hyper key
F18 = hs.hotkey.bind({}, "F18", EnterHyperMode, ExitHyperMode)
-- double-right-shift-mode -> [:a :z]
F19 = hs.hotkey.bind({}, "F19", ExitHyperMode, nil)
-- /hyper

-- chrome
ChromeModal = hs.hotkey.modal.new({}, nil, nil)
ChromeModal:bind({ "alt" }, "t", "Opening tab to the right", browser.newTabToRight)
-- /chrome

hs.window.animationDuration = 0.0

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
hs.grid.setMargins(hs.geometry.size(0, 0))
-- hs.grid.setMargins({ x = 0, y = 0 })
hs.grid.setGrid("2x2")

configurator.initConfig(Config)

keys.bind()

if Config.useOmarchy then
  Omarchy = hs.loadSpoon("OmarchyOSX")
  Omarchy:start({
    nvimMappings = {
      superShiftH = false,
      superShiftL = false,
    },
  })
end

require("ax_hotfix")

-- setmetatable(spoon.ReloadConfiguration, {
--   __index = function(t, k)
--     if k == "bindHotkeys" then
--       return reload_config
--     else
--       return rawget(t, k)
--     end
--   end,
-- })

spoon.ReloadConfiguration:start()

appWatcher:start()

-- local omarchy = require("omarchy")
-- omarchy.init({
--   super = { "cmd" },
--   superShift = { "cmd", "shift" },
--   superAlt = { "cmd", "alt" },
--   superCtrl = { "cmd", "ctrl" },
--   superShiftAlt = { "cmd", "shift", "alt" },
--   alt = { "alt" },
--   ctrl = { "ctrl" },
--   shift = { "shift" },
-- })

-- require("layout")
-- init_layout()

-- require("yabai")

local logger = require("functions.logger")

Util = require("Util")
ProcessManager = require("functions.process_manager")
Window = require("functions.window")

---@diagnostic disable: inject-field
-- install hammerspoon cli
local brewPrefixOutput, _, _, _ = hs.execute("brew --prefix", true)

if brewPrefixOutput then
  local brewPrefix = string.gsub(brewPrefixOutput, "%s+", "")
  require("hs.ipc")
  hs.ipc.cliInstall(brewPrefix)
end

local K = {}
K.hyper = { "cmd", "alt", "ctrl", "shift" }
K.cmd_alt = { "cmd", "alt" }
K.ctrl_alt = { "ctrl", "alt" }
K.cmd_ctrl = { "cmd", "ctrl" }
K.cmd_ctrl_shift = { "cmd", "ctrl", "shift" }

-- 913794
-- Make all our animations really fast
hs.alert.defaultStyle = {
  strokeWidth = 2,
  strokeColor = { white = 0, alpha = 0 },
  fillColor = { white = 1, alpha = 0.5 },
  textColor = { black = 1, alpha = 1 },
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
spoon.SpoonInstall.repos.wwmoraes = {
  url = "https://github.com/wwmoraes/spoons",
  desc = "wwmoraes' spoons",
  branch = "release",
}
Install = spoon.SpoonInstall
Install.use_syncinstall = true

Install:andUse("ReloadConfiguration")
logger.d("ReloadConfiguration spoon loaded")
spoon.ReloadConfiguration:start()
Install:andUse("ModalMgr")
hs.loadSpoon("AwesomeKeys")

---
---Inspo: https://github.com/orionpax1997/hugo-blog/blob/a070d7464b810e4ad1b4670e43a45d0e038e5667/content/posts/hammerspoon.md?plain=1#L55
---https://github.com/rickysaurav/dotfiles/blob/326b3027fcb3a758c3ebea4f56526d2ce4633062/modules/home-manager/dots/hammerspoon/init.lua#L104
---https://github.com/aesadde/dotfiles/blob/335673bffe757b0c4656d1d3a46e413b33a47ab0/ARCHIVE/hammerspoon/init.lua#L55
---https://github.com/ashfinal/awesome-hammerspoon/tree/master/Spoons
---https://github.com/wwmoraes/dotfiles/blob/ab0f83ff97ce975e4193900092d7983f75b95599/.shadow.d/.hammerspoon/init.lua
---
---@param mouse_follows_focus spoon.MouseFollowsFocus
spoon.SpoonInstall:andUse("MouseFollowsFocus", {
  start = true,
  fn = function(mouse_follows_focus)
    ---@type spoon.ModalMgr
    local modal_mgr = spoon.ModalMgr
    modal_mgr:new("MouseFollowsFocus")
    ---@type hs.hotkey.modal
    local cmodal = modal_mgr.modal_list["MouseFollowsFocus"]
    ---@type hs.hotkey.modal
    local supervisor = modal_mgr.supervisor
    cmodal:bind("", "escape", "Exit", function()
      modal_mgr:deactivate({ "MouseFollowsFocus" })
      supervisor:exit()
    end)
    cmodal:bind("", "M", "Start mouse follow focus", function()
      mouse_follows_focus:start()
      hs.alert.show("Mouse Follows Focus Started")
      supervisor:exit()
    end)
    cmodal:bind("shift", "M", "Stop mouse follow focus", function()
      mouse_follows_focus:stop()
      hs.alert.show("Mouse Follows Focus Stopped")
      supervisor:exit()
    end)
    cmodal:bind("shift", "/", "Cheatsheet", function()
      modal_mgr:toggleCheatsheet()
    end)
    supervisor:bind("", "m", "Enter Mouse Focus Management", function()
      modal_mgr:deactivateAll()
      modal_mgr:activate({ "MouseFollowsFocus" }, nil, true)
    end)
  end,
})

hs.loadSpoon("EmmyLua")

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

hs.grid.MARGINX = 0
hs.grid.MARGINY = 0
hs.grid.GRIDWIDTH = 8
hs.grid.GRIDHEIGHT = 4

--hyper f18
-- https://ritam.me/posts/hammerspoon-hyper-key/
local FRemap = require("foundation_remapping")
FoundationRemapper = FRemap.new()

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
  FoundationRemapper:unregister()
  appWatcher:stop()
  -- configWatcher:stop()
end
hs.shutdownCallback = shutdownCallback

-- A global variable for the Hyper Mode
Hyper = hs.hotkey.modal.new({}, "F19")

ChromeModal = hs.hotkey.modal.new({}, nil, nil)
ChromeModal:bind({ "alt" }, "t", "Opening tab to the right", browser.newTabToRight)

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

Hyper:bind({}, "o", nil, function()
  local app = hs.application.frontmostApplication()
  if app:name() == "Finder" then
    hs.eventtap.keyStroke({ "cmd" }, "o", 0)
  else
    hs.eventtap.keyStroke({}, "Return", 0)
  end
end)
Hyper:bind({}, "k", nil, function()
  hs.application.launchOrFocus("net.kovidgoyal.kitty")
end)

-- Bind the Hyper key
F19 = hs.hotkey.bind({}, "F19", EnterHyperMode, ExitHyperMode)
F18 = hs.hotkey.bind({}, "F18", EnterHyperMode, ExitHyperMode)
-- f19cmd = hs.hotkey.({ "cmd" }, "F19", enterHyperMode, exitHyperMode)

--/hyper f18

-- Bit masks for remapped modifier key and hyper key modifiers
-- local flagMasks = hs.eventtap.event.rawFlagMasks
-- local originalKeyMask = flagMasks["deviceRightAlternate"] -- right option
-- local hyperKeyMask = flagMasks["control"] | flagMasks["alternate"] | flagMasks["command"] | flagMasks["shift"]
--
-- -- Create a global listener to monitor keyboard events
-- local events = { hs.eventtap.event.types.keyDown, hs.eventtap.event.types.keyUp }
-- KeyEventListener = hs.eventtap
--   .new(events, function(event)
--     -- Filter out irrelevant data from the event's modifier flags
--     -- https://www.hammerspoon.org/docs/hs.eventtap.event.html#rawFlagMasks
--     local flags = event:rawFlags() & 0xdffffeff
--
--     -- Check if the keyboard event includes the desired modifier key to remap
--     -- If so, update the event's modifier flags to use hyper key modifiers
--     if flags & originalKeyMask ~= 0 then
--       logger.d("Remapping key event with originalKeyMask")
--       event:rawFlags(hyperKeyMask)
--     end
--
--     -- Propagate event to system
--     return false
--   end)
--   :start()

hs.window.animationDuration = 0.0

-- Grid
local grid = {
  bottomHalf = "0,1 2x1",
  leftHalf = "0,0 1x2",
  rightHalf = "1,0 1x2",
  topHalf = "0,0 2x1",
  fullScreen = "0,0 2x2",
}
hs.grid.setMargins(hs.geometry.size(0, 0))
-- hs.grid.setMargins({ x = 0, y = 0 })
hs.grid.setGrid("2x2")

local appMap = require("hyper_apps")

for key, app in pairs(appMap) do
  hs.hotkey.bind(HyperBinding, key, function()
    if type(app) == "string" then
      hs.application.launchOrFocus(app)
    elseif type(app) == "function" then
      app()
    else
      hs.logger.new("hyper"):e("Invalid mapping for Hyper +", key)
    end
  end)
end

hs.hotkey.bind(HyperBinding, "tab", function()
  local windows = hs.window.orderedWindows()
  if #windows > 1 then
    local window = windows[2]
    window:focus():raise()
  end
end)

hs.hotkey.bind(HyperBinding, "tab", function()
  local focusedWindow = hs.window.focusedWindow()
  if not focusedWindow then return end

  -- Put focused window on left half
  hs.grid.set(focusedWindow, grid.leftHalf)

  -- Get other windows on same screen
  local otherWindows = hs.window.otherWindowsSameScreen(focusedWindow)
  if #otherWindows == 0 then return end

  -- Calculate height for each window in the right half
  local heightPerWindow = 2 / #otherWindows

  -- Tile other windows on right half
  for i, window in ipairs(otherWindows) do
    local yPos = (i - 1) * heightPerWindow
    local gridString = "1," .. yPos .. " 1x" .. heightPerWindow
    hs.grid.set(window, gridString)
    window:raise()
  end
end)

hs.hotkey.bind(HyperBinding, "9", function()
  hs.application.launchOrFocus("System Preferences")
end)

Clipboard = require("Helpers.Clipboard")
App = require("Helpers.App")

-- /start hotfix
-- https://github.com/indirect/miro-windows-manager/blob/61b5a4cb261645b4704f1ee40057d82c55cb88fa/MiroWindowsManager.spoon/init.lua#L35
-- https://github.com/Hammerspoon/hammerspoon/issues/3224
-- Patch hs.window to work around accessibility forcing animations
local function axHotfix(win)
  if not win then win = hs.window.frontmostWindow() end

  local axApp = hs.axuielement.applicationElement(win:application())
  if not axApp then return end

  local wasEnhanced = axApp.AXEnhancedUserInterface
  axApp.AXEnhancedUserInterface = false

  return function()
    hs.timer.doAfter(hs.window.animationDuration * 2, function()
      axApp.AXEnhancedUserInterface = wasEnhanced
    end)
  end
end

local function withAxHotfix(fn, position)
  if not position then position = 1 end
  return function(...)
    local revert = axHotfix(select(position, ...))
    fn(...)
    if revert then revert() end
  end
end

local windowMT = hs.getObjectMetatable("hs.window")
---@diagnostic disable: need-check-nil
windowMT.setFrame = withAxHotfix(windowMT.setFrame)
windowMT.maximize = withAxHotfix(windowMT.maximize)
windowMT.moveToUnit = withAxHotfix(windowMT.moveToUnit)
---@diagnostic enable: need-check-nil
-- /end hotfix

appWatcher:start()
-- configWatcher:watch_config_and_reload()
keys.bind()

-- require("layout")
-- init_layout()

-- require("yabai")

-- hs.loadSpoon("TilingWindowManager")
-- 		:setLogLevel("debug")
-- 		:bindHotkeys({
-- 			tile = { hyperKey, "t" },
-- 			incMainRatio = { hyperKey, "p" },
-- 			decMainRatio = { hyperKey, "o" },
-- 			incMainWindows = { hyperKey, "i" },
-- 			decMainWindows = { hyperKey, "u" },
-- 			focusNext = { hyperKey, "k" },
-- 			focusPrev = { hyperKey, "j" },
-- 			swapNext = { hyperKey, "l" },
-- 			swapPrev = { hyperKey, "h" },
-- 			toggleFirst = { hyperKey, "return" },
-- 			tall = { hyperKey, "y" },
-- 			talltwo = { hyperKey, "m" },
-- 			fullscreen = { hyperKey, "e" },
-- 			wide = { hyperKey, "-" },
-- 			display = { hyperKey, "d" },
-- 			float = { hyperKey, "f" },
-- 		})
-- 		:start({
-- 			menubar = true,
-- 			dynamic = true,
-- 			layouts = {
-- 				spoon.TilingWindowManager.layouts.floating,
-- 				spoon.TilingWindowManager.layouts.fullscreen,
-- 				spoon.TilingWindowManager.layouts.tall,
-- 				spoon.TilingWindowManager.layouts.talltwo,
-- 				spoon.TilingWindowManager.layouts.wide,
-- 			},
-- 			displayLayout = true,
-- 			fullscreenRightApps = {
-- 				"org.hammerspoon.Hammerspoon",
-- 				"com.apple.mobileSMS",
-- 				-- "dev.warp.Warp-Stable",
-- 				"com.github.wez.wezterm",
-- 				"uet.kovidgoyal.kitty",
-- 				-- "com.microsoft.VSCode",
-- 				-- "org.alacritty",
-- 			},
-- 			floatApps = {
-- 				"com.apple.systempreferences",
-- 				"com.apple.ActivityMonitor",
-- 				"com.apple.Stickies",
-- 				"com.raycast.macos",
-- 				"org.hammerspoon.Hammerspoon",
-- 				-- "com.github.wez.wezterm",
-- 				-- "com.microsoft.VSCode",
-- 				-- "org.alacritty",
-- 				-- "uet.kovidgoyal.kitty"
-- 				"org.pqrs.Karabiner-Elements.Settings",
-- 				"org.pqrs.Karabiner-EventViewer",
-- 				"com.apple.systempreferences",
-- 				"com.apple.SystemProfiler",
-- 				"com.apple.LocalAuthentication.UIAgent",
-- 				"com.apple.MobileSMS",
-- 				"com.apple.Preview",
-- 			},
-- 		})
-- 		:setLayoutCurrentSpace(spoon.TilingWindowManager.layouts.fullscreen)

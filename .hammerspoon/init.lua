local logger = require("functions/logger")
local configWatcher = require("functions/config_watcher")
local appWatcher = require("functions/application_watcher")
local keys = require("keys")

-- https://github.com/indirect/miro-windows-manager/blob/61b5a4cb261645b4704f1ee40057d82c55cb88fa/MiroWindowsManager.spoon/init.lua#L35
-- Patch hs.window to work around accessibility forcing animations
local function axHotfix(win)
	if not win then
		win = hs.window.frontmostWindow()
	end

	local axApp = hs.axuielement.applicationElement(win:application())
	local wasEnhanced = axApp.AXEnhancedUserInterface
	axApp.AXEnhancedUserInterface = false

	return function()
		hs.timer.doAfter(hs.window.animationDuration * 2, function()
			axApp.AXEnhancedUserInterface = wasEnhanced
		end)
	end
end

local function withAxHotfix(fn, position)
	if not position then
		position = 1
	end
	return function(...)
		local revert = axHotfix(select(position, ...))
		fn(...)
		revert()
	end
end

local windowMT = hs.getObjectMetatable("hs.window")
windowMT.setFrame = withAxHotfix(windowMT.setFrame)
windowMT.maximize = withAxHotfix(windowMT.maximize)
windowMT.moveToUnit = withAxHotfix(windowMT.moveToUnit)

hs.loadSpoon("EmmyLua")
hs.loadSpoon("ClipboardTool")
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

appWatcher:start()
configWatcher:watch_config_and_reload()

keys.bind_window_management_keymap()
keys.bind_general_keymap()
keys.bind_app_keymap()

-- require("yabai")

--- Hyper key
---@class hyper: hs.hotkey.modal
---@field pressed fun()
---@field released fun()
---@field enter fun()
---@field exit fun()
local hyper = hs.hotkey.modal.new({}, nil)

hyper.pressed = function()
	hyper:enter()
	hs.timer.doAfter(1, function()
		hyper:exit()
	end)
end

hyper.released = function()
	hyper:exit()
end

hs.hotkey.bind({}, "f19", hyper.pressed, hyper.released)

-- TWM [https://github.com/evantravers/hammerspoon-config/blob/38a7d8c0ad2190d1563d681725628e4399dcbe6c/hyper.lua]
-- local altKey = {"alt"}
-- local altShiftKey = {"alt", "shift"}
-- local cocKey = {"ctrl", "alt", "cmd"}
-- local hyper = "⇧⌃⌥⌘"
-- local hyper = { "ctrl", "shift", "alt", "cmd" }
local hyperKey = keys.HYPER
-- local super = {'ctrl', 'alt', 'cmd'}

--hs.loadSpoon("MinimizedWindowsMenu")
--    :setLogLevel("debug")
--    :start()

--hs.loadSpoon("NamedSpacesMenu")
--    :setLogLevel("debug")
--    :start()
--:bindHotkeys({
--    showmenu =   {hyperKey, "space"}
--})

hs.window.animationDuration = 0.0
hs.hotkey.bind(hyperKey, "tab", function()
	local windows = hs.window.orderedWindows()
	if #windows > 1 then
		local window = windows[2]
		window:focus():raise()
	end
end)

hs.hotkey.bind(hyperKey, "9", function()
	hs.application.launchOrFocus("System Preferences")
end)

-- hs.hotkey.bind("cmd", "q", function()
--     hs.alert.show("Cmd+Q is disabled", 1)
-- end)

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

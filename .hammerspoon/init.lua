local logger = require("functions/logger")
local config_watcher = require("functions/config_watcher")
local browser = require("functions/browser")

config_watcher.watch_config_and_reload()

require("keys")
require("yabai")

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
local hyper = { "ctrl", "alt", "cmd", "shift" }
-- local super = {'ctrl', 'alt', 'cmd'}

--hs.loadSpoon("MinimizedWindowsMenu")
--    :setLogLevel("debug")
--    :start()

--hs.loadSpoon("NamedSpacesMenu")
--    :setLogLevel("debug")
--    :start()
--:bindHotkeys({
--    showmenu =   {hyper, "space"}
--})

hs.window.animationDuration = 0.0
hs.hotkey.bind(hyper, "tab", function()
	local windows = hs.window.orderedWindows()
	if #windows > 1 then
		window = windows[2]
		window:focus():raise()
	end
end)

hs.hotkey.bind(hyper, "9", function()
	hs.application.launchOrFocus("System Preferences")
end)
-- hs.hotkey.bind("cmd", "q", function()
--     hs.alert.show("Cmd+Q is disabled", 1)
-- end)

-- hs.loadSpoon("TilingWindowManager")
-- 		:setLogLevel("debug")
-- 		:bindHotkeys({
-- 			tile = { hyper, "t" },
-- 			incMainRatio = { hyper, "p" },
-- 			decMainRatio = { hyper, "o" },
-- 			incMainWindows = { hyper, "i" },
-- 			decMainWindows = { hyper, "u" },
-- 			focusNext = { hyper, "k" },
-- 			focusPrev = { hyper, "j" },
-- 			swapNext = { hyper, "l" },
-- 			swapPrev = { hyper, "h" },
-- 			toggleFirst = { hyper, "return" },
-- 			tall = { hyper, "y" },
-- 			talltwo = { hyper, "m" },
-- 			fullscreen = { hyper, "e" },
-- 			wide = { hyper, "-" },
-- 			display = { hyper, "d" },
-- 			float = { hyper, "f" },
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

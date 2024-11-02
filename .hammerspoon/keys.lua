local inspect = require("inspect")
local window = require("functions/window")
local layout = require("functions/layout")
local logger = hs.logger.new("keys.lua", "debug")
hs.loadSpoon("ClipboardTool")

-- local function is_almost_equal_to_current_win_frame(geo)
-- 	local epsilon = 5
-- 	local curWin = hs.window.focusedWindow()
-- 	local curWinFrame = curWin:frame()
-- 	if
-- 		math.abs(curWinFrame.x - geo.x) < epsilon
-- 		and math.abs(curWinFrame.y - geo.y) < epsilon
-- 		and math.abs(curWinFrame.w - geo.w) < epsilon
-- 		and math.abs(curWinFrame.h - geo.h) < epsilon
-- 	then
-- 		return true
-- 	else
-- 		return false
-- 	end
-- end

local function bind_with_restore(mod_keys, key, thunk)
	hs.hotkey.bind(mod_keys, key, function()
		local current_window = hs.window.focusedWindow()
		local current_frame = current_window:frame()
		local window_id = current_window:id()
		if not window_id then
			return
		end

		local restorable_frame = window.restorable_frames[window_id]
		if restorable_frame then
			current_window:setFrame(restorable_frame)
			window.restorable_frames[window_id] = nil
		else
			window.restorable_frames[window_id] = current_frame
			thunk()
		end
	end)
end

-- SYMBOLS----------------------------------------------------------------------
-- ⌘ ⌃ ⌥ ⇧
---c-c-a-s----------------------------------------------------------------------

-- account for hidden dock
hs.grid.setMargins({ x = 0, y = 0 })

-- show grid
hs.hotkey.bind("⌥⌘⇧", "g", hs.grid.show)

-- full screens
hs.hotkey.bind("⌘⇧", "up", window.thunk_push({ width = 1, height = 1 }))
hs.hotkey.bind("⌘⇧", "down", window.thunk_push({ top = 1 / 8, left = 1 / 8, width = 3 / 4, height = 3 / 4 }))

-- half screens
local function thunk_left_or_move()
	if not window.push({ left = 0, width = 1 / 2 }) then
		local focused_window = hs.window.focusedWindow()
		local screen = focused_window:screen():previous()
		focused_window:moveToScreen(screen)

		window.push({ left = 1 / 2, width = 1 / 2 })
	end
end

local function thunk_right_or_move()
	if not window.push({ left = 1 / 2, width = 1 / 2 }) then
		local focused_window = hs.window.focusedWindow()
		local screen = focused_window:screen():next()
		focused_window:moveToScreen(screen)

		window.push({ left = 0, width = 1 / 2 })
	end
end

local hyper = { "ctrl", "alt", "cmd" }

hs.hotkey.bind("⌘⇧", "left", thunk_left_or_move)
hs.hotkey.bind("⌘⇧", "right", thunk_right_or_move)
hs.hotkey.bind("⌘⇧", "up", window.thunk_push({ height = 1 / 2 }))
hs.hotkey.bind("⌘⇧", "down", window.thunk_push({ top = 1 / 2, height = 1 / 2 }))

-- fullscreen
-- hs.hotkey.bind("⌘⌥", "return", window.thunk_push({ width = 1, height = 1 }))
bind_with_restore("⌘⌥", "return", window.thunk_push({ top = 0, left = 0, width = 1, height = 1 }))

-- quarter screens
hs.hotkey.bind("⌘⌥", "u", window.thunk_push({ top = 0, left = 0, width = 1 / 2, height = 1 / 2 }))
hs.hotkey.bind("⌘⌥", "j", window.thunk_push({ top = 1 / 2, left = 0, width = 1 / 2, height = 1 / 2 }))
hs.hotkey.bind("⌘⌥", "i", window.thunk_push({ top = 0, left = 1 / 2, width = 1 / 2, height = 1 / 2 }))
hs.hotkey.bind("⌘⌥", "k", window.thunk_push({ top = 1 / 2, left = 1 / 2, width = 1 / 2, height = 1 / 2 }))
hs.hotkey.bind("⌘⌥", "d", window.thunk_push({ width = 2 / 3 }))
hs.hotkey.bind("⌘⌥", "f", window.thunk_push({ width = 2 / 3, left = 1 / 3 }))

-- third screens
hs.hotkey.bind("⌘⌥", "d", window.thunk_push({ top = 0, left = 0, width = 1 / 3 }))
hs.hotkey.bind("⌘⌥", "f", window.thunk_push({ top = 0, left = 1 / 3, width = 1 / 3 }))
hs.hotkey.bind("⌘⌥", "g", window.thunk_push({ left = 2 / 3, width = 1 / 3 }))

-- 2/3 and 1/3
hs.hotkey.bind("⌘⌥", "e", window.thunk_push({ width = 2 / 3 }))
-- hs.hotkey.bind("⌘⌥", "t", window.thunk_push({ left = 2 / 3, width = 1 / 3 }))
hs.hotkey.bind("⌘⌥", "r", window.thunk_push({ left = 1 / 3, width = 2 / 3 }))

-- center 2/3
hs.hotkey.bind("ctrl⇧", "c", window.thunk_push({ left = 1 / 6, top = 1 / 6, width = 2 / 3, height = 2 / 3 }))
-- center 2/3 tall
hs.hotkey.bind("⌘⇧⌥", "c", window.thunk_push({ left = 1 / 6, width = 2 / 3 }))
-- center 1/2
hs.hotkey.bind("⌘⌥", "c", window.thunk_push({ left = 1 / 4, top = 1 / 6, width = 1 / 2, height = 2 / 3 }))

-- Chrome
-- hs.hotkey.bind("⌃⌥⌘", "t", new_tab_next_to_current_tab_chrome)

-- Between monitors
local duration = 0
hs.hotkey.bind({ "alt", "ctrl", "cmd" }, "Right", function()
	local win = hs.window.focusedWindow()
	win:moveOneScreenSouth(false, true, duration)
end)
hs.hotkey.bind({ "alt", "ctrl", "cmd" }, "Left", function()
	local win = hs.window.focusedWindow()
	win:moveOneScreenNorth(false, true, duration)
end)

-- Chars
hs.hotkey.bind({ "ctrl" }, "escape", function()
	hs.eventtap.keyStrokes("`")
end)
hs.hotkey.bind({ "alt" }, "escape", function()
	hs.eventtap.keyStroke({ "ctrl" }, "escape")
end)

hs.hotkey.bind({ "shift" }, "escape", function()
	hs.eventtap.keyStrokes("~")
end)

if spoon.ClipboardTool then
	spoon.ClipboardTool.hist_size = 10
	spoon.ClipboardTool.show_copied_alert = false
	spoon.ClipboardTool.show_in_menubar = false
	spoon.ClipboardTool:start()
	spoon.ClipboardTool:bindHotkeys({
		toggle_clipboard = { hyper, "v" },
	})
end

-- Function keys
-- stylua: ignore start
local hotkeys = {
	{ "1", "f1" },  { "2", "f2" },  { "3", "f3" },
	{ "4", "f4" },  { "5", "f5" },  { "6", "f6" },
	{ "7", "f7" },  { "8", "f8" },  { "9", "f9" },
	{ "0", "f10" }, { "-", "f11" }, { "=", "f12" },
}
for _, values in ipairs(hotkeys) do
	hs.hotkey.bind("⌘⇧", values[1], nil, function()
		hs.eventtap.keyStroke({}, values[2])
	end)
end
-- end
-- fk_modal = hs.hotkey.modal.new({""}, "", nil)
-- -- stylua: ignore end
-- for _, values in ipairs(hotkeys) do
-- 	fk_modal:bind("⌘⇧", values[1], nil, function()
-- 		hs.eventtap.keyStroke({}, values[2])
-- 	end)
-- end
-- fk_modal:enter()
-- function application_watcher(appName, eventType, appObject)
-- 	logger.d(appName)
-- 	if eventType == hs.application.watcher.activated then
-- 		if appName == "Kitty" then
-- 			fk_modal:enter()
-- 		end
-- 	end
-- 	if eventType == hs.application.watcher.deactivated then
-- 		if appName == "kitty" then
-- 			fk_modal.exit()
-- 		end
-- 	end
-- end
-- local appWatcher = hs.application.watcher.new(application_watcher)
-- appWatcher:start()

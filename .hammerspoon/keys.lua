local M = {}

local window = require("functions.window")
local browser = require("functions.browser")

HyperBinding = { "cmd", "alt", "ctrl", "shift" }

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
    if not window_id then return end

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

local function restore_window_frame()
  local current_window = hs.window.focusedWindow()
  if not current_window then return end
  local window_id = current_window:id()
  if not window_id then return end

  local restorable_frame = window.restorable_frames[window_id]
  if restorable_frame then
    current_window:setFrame(restorable_frame)
    window.restorable_frames[window_id] = nil -- Clear after restoring
    -- Optional: Add a small notification? hs.notify.show("Hammerspoon", "", "Window frame restored")
    -- else
    -- Optional: Notify user that no frame was stored for this window
    -- hs.notify.show("Hammerspoon", "", "No frame stored for this window.")
  end
end

-- Helper function to turn layout parameters into a thunk using window.push
-- This abstracts away the window.thunk_push and the inner function() {}
local function move_and_resize(layout)
  return function()
    if type(layout) == "function" then
      layout = layout() -- Call the function if it's a thunk
    end
    window.push(layout)
  end
end

-- Define common window layouts using parameters for window.push
-- These return the { top, left, width, height } tables
M.layouts = {}

-- Full screen layout
M.layouts.full = { top = 0, left = 0, width = 1, height = 1 }

-- Halves
M.layouts.left_half = { top = 0, left = 0, width = 0.5, height = 1 }
M.layouts.right_half = { top = 0, left = 0.5, width = 0.5, height = 1 }
M.layouts.top_half = { top = 0, left = 0, width = 1, height = 0.5 }
M.layouts.bottom_half = { top = 0.5, left = 0, width = 1, height = 0.5 }
M.layouts.maximize_height = { top = 0, height = 1 } -- Only sets top and height

-- Quarters
M.layouts.top_left_quarter = { top = 0, left = 0, width = 0.5, height = 0.5 }
M.layouts.top_right_quarter = { top = 0, left = 0.5, width = 0.5, height = 0.5 }
M.layouts.bottom_left_quarter = { top = 0.5, left = 0, width = 0.5, height = 0.5 }
M.layouts.bottom_right_quarter = { top = 0.5, left = 0.5, width = 0.5, height = 0.5 }

-- Thirds (Horizontal)
M.layouts.first_third = { top = 0, left = 0, width = 1 / 3, height = 1 }
M.layouts.middle_third = { top = 0, left = 1 / 3, width = 1 / 3, height = 1 }
M.layouts.last_third = { top = 0, left = 2 / 3, width = 1 / 3, height = 1 }

-- Two Thirds (Horizontal)
M.layouts.first_two_thirds = { top = 0, left = 0, width = 2 / 3, height = 1 }
M.layouts.last_two_thirds = { top = 0, left = 1 / 3, width = 2 / 3, height = 1 }
M.layouts.slack = { left = (1 / 8) + 0.04, width = (7 / 8) - 0.04 }

-- Last Thirds (Vertical)
M.layouts.last_third_bot23 = { top = 1 / 3, left = 2 / 3, width = 1 / 3, height = 2 / 3 } -- Bottom third
M.layouts.last_third_top13 = { top = 0, left = 2 / 3, width = 1 / 3, height = 1 / 3 } -- Top third

-- Generic Centering Function
-- Centers a window with a given width and height ratio relative to the screen
function M.layouts.centered(width_ratio, height_ratio)
  local width = width_ratio or 1 -- Default to full width if not specified
  local height = height_ratio or 1 -- Default to full height if not specified
  local left = (1 - width) / 2
  local top = (1 - height) / 2
  return { top = top, left = left, width = width, height = height }
end

-- Custom functions (not simple push, keep them separate or refine)
local function make_larger()
  local win = hs.window.focusedWindow()
  if not win then return end
  local frame = win:frame()
  local screenFrame = win:screen():frame()

  local increase_factor = 0.05 -- Increase size by 5% of screen dimension

  local new_width = math.min(screenFrame.w, frame.w + screenFrame.w * increase_factor)
  local new_height = math.min(screenFrame.h, frame.h + screenFrame.h * increase_factor)

  -- Calculate new x and y to keep the center roughly the same
  local old_center_x = frame.x + frame.w / 2
  local old_center_y = frame.y + frame.h / 2
  local new_x = old_center_x - new_width / 2
  local new_y = old_center_y - new_height / 2

  -- Ensure the new frame stays within the screen bounds
  new_x = math.max(screenFrame.x, math.min(new_x, screenFrame.x + screenFrame.w - new_width))
  new_y = math.max(screenFrame.y, math.min(new_y, screenFrame.y + screenFrame.h - new_height))

  win:setFrame({ x = new_x, y = new_y, w = new_width, h = new_height }, { duration = 0 })
end

local function make_smaller()
  local win = hs.window.focusedWindow()
  if not win then return end
  local frame = win:frame()
  local screenFrame = win:screen():frame()

  local decrease_factor = 0.05 -- Decrease size by 5% of screen dimension
  local min_width = screenFrame.w * 0.1 -- Don't make it too small
  local min_height = screenFrame.h * 0.1

  local new_width = math.max(min_width, frame.w - screenFrame.w * decrease_factor)
  local new_height = math.max(min_height, frame.h - screenFrame.h * decrease_factor)

  -- Calculate new x and y to keep the center roughly the same
  local old_center_x = frame.x + frame.w / 2
  local old_center_y = frame.y + frame.h / 2
  local new_x = old_center_x - new_width / 2
  local new_y = old_center_y - new_height / 2

  -- Ensure the new frame stays within the screen bounds
  new_x = math.max(screenFrame.x, math.min(new_x, screenFrame.x + screenFrame.w - new_width))
  new_y = math.max(screenFrame.y, math.min(new_y, screenFrame.y + screenFrame.h - new_height))

  win:setFrame({ x = new_x, y = new_y, w = new_width, h = new_height }, { duration = 0 })
end

-- Reasonable Size - Using the centered layout function for consistency
local function reasonable_size()
  local win = hs.window.focusedWindow()
  if not win then return end
  local params = M.layouts.centered(0.75, 0.75) -- 3/4 size centered
  window.push(params)
end

-- SYMBOLS----------------------------------------------------------------------
-- ⌘ ⌃ ⌥ ⇧
---c-c-a-s----------------------------------------------------------------------

-- account for hidden dock

function M.bind()
  -- Almost Maximize
  -- Screenshot: ⌘⇧ Z
  bind_with_restore({ "cmd", "shift" }, "z", move_and_resize(M.layouts.full))

  -- Bottom Half
  -- Screenshot: ⌘⇧ Down
  hs.hotkey.bind({ "cmd", "shift" }, "down", move_and_resize(M.layouts.bottom_half))

  -- Bottom Left Quarter
  -- Screenshot: ⌘⌥ J
  hs.hotkey.bind({ "cmd", "alt" }, "j", move_and_resize(M.layouts.bottom_left_quarter))

  -- Bottom Right Quarter
  -- Screenshot: ⌘⌥ K
  hs.hotkey.bind({ "cmd", "alt" }, "k", move_and_resize(M.layouts.bottom_right_quarter))

  -- Center (Assuming 2/3 centered)
  -- Screenshot: ⌘⌥ L
  bind_with_restore({ "cmd", "alt" }, "l", move_and_resize(M.layouts.centered(2 / 3, 2 / 3)))

  -- Center Third (Assuming 1/3 centered)
  -- Screenshot: ⌘⌥ F
  bind_with_restore({ "cmd", "alt" }, "f", move_and_resize(M.layouts.centered(1 / 3, 1 / 3)))

  -- First Third (Left third)
  -- Screenshot: ⌘⌥ D
  hs.hotkey.bind({ "cmd", "alt" }, "d", move_and_resize(M.layouts.first_third))

  -- First Two Thirds (Left two thirds)
  -- Screenshot: ⌘⌥ E
  hs.hotkey.bind({ "cmd", "alt" }, "e", move_and_resize(M.layouts.first_two_thirds))

  hs.hotkey.bind({ "cmd", "alt" }, "y", move_and_resize(M.layouts.slack))

  -- Last Third (Right third)
  -- Screenshot: ⌘⌥ G
  hs.hotkey.bind({ "cmd", "alt" }, "g", move_and_resize(M.layouts.last_third))

  -- Last Two Thirds (Right two thirds)
  -- Screenshot: ⌘⌥ T
  hs.hotkey.bind({ "cmd", "alt" }, "t", move_and_resize(M.layouts.last_two_thirds))

  -- Left Half
  -- Screenshot: ⌘⇧ Left
  hs.hotkey.bind({ "cmd", "shift" }, "left", move_and_resize(M.layouts.left_half))

  -- Make Larger (Custom function)
  -- Screenshot: ⌘⌥ ->
  hs.hotkey.bind({ "cmd", "alt" }, "right", make_larger)

  -- Make Smaller (Custom function)
  -- Screenshot: ⌘⌥ <-
  hs.hotkey.bind({ "cmd", "alt" }, "left", make_smaller)

  -- Maximize (Full screen, toggles with restore)
  -- Screenshot: ⌘⌥ Return
  bind_with_restore({ "cmd", "alt" }, "return", move_and_resize(M.layouts.full))

  -- Maximize Height
  -- Screenshot: ⌘⌥ Up
  hs.hotkey.bind({ "cmd", "alt" }, "up", move_and_resize(M.layouts.maximize_height))

  -- Next Display (Custom function)
  -- Screenshot: ⌃⌘⌥ Right
  hs.hotkey.bind({ "alt", "ctrl", "cmd" }, "right", function()
    local win = hs.window.focusedWindow()
    if win then
      win:moveOneScreenSouth(false, true, 0) -- false for wrapping, true for resize, 0 duration
    end
  end)

  -- Previous Display (Custom function)
  -- Screenshot: ⌃⌘⌥ Left
  hs.hotkey.bind({ "alt", "ctrl", "cmd" }, "left", function()
    local win = hs.window.focusedWindow()
    if win then
      win:moveOneScreenNorth(false, true, 0) -- false for wrapping, true for resize, 0 duration
    end
  end)

  -- Reasonable Size (Using centered layout, toggles with restore)
  -- Screenshot: ⌘⌥⇧ R
  bind_with_restore({ "cmd", "alt", "shift" }, "r", reasonable_size) -- reasonable_size now uses M.layouts.centered(0.75, 0.75)

  -- Restore (Explicit Restore function)
  -- Screenshot: ⌃⌥ R
  hs.hotkey.bind({ "ctrl", "alt" }, "r", restore_window_frame)

  -- Right Half
  -- Screenshot: ⌘⇧ Right
  hs.hotkey.bind({ "cmd", "shift" }, "right", move_and_resize(M.layouts.right_half))

  -- Top Half
  -- Screenshot: ⌘⇧ Up
  hs.hotkey.bind({ "cmd", "shift" }, "up", move_and_resize(M.layouts.top_half))

  -- Top Left Quarter
  -- Screenshot: ⌘⌥ U
  hs.hotkey.bind({ "cmd", "alt" }, "u", move_and_resize(M.layouts.top_left_quarter))

  -- Top Right Quarter
  -- Screenshot: ⌘⌥ I
  hs.hotkey.bind({ "cmd", "alt" }, "i", move_and_resize(M.layouts.top_right_quarter))

  hs.hotkey.bind({ "cmd", "alt" }, "8", move_and_resize(M.layouts.last_third_bot23))
  hs.hotkey.bind({ "cmd", "alt" }, "9", move_and_resize(M.layouts.last_third_top13))

  -- Other bindings from your file (keep if you still want them)
  -- hs.hotkey.bind({ "ctrl" }, "space", function() ... end) -- Kitty toggle
  -- hs.hotkey.bind({ "ctrl" }, "escape", function() ... end) -- ` character
  -- hs.hotkey.bind({ "alt" }, "escape", function() ... end) -- ` character (Faster)
  -- hs.hotkey.bind({ "shift" }, "escape", function() ... end) -- ~ character

  hs.hotkey.bind({ "ctrl" }, "escape", function()
    hs.eventtap.keyStrokes("`")
  end)
  hs.hotkey.bind({ "alt" }, "escape", function()
    hs.eventtap.keyStrokes("`")
  end)

  hs.hotkey.bind({ "shift" }, "escape", function()
    hs.eventtap.keyStrokes("~")
  end)

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

  hs.hotkey.bind({ "cmd", "shift" }, "T", browser.newTabToRight)

  hs.hotkey.bind({ "ctrl", "cmd", "shift" }, "G", function()
      ProcessManager.findAndKillProcesses("git -C /Users/alifton")
  end)

  -- hs.hotkey.bind("cmd", "q", function()
  --     hs.alert.show("Cmd+Q is disabled", 1)
  -- end)

  -- use as a replacement for ReloadConfiguration for now
  hs.hotkey.bind({ "ctrl", "cmd", "shift" }, "r", function()
    hs.reload()
  end)

  -- hs.hotkey.bind(HyperBinding, "g", function()
  --   hs.grid.show()
  -- end)

  -- hs.hotkey.bind(HyperBinding, "l", function()
  --   hs.grid.set(hs.window.focusedWindow(), grid.rightHalf)
  -- end)
  -- hs.hotkey.bind(HyperBinding, "h", function()
  --   hs.grid.set(hs.window.focusedWindow(), grid.leftHalf)
  -- end)
end

return M

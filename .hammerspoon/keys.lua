local M = {}

-- Assuming functions.window and functions.browser are in the same directory or accessible via package.path
local window = require("functions.window")
local browser = require("functions.browser")

-- Define common modifier sets
M.mod = {
  cmd = { "cmd" },
  alt = { "alt" },
  ctrl = { "ctrl" },
  shift = { "shift" },
  cmdShift = { "cmd", "shift" },
  cmdAlt = { "cmd", "alt" },
  cmdCtrl = { "cmd", "ctrl" },
  altShift = { "alt", "shift" },
  ctrlShift = { "ctrl", "shift" },
  ctrlAlt = { "ctrl", "alt" },
  cmdAltShift = { "cmd", "alt", "shift" },
  ctrlCmdAlt = { "ctrl", "cmd", "alt" },
  ctrlCmdShift = { "ctrl", "cmd", "shift" },
  -- HyperBinding is cmd+alt+ctrl+shift
  hyper = { "cmd", "alt", "ctrl", "shift" },
}

-- Store restorable frames in the window module
-- window.restorable_frames = {} -- Assuming this is initialized in window.lua

-- Wrapper function to handle saving/restoring window frame before applying an action
-- This is the same logic as your original bind_with_restore, just named slightly differently
-- to fit the new structure if needed, but we can keep your original as it's well defined.
local function bind_with_restore(mod_keys, key, thunk)
  hs.hotkey.bind(mod_keys, key, function()
    local current_window = hs.window.focusedWindow()
    if not current_window then return end -- Ensure a window is focused
    local current_frame = current_window:frame()
    local window_id = current_window:id()
    if not window_id then return end -- Ensure the window has an ID

    -- Check if the window is already in a restorable state (i.e., we stored a frame)
    local restorable_frame = window.restorable_frames[window_id]
    if restorable_frame then
      -- If yes, restore the frame and clear the stored state
      current_window:setFrame(restorable_frame)
      window.restorable_frames[window_id] = nil
      -- Optional: Add a subtle visual cue
      -- hs.animate({current_window:setFrame(restorable_frame)}, {duration=0.1, fn='linear'})
    else
      -- If no, store the current frame and apply the new layout/action (thunk)
      window.restorable_frames[window_id] = current_frame
      thunk() -- Execute the action (apply layout or run function)
    end
  end)
end

-- Explicit function to restore the frame for the current window
-- Can be bound to a hotkey directly if you don't want it tied to the layout key
local function restore_window_frame()
  local current_window = hs.window.focusedWindow()
  if not current_window then return end
  local window_id = current_window:id()
  if not window_id then return end

  local restorable_frame = window.restorable_frames[window_id]
  if restorable_frame then
    current_window:setFrame(restorable_frame)
    window.restorable_frames[window_id] = nil -- Clear after restoring
    -- Optional: Add a small notification?
    -- hs.notify.show("Hammerspoon", "", "Window frame restored.")
    -- else
    -- Optional: Notify user that no frame was stored for this window
    -- hs.notify.show("Hammerspoon", "", "No frame stored for this window.")
  end
end

-- Helper function to turn layout parameters into a thunk using window.move_and_resize
-- This wraps the layout application logic.
local function apply_layout_thunk(layout_params)
  -- move_and_resize itself returns a function (a thunk) suitable for hs.hotkey.bind
  -- or our bind_with_restore.
  return window.move_and_resize(layout_params)
end

-- Define common window layouts using parameters for window.move_and_resize
-- These return the { top, left, width, height } tables relative to the screen.
-- These are just data definitions, not functions that perform actions yet.
M.layouts = {}

-- Full screen layout (relative 0-1)
M.layouts.full = { top = 0, left = 0, width = 1, height = 1 }

-- Halves (relative 0-1)
M.layouts.left_half = { top = 0, left = 0, width = 0.5, height = 1 }
M.layouts.right_half = { top = 0, left = 0.5, width = 0.5, height = 1 }
M.layouts.top_half = { top = 0, left = 0, width = 1, height = 0.5 }
M.layouts.bottom_half = { top = 0.5, left = 0, width = 1, height = 0.5 }
-- Note: maximize_height was `{ top = 0, height = 1 }` - window.move_and_resize
-- needs all four. We can assume left=0, width=1 if they aren't provided,
-- but being explicit is clearer. Let's define it fully or handle partials
-- in move_and_resize. Assuming move_and_resize handles partials based on original.
-- Let's keep the original definition and trust window.move_and_resize.
M.layouts.maximize_height = { top = 0, height = 1 } -- Only sets top and height

-- Quarters (relative 0-1)
M.layouts.top_left_quarter = { top = 0, left = 0, width = 0.5, height = 0.5 }
M.layouts.top_right_quarter = { top = 0, left = 0.5, width = 0.5, height = 0.5 }
M.layouts.bottom_left_quarter = { top = 0.5, left = 0, width = 0.5, height = 0.5 }
M.layouts.bottom_right_quarter = { top = 0.5, left = 0.5, width = 0.5, height = 0.5 }

-- Thirds (Horizontal) (relative 0-1)
M.layouts.first_third = { top = 0, left = 0, width = 1 / 3, height = 1 }
M.layouts.middle_third = { top = 0, left = 1 / 3, width = 1 / 3, height = 1 }
M.layouts.last_third = { top = 0, left = 2 / 3, width = 1 / 3, height = 1 }

-- Two Thirds (Horizontal) (relative 0-1)
M.layouts.first_two_thirds = { top = 0, left = 0, width = 2 / 3, height = 1 }
M.layouts.last_two_thirds = { top = 0, left = 1 / 3, width = 2 / 3, height = 1 }
-- Slack layout - Note: left = (1 / 8) + 0.04 seems to be a fixed offset calculation.
-- Let's keep the calculation as is for now.
M.layouts.slack = { left = (1 / 8) + 0.04, width = (7 / 8) - 0.04 } -- Height and top are assumed 1, 0 by move_and_resize?

-- Last Thirds (Vertical - seems like a typo in original comment, these are partials)
-- These combine horizontal thirds with vertical partials.
M.layouts.last_third_bot23 = { top = 1 / 3, left = 2 / 3, width = 1 / 3, height = 2 / 3 }
M.layouts.last_third_top13 = { top = 0, left = 2 / 3, width = 1 / 3, height = 1 / 3 }

-- Generic Centering Function (returns layout parameters)
function M.layouts.centered(width_ratio, height_ratio)
  local width = width_ratio or 1 -- Default to full width if not specified
  local height = height_ratio or 1 -- Default to full height if not specified
  local left = (1 - width) / 2
  local top = (1 - height) / 2
  return { top = top, left = left, width = width, height = height }
end

-- Custom action functions (These perform specific tasks, not just apply a layout)
-- We keep these separate because they don't fit the simple "apply layout" pattern.
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

-- Reasonable Size - Calls the centered layout function and applies it.
-- Note: This function will *apply* the layout when called, so it's a custom action.
local function reasonable_size()
  local win = hs.window.focusedWindow()
  if not win then return end
  local params = M.layouts.centered(0.75, 0.75) -- 3/4 size centered
  window.move_and_resize(params)() -- Call the thunk returned by move_and_resize
end

-- Define all bindings in a structured table
-- Each entry: { mod = modifier_set, key = "key_name", action = action_definition, [use_restore = boolean] }
-- action_definition can be:
--   - A layout table (e.g., M.layouts.full) -> will be wrapped in apply_layout_thunk
--   - A function (e.g., make_larger) -> will be called directly
-- use_restore: if true, use bind_with_restore; otherwise, use hs.hotkey.bind
M.bindings = {
  -- Window Layouts (using move_and_resize)
  -- Screenshot: ⌘⇧ Z
  { mod = M.mod.cmdShift, key = "z", action = M.layouts.full, use_restore = true }, -- Almost Maximize / Toggle Full

  -- Screenshot: ⌘⇧ Down
  { mod = M.mod.cmdShift, key = "down", action = M.layouts.bottom_half },

  -- Screenshot: ⌘⌥ J
  { mod = M.mod.cmdAlt, key = "j", action = M.layouts.bottom_left_quarter },

  -- Screenshot: ⌘⌥ K
  { mod = M.mod.cmdAlt, key = "k", action = M.layouts.bottom_right_quarter },

  -- Screenshot: ⌘⌥ L - Center (Assuming 4/5 centered)
  { mod = M.mod.cmdAlt, key = ";", action = M.layouts.centered(4 / 5, 4 / 5), use_restore = true }, -- Toggle Centered 4/5

  -- Screenshot: ⌘⌥ L - Center (Assuming 2/3 centered)
  { mod = M.mod.cmdAlt, key = "l", action = M.layouts.centered(2 / 3, 2 / 3), use_restore = true }, -- Toggle Centered 2/3

  -- Screenshot: ⌘⌥ F - Center Third (Assuming 1/3 centered)
  { mod = M.mod.cmdAlt, key = "f", action = M.layouts.centered(1 / 3, 1 / 3), use_restore = true }, -- Toggle Centered 1/3

  -- Screenshot: ⌘⌥ D - First Third (Left third)
  { mod = M.mod.cmdAlt, key = "d", action = M.layouts.first_third },

  -- Screenshot: ⌘⌥ E - First Two Thirds (Left two thirds)
  { mod = M.mod.cmdAlt, key = "e", action = M.layouts.first_two_thirds },

  -- Slack Layout (using M.layouts.slack)
  { mod = M.mod.cmdAlt, key = "y", action = M.layouts.slack },

  -- Screenshot: ⌘⌥ G - Last Third (Right third)
  { mod = M.mod.cmdAlt, key = "g", action = M.layouts.last_third },

  -- Screenshot: ⌘⌥ T - Last Two Thirds (Right two thirds)
  { mod = M.mod.cmdAlt, key = "t", action = M.layouts.last_two_thirds },

  -- Screenshot: ⌘⇧ Left
  { mod = M.mod.cmdShift, key = "left", action = M.layouts.left_half },

  -- Screenshot: ⌘⌥ -> - Make Larger (Custom function)
  { mod = M.mod.cmdAlt, key = "right", action = make_larger },

  -- Screenshot: ⌘⌥ <- - Make Smaller (Custom function)
  { mod = M.mod.cmdAlt, key = "left", action = make_smaller },

  -- Screenshot: ⌘⌥ Return - Maximize (Full screen, toggles with restore)
  { mod = M.mod.cmdAlt, key = "return", action = M.layouts.full, use_restore = true }, -- Toggle Full

  -- Screenshot: ⌘⌥ Up - Maximize Height
  { mod = M.mod.cmdAlt, key = "up", action = M.layouts.maximize_height },

  -- Screenshot: ⌃⌘⌥ Right - Next Display (Custom function)
  -- Assumes window.move_one_screen_south is a function in your window module
  { mod = M.mod.ctrlCmdAlt, key = "right", action = window.move_one_screen_south },

  -- Screenshot: ⌃⌘⌥ Left - Previous Display (Custom function)
  -- Note: Your original used win:moveOneScreenNorth directly here,
  -- but you have window.move_one_screen_south. Let's create a similar
  -- wrapper or use the direct hs method. Using direct hs method for now.
  {
    mod = M.mod.ctrlCmdAlt,
    key = "left",
    action = function()
      local win = hs.window.focusedWindow()
      if win then
        -- false for wrapping, true for resize, 0 duration
        win:moveOneScreenNorth(false, true, 0)
      end
    end,
  },

  -- Screenshot: ⌘⌥⇧ R - Reasonable Size (Using centered layout, toggles with restore)
  -- This calls the `reasonable_size` function which internally applies a layout.
  { mod = M.mod.cmdAltShift, key = "r", action = reasonable_size, use_restore = true }, -- Toggle Reasonable Size

  -- Screenshot: ⌃⌥ R - Restore (Explicit Restore function)
  { mod = M.mod.ctrlAlt, key = "r", action = restore_window_frame },

  -- Screenshot: ⌘⇧ Right
  { mod = M.mod.cmdShift, key = "right", action = M.layouts.right_half },

  -- Screenshot: ⌘⇧ Up
  { mod = M.mod.cmdShift, key = "up", action = M.layouts.top_half },

  -- Screenshot: ⌘⌥ U
  { mod = M.mod.cmdAlt, key = "u", action = M.layouts.top_left_quarter },

  -- Screenshot: ⌘⌥ I
  { mod = M.mod.cmdAlt, key = "i", action = M.layouts.top_right_quarter },

  -- Additional partial layouts
  { mod = M.mod.cmdAlt, key = "8", action = M.layouts.last_third_bot23 },
  { mod = M.mod.cmdAlt, key = "9", action = M.layouts.last_third_top13 },

  -- Other utility bindings

  -- ` character using different modifiers
  {
    mod = M.mod.ctrl,
    key = "escape",
    action = function()
      hs.eventtap.keyStrokes("`")
    end,
  },
  {
    mod = M.mod.alt,
    key = "escape",
    action = function()
      hs.eventtap.keyStrokes("`")
    end,
  }, -- Faster

  -- ~ character
  {
    mod = M.mod.shift,
    key = "escape",
    action = function()
      hs.eventtap.keyStrokes("~")
    end,
  },

  -- Function keys mapping (F1-F12 via Cmd+Shift+Number/Symbol)
  -- Loop generated below the main table definition
  -- stylua: ignore start
  { mod = M.mod.cmdShift, key = "T", action = browser.newTabToRight },

  -- Kill git process (Assuming ProcessManager exists)
  { mod = M.mod.ctrlCmdShift, key = "G", action = function()
      ProcessManager.findAndKillProcesses("git -C /Users/alifton") -- Replace with your actual path if needed
  end },

  -- Disable Cmd+Q example
  -- { mod = M.mod.cmd, key = "q", action = function() hs.alert.show("Cmd+Q is disabled", 1) end },

  -- Reload Hammerspoon config
  { mod = M.mod.ctrlCmdShift, key = "r", action = function() hs.reload() end },

  -- hs.grid bindings (commented out in original, keeping commented)
  -- { mod = M.mod.hyper, key = "g", action = function() hs.grid.show() end },
  -- { mod = M.mod.hyper, key = "l", action = function() hs.grid.set(hs.window.focusedWindow(), grid.rightHalf) end },
  -- { mod = M.mod.hyper, key = "h", action = function() hs.grid.set(hs.window.focusedWindow(), grid.leftHalf) end },

  -- Neovide configuration
  {
    mod = M.mod.ctrlShift,
    key = "z",
    action = function()
      local currentSpace = hs.spaces.focusedSpace()
      -- Get neovide app
      local app = hs.application.get("neovide")
      -- If app already open:
      if app then
        -- If no main window, then open a new window
        if not app:mainWindow() then
          app:selectMenuItem("New OS Window", true)
          -- If app is already in front, then hide it
        elseif app:isFrontmost() then
          app:hide()
          -- If there is a main window somewhere, bring it to current space and to
          -- front
        else
          -- First move the main window to the current space
          hs.spaces.moveWindowToSpace(app:mainWindow(), currentSpace)
          -- Activate the app
          app:activate()
          -- Raise the main window and position correctly
          app:mainWindow():raise()
        end
        -- If app not open, open it
      else
        hs.application.launchOrFocus("neovide")
        app = hs.application.get("neovide")
      end
    end
  },
  -- stylua: ignore end
}

-- Add Function Key bindings using a loop
local fkey_mappings = {
  { number_key = "1", f_key = "f1" },
  { number_key = "2", f_key = "f2" },
  { number_key = "3", f_key = "f3" },
  { number_key = "4", f_key = "f4" },
  { number_key = "5", f_key = "f5" },
  { number_key = "6", f_key = "f6" },
  { number_key = "7", f_key = "f7" },
  { number_key = "8", f_key = "f8" },
  { number_key = "9", f_key = "f9" },
  { number_key = "0", f_key = "f10" },
  { number_key = "-", f_key = "f11" },
  { number_key = "=", f_key = "f12" },
}

for _, mapping in ipairs(fkey_mappings) do
  table.insert(M.bindings, {
    mod = M.mod.cmdShift,
    key = mapping.number_key,
    -- action = function() hs.eventtap.keyStroke({}, mapping.f_key) end -- Use pressDUR for tap
    action = function()
      hs.eventtap.keyStroke({}, mapping.f_key)
    end,
  })
end

-- The main binding loop function
function M.bind()
  for _, binding in ipairs(M.bindings) do
    local modifiers = binding.mod
    local key = binding.key
    local action = binding.action
    local use_restore = binding.use_restore or false -- Default to false

    -- Determine the actual thunk/function to bind
    local thunk
    if type(action) == "table" then
      -- If the action is a layout table, wrap it in the apply_layout_thunk
      thunk = apply_layout_thunk(action)
    elseif type(action) == "function" then
      -- If the action is already a function, use it directly
      thunk = action
    else
      -- Skip invalid actions (shouldn't happen with the current structure)
      hs.alert.show("Error: Invalid action type for binding: " .. key)
      goto continue -- Lua goto for skipping loop iteration
    end

    -- Perform the binding
    if use_restore then
      bind_with_restore(modifiers, key, thunk)
    else
      -- hs.hotkey.bind(modifiers, key, press_fn, release_fn, repeated_fn)
      -- For simple actions, the press_fn is enough. The thunk is designed for this.
      hs.hotkey.bind(modifiers, key, thunk)
    end
    ::continue:: -- Goto label
  end
end

return M

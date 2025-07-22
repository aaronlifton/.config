local M = {}

local Key = require("functions.key")
local logger = require("functions.logger")

-- Define common modifier sets

-- Helper function to turn layout parameters into a thunk using window.move_and_resize
-- This wraps the layout application logic.
local function apply_layout_thunk(layout_params)
  -- move_and_resize itself returns a function (a thunk) suitable for hs.hotkey.bind
  -- or our Key.bind_with_restore.
  return Window.move_and_resize(layout_params)
end

-- Define common window layouts using parameters for window.move_and_resize
-- These return the { top, left, width, height } tables relative to the screen.
-- These are just data definitions, not functions that perform actions yet.

---@alias WindowLayoutDef { top: number?, left: number?, width: number?, height: number? }
---@alias WindowLayout WindowLayoutDef|fun(...):WindowLayoutDef

--- WindowLayout[]
M.layouts = {}

-- Full screen layout (relative 0-1)
---@type WindowLayout
M.layouts.full = { top = 0, left = 0, width = 1, height = 1 }

-- Halves (relative 0-1)
---@type WindowLayout
---@type WindowLayout
M.layouts.left_half = { top = 0, left = 0, width = 0.5, height = 1 }
---@type WindowLayout
M.layouts.right_half = { top = 0, left = 0.5, width = 0.5, height = 1 }
---@type WindowLayout
M.layouts.top_half = { top = 0, left = 0, width = 1, height = 0.5 }
---@type WindowLayout
M.layouts.bottom_half = { top = 0.5, left = 0, width = 1, height = 0.5 }
-- Note: maximize_height was `{ top = 0, height = 1 }` - window.move_and_resize
-- needs all four. We can assume left=0, width=1 if they aren't provided,
-- but being explicit is clearer. Let's define it fully or handle partials
-- in move_and_resize. Assuming move_and_resize handles partials based on original.
-- Let's keep the original definition and trust window.move_and_resize.
---@type WindowLayout
M.layouts.maximize_height = { top = 0, height = 1 } -- Only sets top and height

-- Quarters (relative 0-1)
---@type WindowLayout
M.layouts.top_left_quarter = { top = 0, left = 0, width = 0.5, height = 0.5 }
---@type WindowLayout
M.layouts.top_right_quarter = { top = 0, left = 0.5, width = 0.5, height = 0.5 }
---@type WindowLayout
M.layouts.bottom_left_quarter = { top = 0.5, left = 0, width = 0.5, height = 0.5 }
---@type WindowLayout
M.layouts.bottom_right_quarter = { top = 0.5, left = 0.5, width = 0.5, height = 0.5 }

-- Thirds (Horizontal) (relative 0-1)
---@type WindowLayout
M.layouts.first_third = { top = 0, left = 0, width = 1 / 3, height = 1 }
---@type WindowLayout
M.layouts.middle_third = { top = 0, left = 1 / 3, width = 1 / 3, height = 1 }
---@type WindowLayout
M.layouts.last_third = { top = 0, left = 2 / 3, width = 1 / 3, height = 1 }

-- Two Thirds (Horizontal) (relative 0-1)
---@type WindowLayout
M.layouts.first_two_thirds = { top = 0, left = 0, width = 2 / 3, height = 1 }
---@type WindowLayout
M.layouts.last_two_thirds = { top = 0, left = 1 / 3, width = 2 / 3, height = 1 }
-- Slack layout - Note: left = (1 / 8) + 0.04 seems to be a fixed offset calculation.
-- Let's keep the calculation as is for now.
---@type WindowLayout
M.layouts.slack = { left = (1 / 8) + 0.04, width = (7 / 8) - 0.04 } -- Height and top are assumed 1, 0 by move_and_resize?

-- Last Thirds (Vertical - seems like a typo in original comment, these are partials)
-- These combine horizontal thirds with vertical partials.
---@type WindowLayout
M.layouts.last_third_bot23 = { top = 1 / 3, left = 2 / 3, width = 1 / 3, height = 2 / 3 }
---@type WindowLayout
M.layouts.last_third_top13 = { top = 0, left = 2 / 3, width = 1 / 3, height = 1 / 3 }

-- Generic Centering Function (returns layout parameters)
--- @type WindowLayout
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

-- Define all bindings in a structured table
-- Each entry: { mod = modifier_set, key = "key_name", action = action_definition, [use_restore = boolean] }
-- action_definition can be:
--   - A layout table (e.g., M.layouts.full) -> will be wrapped in apply_layout_thunk
--   - A function (e.g., make_larger) -> will be called directly
-- use_restore: if true, use Key.bind_with_restore; otherwise, use hs.hotkey.bind
---@alias KeyBinding { mod: string[], key: string, action: WindowLayout|fun(), use_restore: boolean? }

--- @type { [string]: KeyBinding[] }
M.bindings = {
  -- Override OSX hide other windows binding
  { mod = K.mod.cmdAlt, key = "h", action = function() end },

  -- Window Layouts (using move_and_resize)
  -- Screenshot: ⌘⇧ Z
  { mod = K.mod.cmdShift, key = "z", action = M.layouts.full, use_restore = true }, -- Almost Maximize / Toggle Full

  -- Screenshot: ⌘⇧ Down
  { mod = K.mod.cmdShift, key = "down", action = M.layouts.bottom_half },

  -- Screenshot: ⌘⌥ J
  { mod = K.mod.cmdAlt, key = "j", action = M.layouts.bottom_left_quarter },

  -- Screenshot: ⌘⌥ K
  { mod = K.mod.cmdAlt, key = "k", action = M.layouts.bottom_right_quarter },

  -- Screenshot: ⌘⌥ c - Center)
  -- { mod = K.mod.cmdAlt, key = "c", action = M.layouts.centered(1) }, -- Toggle Centered

  -- Screenshot: ⌘⌥ L - Center 2/3 centered)
  { mod = K.mod.cmdAlt, key = "l", action = M.layouts.centered(2 / 3, 2 / 3) }, -- Toggle Centered 2/3

  -- Screenshot: ⌘⌥ F - Center Third (1/3 centered)
  { mod = K.mod.cmdAlt, key = "f", action = M.layouts.centered(1 / 3, 1 / 3), use_restore = true }, -- Toggle Centered 1/3

  -- Screenshot: ⌘⌥⇧ R - Center 3/4 (Reasonable Size)
  -- This calls the `reasonable_size` function which internally applies a layout.
  { mod = K.mod.cmdShiftAlt, key = "r", action = M.layouts.centered(0.75, 0.75), use_restore = true }, -- Toggle 3/4 (Reasonable Size)

  -- Screenshot: ⌘⌥ D - First Third (Left third)
  { mod = K.mod.cmdAlt, key = "d", action = M.layouts.first_third },

  -- Screenshot: ⌘⌥ E - First Two Thirds (Left two thirds)
  { mod = K.mod.cmdAlt, key = "e", action = M.layouts.first_two_thirds },

  -- Slack Layout (using M.layouts.slack)
  { mod = K.mod.cmdAlt, key = "y", action = M.layouts.slack },

  -- Screenshot: ⌘⌥ G - Last Third (Right third)
  { mod = K.mod.cmdAlt, key = "g", action = M.layouts.last_third },

  -- Screenshot: ⌘⌥ T - Last Two Thirds (Right two thirds)
  { mod = K.mod.cmdAlt, key = "t", action = M.layouts.last_two_thirds },

  -- Screenshot: ⌘⇧ Left
  { mod = K.mod.cmdShift, key = "left", action = M.layouts.left_half },

  -- Screenshot: ⌘⌥ -> - Make Larger (Custom function)
  -- { mod = K.mod.cmdAlt, key = "right", action = make_larger },

  -- Screenshot: ⌘⌥ <- - Make Smaller (Custom function)
  -- { mod = K.mod.cmdAlt, key = "left", action = make_smaller },

  -- Screenshot: ⌘⌥ Return - Maximize (Full screen, toggles with restore)
  { mod = K.mod.cmdAlt, key = "return", action = M.layouts.full, use_restore = true }, -- Toggle Full

  -- Screenshot: ⌘⌥ Up - Maximize Height
  { mod = K.mod.cmdAlt, key = "up", action = M.layouts.maximize_height },

  -- Screenshot: ⌃⌘⌥ Right - Next Display (Custom function)
  -- Assumes window.move_one_screen_south is a function in your window module
  { mod = K.mod.extra.cmdCtrlAlt, key = "right", action = Window.move_one_screen_south },

  -- Screenshot: ⌃⌘⌥ Left - Previous Display (Custom function)
  -- Note: Your original used win:moveOneScreenNorth directly here,
  -- but you have window.move_one_screen_south. Let's create a similar
  -- wrapper or use the direct hs method. Using direct hs method for now.
  {
    mod = K.mod.extra.cmdCtrlAlt,
    key = "left",
    action = function()
      local win = hs.window.focusedWindow()
      if win then
        -- false for wrapping, true for resize, 0 duration
        win:moveOneScreenNorth(false, true, 0)
      end
    end,
  },

  -- Screenshot: ⌃⌥ R - Restore (Explicit Restore function)
  -- { mod = K.mod.ctrlAlt, key = "r", action = Key.restore_window_frame },

  -- Screenshot: ⌘⇧ Right
  { mod = K.mod.cmdShift, key = "right", action = M.layouts.right_half },

  -- Screenshot: ⌘⇧ Up
  { mod = K.mod.cmdShift, key = "up", action = M.layouts.top_half },

  -- Screenshot: ⌘⌥ U
  { mod = K.mod.cmdAlt, key = "u", action = M.layouts.top_left_quarter },

  -- Screenshot: ⌘⌥ I
  { mod = K.mod.cmdAlt, key = "i", action = M.layouts.top_right_quarter },

  -- Additional partial layouts
  { mod = K.mod.cmdAlt, key = "8", action = M.layouts.last_third_bot23 },
  { mod = K.mod.cmdAlt, key = "9", action = M.layouts.last_third_top13 },
}

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

    if modifiers == nil or key == nil then
      hs.alert.show("Error: Missing modifiers and key for binding")
      logger.d("Error: Missing modifiers or key for binding: " .. tostring(binding) .. "(key :" .. binding.key .. ")")
      goto continue -- Skip this binding if modifiers or key are missing
    end

    -- Perform the binding
    if use_restore then
      Key.bind_with_restore(modifiers, key, thunk)
    else
      -- hs.hotkey.bind(modifiers, key, press_fn, release_fn, repeated_fn)
      -- For simple actions, the press_fn is enough. The thunk is designed for this.
      hs.hotkey.bind(modifiers, key, thunk)
    end
    ::continue:: -- Goto label
  end
end

return M

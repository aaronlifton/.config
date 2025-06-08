-- functions/wm.lua

local obj = {}
obj.__index = obj -- Needed for object-oriented-style method calls (obj:method())

-- Metadata (Optional, good practice)
obj.name = "MyWindowManager"
obj.version = "1.0"
obj.author = "Your Name"
obj.homepage = "https://github.com/your/repo" -- Update this
obj.license = "MIT" -- Or your preferred license

-- Window manipulation history
-- Stored as: { window_id = { frame1, frame2, ... } }
-- Each window_id maps to a stack (table) of historical frames.
obj.history = {}
obj.history_max_size = 50 -- How many frames to store per window

-- Use your window.animationDuration and grid settings if you like, or configure elsewhere
-- hs.window.animationDuration = 0
-- hs.grid.MARGINX = 0
-- hs.grid.MARGINY = 0
-- hs.grid.GRIDWIDTH = 2 -- WinWin used a grid for stepping, we use it for quarters/halves via push
-- hs.grid.GRIDHEIGHT = 2

--- obj:stash(window)
--- Method
--- Stash the current window's position and size into the history.
---
--- Parameters:
---  * window - The window object to stash. Defaults to focused window.
function obj:stash(window)
  local win = window or hs.window.focusedWindow()
  if not win then return end
  local winid = win:id()
  if not winid then return end -- Need a valid window ID

  local current_frame = win:frame()

  -- Initialize history for this window if it doesn't exist
  if not self.history[winid] then self.history[winid] = {} end

  local win_history = self.history[winid]

  -- Check if the current frame is significantly different from the last stashed one
  -- This prevents stashing rapid, tiny changes (e.g., from holding down a resize key)
  -- You can adjust the epsilon (tolerance)
  local epsilon = 5 -- pixels
  if #win_history > 0 then
    local last_frame = win_history[#win_history]
    if
      math.abs(current_frame.x - last_frame.x) < epsilon
      and math.abs(current_frame.y - last_frame.y) < epsilon
      and math.abs(current_frame.w - last_frame.w) < epsilon
      and math.abs(current_frame.h - last_frame.h) < epsilon
    then
      return -- Don't stash if not changed significantly
    end
  end

  -- Add the current frame to the history stack
  table.insert(win_history, current_frame)

  -- Keep history size within the limit
  if #win_history > self.history_max_size then
    table.remove(win_history, 1) -- Remove the oldest entry
  end
end

--- obj:undo()
--- Method
--- Restore the previous window position from the history.
function obj:undo()
  local win = hs.window.focusedWindow()
  if not win then
    -- hs.alert.show("No focused window!") -- Optional alert
    return
  end
  local winid = win:id()
  if not winid then return end

  local win_history = self.history[winid]
  if not win_history or #win_history <= 1 then
    -- hs.alert.show("No history for this window!") -- Optional alert
    return -- No history or only the current frame left
  end

  -- The last frame in history is the current one (added by stash).
  -- The second-to-last frame is the one we want to restore.
  -- We need to remove the current frame first, then restore the new last frame.
  table.remove(win_history) -- Remove the current frame

  local frame_to_restore = win_history[#win_history]
  if frame_to_restore then
    win:setFrame(frame_to_restore, { duration = 0 })
    -- Important: Do NOT stash the restored frame here.
    -- Stashing should only happen *before* a layout is applied.
  end
end

--- obj:redo()
--- Method
--- Re-apply the window manipulation that was just undone (basic redo by re-applying the last history state).
--- Note: A true redo would require a separate "redo" stack. This implementation is simpler,
--- it just reapplies the state that was *not* undone if you press undo again.
--- A more robust redo would involve moving frames between undo and redo stacKey.
--- Given the complexity vs benefit, let's stick to a simple undo for now, matching the screenshot's "Restore" which is usually undo-like.
--- If a real redo is needed, the history structure and undo/redo logic would need significant changes.
--- For now, let's leave `redo` unimplemented or simplistic, as the screenshot only shows "Restore" (Undo).
-- function obj:redo()
--     -- This requires a separate redo stack or a more complex history structure
--     -- Not implementing for now to keep it closer to the screenshot's actions.
-- end

--- obj:push(window, params)
--- Method
--- Move and/or resize the window based on percentage parameters.
--- This is the core positioning logic, adapted from your original window.lua.
---
--- Parameters:
---  * window - The window object to move. Defaults to focused window.
---  * params - A table with optional keys: top, left, width, height (percentages 0-1).
---             e.g., { top=0.5, left=0, width=1, height=0.5 } for bottom half.
function obj:push(window, params)
  local win = window or hs.window.focusedWindow()
  if not win or not params then return false end

  local windowFrame = win:frame()
  local screen = win:screen()
  local screenFrame = screen:frame()

  local moved = false
  local newFrame = hs.geometry.rect(windowFrame) -- Create a mutable copy

  -- Helper to update frame value and track if anything changed
  local function cas(old_val, new_val)
    -- Compare with a small tolerance for floating point
    if math.abs(old_val - new_val) > 1e-6 then moved = true end
    return new_val
  end

  -- Apply parameters based on presence
  if params.left ~= nil then newFrame.x = cas(newFrame.x, screenFrame.x + (screenFrame.w * params.left)) end
  if params.top ~= nil then newFrame.y = cas(newFrame.y, screenFrame.y + (screenFrame.h * params.top)) end
  if params.width ~= nil then newFrame.w = cas(newFrame.w, screenFrame.w * params.width) end
  if params.height ~= nil then newFrame.h = cas(newFrame.h, screenFrame.h * params.height) end

  -- Only set frame if something actually changed
  if moved then win:setFrame(newFrame, { duration = 0 }) end

  return moved -- Return true if the window was moved/resized
end

--- obj:applyLayout(layout_name)
--- Method
--- Applies a predefined layout to the focused window.
--- Stashes the current position before applying the new layout.
---
--- Parameters:
---  * layout_name - A string identifier for the layout (e.g., "left_half", "fullscreen").
function obj:applyLayout(layout_name)
  local win = hs.window.focusedWindow()
  if not win then
    -- hs.alert.show("No focused window!") -- Optional alert
    return
  end

  -- Always stash the current frame before applying a new layout
  self:stash(win)

  -- Define layouts as parameter tables for the push function
  local layouts = {
    -- Full screen
    full = { top = 0, left = 0, width = 1, height = 1 },
    almost_maximize = { top = 0, left = 0, width = 1, height = 1 }, -- Same as full, name matches screenshot

    -- Halves
    left_half = { top = 0, left = 0, width = 0.5, height = 1 },
    right_half = { top = 0, left = 0.5, width = 0.5, height = 1 },
    top_half = { top = 0, left = 0, width = 1, height = 0.5 },
    bottom_half = { top = 0.5, left = 0, width = 1, height = 0.5 },
    maximize_height = { top = 0, height = 1 }, -- Only set top and height

    -- Quarters
    top_left_quarter = { top = 0, left = 0, width = 0.5, height = 0.5 },
    top_right_quarter = { top = 0, left = 0.5, width = 0.5, height = 0.5 },
    bottom_left_quarter = { top = 0.5, left = 0, width = 0.5, height = 0.5 },
    bottom_right_quarter = { top = 0.5, left = 0.5, width = 0.5, height = 0.5 },

    -- Thirds (Horizontal)
    first_third = { top = 0, left = 0, width = 1 / 3, height = 1 },
    middle_third = { top = 0, left = 1 / 3, width = 1 / 3, height = 1 }, -- Added middle for completeness
    last_third = { top = 0, left = 2 / 3, width = 1 / 3, height = 1 },

    -- Two Thirds (Horizontal)
    first_two_thirds = { top = 0, left = 0, width = 2 / 3, height = 1 },
    last_two_thirds = { top = 0, left = 1 / 3, width = 2 / 3, height = 1 }, -- This is the 2/3 on the right
  }

  local params = layouts[layout_name]

  if params then
    self:push(win, params)
  else
    hs.alert.show("Unknown layout: " .. layout_name) -- Alert if a non-existent layout is requested
  end
end

--- obj:applyCenteredLayout(width_ratio, height_ratio)
--- Method
--- Applies a centered layout with specified ratios.
--- Stashes the current position before applying the new layout.
---
--- Parameters:
---  * width_ratio - The desired width as a ratio of screen width (0-1).
---  * height_ratio - The desired height as a ratio of screen height (0-1).
function obj:applyCenteredLayout(width_ratio, height_ratio)
  local win = hs.window.focusedWindow()
  if not win then return end

  self:stash(win)

  local width = width_ratio or 1 -- Default to full width if not specified
  local height = height_ratio or 1 -- Default to full height if not specified
  local left = (1 - width) / 2
  local top = (1 - height) / 2

  local params = { top = top, left = left, width = width, height = height }
  self:push(win, params)
end

--- obj:makeLarger()
--- Method
--- Increases the focused window size slightly, attempting to center it.
--- Stashes the current position before resizing.
function obj:makeLarger()
  local win = hs.window.focusedWindow()
  if not win then return end

  self:stash(win) -- Stash before changing size

  local frame = win:frame()
  local screenFrame = win:screen():fullFrame() -- Use fullFrame for accurate screen bounds

  local increase_factor = 0.02 -- Increase size by 2% of screen dimension (adjust as needed)

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

--- obj:makeSmaller()
--- Method
--- Decreases the focused window size slightly, attempting to center it.
--- Stashes the current position before resizing.
function obj:makeSmaller()
  local win = hs.window.focusedWindow()
  if not win then return end

  self:stash(win) -- Stash before changing size

  local frame = win:frame()
  local screenFrame = win:screen():fullFrame() -- Use fullFrame

  local decrease_factor = 0.02 -- Decrease size by 2% of screen dimension (adjust as needed)
  local min_width = screenFrame.w * 0.1 -- Don't make it too small (10% of screen width)
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

  -- Only apply if the size actually changed (prevents infinite loop if hitting min size)
  if new_width < frame.w or new_height < frame.h then
    win:setFrame({ x = new_x, y = new_y, w = new_width, h = new_height }, { duration = 0 })
  end
end

--- obj:moveToScreen(direction)
--- Method
--- Move the focused window to the next/previous/specific screen.
--- Stashes the current position before moving.
---
--- Parameters:
---  * direction - String: "next", "prev", "up", "down", "left", "right".
function obj:moveToScreen(direction)
  local win = hs.window.focusedWindow()
  if not win then return end

  self:stash(win) -- Stash before moving screens

  local current_screen = win:screen()
  local target_screen = nil

  if direction == "next" then
    target_screen = current_screen:next()
  elseif direction == "prev" then
    target_screen = current_screen:previous()
    -- Using moveOneScreen methods for directional screen movement
    -- These methods handle wrapping and relative screen positions well
  elseif direction == "up" then
    win:moveOneScreenNorth(false, true, 0)
    return -- moveOneScreen handles the action directly
  elseif direction == "down" then
    win:moveOneScreenSouth(false, true, 0)
    return -- moveOneScreen handles the action directly
  elseif direction == "left" then
    win:moveOneScreenWest(false, true, 0)
    return -- moveOneScreen handles the action directly
  elseif direction == "right" then
    win:moveOneScreenEast(false, true, 0)
    return -- moveOneScreen handles the action directly
  else
    -- Optionally handle moving to a screen by index or ID if needed
    -- hs.alert.show("Unknown screen direction: " .. direction)
    return
  end

  if target_screen and target_screen ~= current_screen then
    win:moveToScreen(target_screen) -- moveToScreen also takes care of positioning based on relative size
  end
end

--- obj:reasonableSize()
--- Method
--- Applies a reasonable size and centers the window.
--- Stashes the current position before applying.
function obj:reasonableSize()
  -- Use the centered layout helper for consistency
  self:applyCenteredLayout(0.75, 0.75) -- 3/4 width and height, centered
end

return obj -- Return the module object

local M = {}

-- Wrapper function to handle saving/restoring window frame before applying an action
-- This is the same logic as your original bind_with_restore, just named slightly differently
-- to fit the new structure if needed, but we can keep your original as it's well defined.
function M.bind_with_restore(mod_keys, key, thunk)
  hs.hotkey.bind(mod_keys, key, function()
    local current_window = hs.window.focusedWindow()
    if not current_window then return end -- Ensure a window is focused
    local current_frame = current_window:frame()
    local window_id = current_window:id()
    if not window_id then return end -- Ensure the window has an ID

    -- Check if the window is already in a restorable state (i.e., we stored a frame)
    local restorable_frame = Window.restorable_frames[window_id]
    if restorable_frame then
      -- If yes, restore the frame and clear the stored state
      current_window:setFrame(restorable_frame)
      Window.restorable_frames[window_id] = nil
      -- Optional: Add a subtle visual cue
      -- hs.animate({current_window:setFrame(restorable_frame)}, {duration=0.1, fn='linear'})
    else
      -- If no, store the current frame and apply the new layout/action (thunk)
      Window.restorable_frames[window_id] = current_frame
      thunk() -- Execute the action (apply layout or run function)
    end
  end)
end

-- Explicit function to restore the frame for the current window
-- Can be bound to a hotkey directly if you don't want it tied to the layout key
function M.restore_window_frame()
  local current_window = hs.window.focusedWindow()
  if not current_window then return end
  local window_id = current_window:id()
  if not window_id then return end

  local restorable_frame = Window.restorable_frames[window_id]
  if restorable_frame then
    current_window:setFrame(restorable_frame)
    Window.restorable_frames[window_id] = nil -- Clear after restoring
    -- Optional: Add a small notification?
    -- hs.notify.show("Hammerspoon", "", "Window frame restored.")
    -- else
    -- Optional: Notify user that no frame was stored for this window
    -- hs.notify.show("Hammerspoon", "", "No frame stored for this window.")
  end
end

return M

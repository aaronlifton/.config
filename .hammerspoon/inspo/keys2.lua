-- keys.lua

local M = {}

-- Require the new window manager module
local wm = require("functions/wm") -- Assuming wm.lua is in functions/

-- local browser = require("functions/browser") -- Keep if needed

M.hyper = { "cmd", "alt", "ctrl", "shift" }

-- Your bind_with_restore function is no longer needed for simple layout application,
-- as the history is handled by wm:stash() and wm:undo().
-- The exception might be if you want a specific layout (like Almost Maximize)
-- to *toggle* between fullscreen and its *immediately previous* state,
-- which is slightly different from the full undo stack.
-- However, for simplicity and closer adherence to a history model,
-- let's use stash/undo for all actions that change the frame.
-- The "Restore" action will simply call wm:undo().

-- If you still *really* want a specific key to toggle *only* between two states (current and a target layout),
-- you would need a modified toggle function that works *with* the history, or maintains its own single-level state.
-- Let's stick to the history approach for now as it's cleaner and more powerful.

-- Helper to bind a key to apply a specific layout name string
local function bind_layout(mod_keys, key, layout_name)
  hs.hotkey.bind(mod_keys, key, function()
    wm:applyLayout(layout_name)
  end)
end

-- Helper to bind a key to apply a specific centered layout ratio
local function bind_centered_layout(mod_keys, key, width_ratio, height_ratio)
  hs.hotkey.bind(mod_keys, key, function()
    wm:applyCenteredLayout(width_ratio, height_ratio)
  end)
end

-- SYMBOLS----------------------------------------------------------------------
-- ⌘ ⌃ ⌥ ⇧
---c-c-a-s----------------------------------------------------------------------

-- account for hidden dock (keep this line if needed)
hs.grid.setMargins({ x = 0, y = 0 })

function M.bind()
  -- Use the new helper functions to bind layouts

  -- Almost Maximize (Uses the 'almost_maximize' layout name)
  -- Screenshot: ⌘⇧ Z
  bind_layout({ "cmd", "shift" }, "z", "almost_maximize")

  -- Bottom Half
  -- Screenshot: ⌘⇧ Down
  bind_layout({ "cmd", "shift" }, "down", "bottom_half")

  -- Bottom Left Quarter
  -- Screenshot: ⌘⌥ J
  bind_layout({ "cmd", "alt" }, "j", "bottom_left_quarter")

  -- Bottom Right Quarter
  -- Screenshot: ⌘⌥ K
  bind_layout({ "cmd", "alt" }, "k", "bottom_right_quarter")

  -- Center (Assuming 2/3 centered)
  -- Screenshot: ⌘⌥ L
  bind_centered_layout({ "cmd", "alt" }, "l", 2 / 3, 2 / 3)

  -- Center Third (Assuming 1/3 centered)
  -- Screenshot: ⌘⌥ F
  bind_centered_layout({ "cmd", "alt" }, "f", 1 / 3, 1 / 3)

  -- First Third (Left third)
  -- Screenshot: ⌘⌥ D
  bind_layout({ "cmd", "alt" }, "d", "first_third")

  -- First Two Thirds (Left two thirds)
  -- Screenshot: ⌘⌥ E
  bind_layout({ "cmd", "alt" }, "e", "first_two_thirds")

  -- Last Third (Right third)
  -- Screenshot: ⌘⌥ G
  bind_layout({ "cmd", "alt" }, "g", "last_third")

  -- Last Two Thirds (Right two thirds)
  -- Screenshot: ⌘⌥ T
  bind_layout({ "cmd", "alt" }, "t", "last_two_thirds")

  -- Left Half
  -- Screenshot: ⌘⇧ Left
  bind_layout({ "cmd", "shift" }, "left", "left_half")

  -- Make Larger (Calls the specific method)
  -- Screenshot: ⌘⌥ ->
  hs.hotkey.bind({ "cmd", "alt" }, "right", function()
    wm:makeLarger()
  end)

  -- Make Smaller (Calls the specific method)
  -- Screenshot: ⌘⌥ <-
  hs.hotkey.bind({ "cmd", "alt" }, "left", function()
    wm:makeSmaller()
  end)

  -- Maximize (Full screen, uses the 'full' layout name)
  -- Screenshot: ⌘⌥ Return
  bind_layout({ "cmd", "alt" }, "return", "full")

  -- Maximize Height
  -- Screenshot: ⌘⌥ Up
  bind_layout({ "cmd", "alt" }, "up", "maximize_height")

  -- Next Display (Calls the specific method)
  -- Screenshot: ⌃⌘⌥ Right
  hs.hotkey.bind({ "alt", "ctrl", "cmd" }, "right", function()
    wm:moveToScreen("next")
  end) -- Changed to "next" for clarity

  -- Previous Display (Calls the specific method)
  -- Screenshot: ⌃⌘⌥ Left
  hs.hotkey.bind({ "alt", "ctrl", "cmd" }, "left", function()
    wm:moveToScreen("prev")
  end) -- Changed to "prev" for clarity

  -- Reasonable Size (Calls the specific method)
  -- Screenshot: ⌘⌥⇧ R
  hs.hotkey.bind({ "cmd", "alt", "shift" }, "r", function()
    wm:reasonableSize()
  end)

  -- Restore (Explicit Undo - calls the specific method)
  -- Screenshot: ⌃⌥ R
  hs.hotkey.bind({ "ctrl", "alt" }, "r", function()
    wm:undo()
  end)

  -- Right Half
  -- Screenshot: ⌘⇧ Right
  bind_layout({ "cmd", "shift" }, "right", "right_half")

  -- Top Half
  -- Screenshot: ⌘⇧ Up
  bind_layout({ "cmd", "shift" }, "up", "top_half")

  -- Top Left Quarter
  -- Screenshot: ⌘⌥ U
  bind_layout({ "cmd", "alt" }, "u", "top_left_quarter")

  -- Top Right Quarter
  -- Screenshot: ⌘⌥ I
  bind_layout({ "cmd", "alt" }, "i", "top_right_quarter")

  -- Other bindings from your file (keep if you still want them)
  -- hs.hotkey.bind({ "ctrl" }, "space", function() ... end) -- Kitty toggle
  -- hs.hotkey.bind({ "ctrl" }, "escape", function() ... end) -- ` character
  -- hs.hotkey.bind({ "alt" }, "escape", function() ... end) -- ` character (Faster)
  -- hs.hotkey.bind({ "shift" }, "escape", function() ... end) -- ~ character

  -- ClipboardTool (keep if you use this Spoon)
  -- if spoon.ClipboardTool then
  --   spoon.ClipboardTool.hist_size = 50
  --   spoon.ClipboardTool.show_copied_alert = false
  --   spoon.ClipboardTool.show_in_menubar = false
  --   spoon.ClipboardTool:start()
  --   spoon.ClipboardTool:bindHotkeys({
  --     toggle_clipboard = { { "ctrl", "alt", "cmd" }, "v" },
  --   })
  -- end

  -- Function keys (keep if you use this)
  -- local hotkeys = { ... }
  -- for _, values in ipairs(hotkeys) do ... end

  -- Chrome (keep if you use this)
  -- hs.hotkey.bind({ "cmd", "shift" }, "T", browser.newTabToRight)
end

return M

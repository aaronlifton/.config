---@class Raycast
local M = {}

local raycast_bundle_id = App.bundles.raycast

-- Function to check the frontmost window's application
local function check_frontmost_window()
  Window.check_frontmost_window(raycast_bundle_id)
end

-- Use an event tap to trigger the overlay check on every key and mouse click
local overlayCheckEventTap = hs.eventtap.new(
  { hs.eventtap.event.types.flagsChanged, hs.eventtap.event.types.keyDown },
  function()
    -- Check if the frontmost app is Raycast or ChatGPT, and if it is an overlay
    check_frontmost_window()
    hs.alert.show("Raycast Overlay Window Detected")
    return false -- Pass the event to the next handler
  end
)

local raycast_shortcuts = {
  [{ {}, "a" }] = "raycast://extensions/raycast/raycast-ai/ai-chat",
  [{ {}, "c" }] = "raycast://extensions/raycast/clipboard-history/clipboard-history",
  [{ {}, "e" }] = "raycast://extensions/raycast/emoji-symbols/search-emoji-symbols",
  [{ {}, "s" }] = "raycast://extensions/raycast/snippets/search-snippets",
  [{ {}, "w" }] = "raycast://extensions/raycast/navigation/switch-windows",
  -- Window management
  -- [{ {}, 'h' }] = "raycast://extensions/raycast/window-management/left-half",
  -- [{ {}, 'j' }] = "raycast://extensions/raycast/window-management/almost-maximize",
  -- [{ {}, 'k' }] = "raycast://extensions/raycast/window-management/maximize",
  -- [{ {}, 'l' }] = "raycast://extensions/raycast/window-management/right-half",
  -- [{ { 'ctrl' }, 'h' }] = "raycast://extensions/raycast/window-management/top-left-quarter",
  -- [{ { 'ctrl' }, 'j' }] = "raycast://extensions/raycast/window-management/bottom-left-quarter",
  -- [{ { 'ctrl' }, 'k' }] = "raycast://extensions/raycast/window-management/top-right-quarter",
  -- [{ { 'ctrl' }, 'l' }] = "raycast://extensions/raycast/window-management/bottom-right-quarter",
  -- [{ { 'shift' }, 'h' }] = "raycast://extensions/raycast/window-management/previous-desktop",
  -- [{ { 'shift' }, 'l' }] = "raycast://extensions/raycast/window-management/next-desktop",
  -- [{ {}, ';' }] = "raycast://extensions/raycast/window-management/next-display",
}

for k, v in pairs(raycast_shortcuts) do
  M.bind(k[1], k[2], function()
    hs.execute("open -g " .. v)
  end)
end

overlayCheckEventTap:start()

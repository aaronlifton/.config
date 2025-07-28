local M = {}

-- Hammerspoon Script to Automate Font Book Conflict Resolution
-- Usage (in Hammerspoon console):
-- `m = require("scripts/install_fonts")`
-- `m.startFontConflictResolver()`

-- Define a global variable to hold the timer instance.
-- This allows us to start and stop the timer programmatically.
local fontConflictResolverTimer = nil

--- Main function to check for and resolve font conflicts in Font Book.
-- This function is designed to be called periodically by a Hammerspoon timer.
local function resolveFontConflicts()
  local fontBookApp = hs.application.find("Font Book")

  -- If Font Book is not running or not visible, there's nothing to do.
  -- This prevents unnecessary checks when Font Book is not in use.
  if not fontBookApp or not fontBookApp:isVisible() then return end

  -- Iterate through all active windows belonging to Font Book.
  -- We need to check all windows as multiple dialogs might appear.
  for _, window in ipairs(fontBookApp:allWindows()) do
    local windowTitle = window:title() or ""

    local dialogElement = hs.uielement.fromWindow(window)

    if not dialogElement then
      -- Log an error if the UI element cannot be retrieved, but continue checking other windows.
      hs.alert.show("Could not get UI element for a Font Book dialog with title: " .. windowTitle)
      Logger.w("Font Conflict Resolver: Could not get UI element for dialog: " .. windowTitle)
      -- Use Lua's `goto` to skip the rest of the current loop iteration and move to the next window.
      goto continue_next_window
    end

    -- Get the entire text content of the dialog
    local dialogText = dialogElement:attributeValue("AXValue") or ""
    
    -- Get all accessibility buttons within the dialog.
    local buttons = dialogElement:childrenWithRole("AXButton")
    local actionTaken = false -- Flag to track if an action was performed on this dialog

    -- Check for different dialog conditions based on text content
    local isConflictDialog = string.find(dialogText, "A version of this font is already installed", 1, true) ~= nil
    
    -- Function to determine if the Skip button should be clicked
    local function canSkip()
      local skipButton = nil
      local installButton = nil
      local replaceButton = nil
      
      for _, button in ipairs(buttons) do
        local buttonTitle = button:title()
        if buttonTitle == "Skip" then
          skipButton = button
        elseif buttonTitle == "Install" then
          installButton = button
        elseif buttonTitle == "Replace" then
          replaceButton = button
        end
      end
      
      -- Click Skip if: Skip is enabled AND (Install OR Replace is present but disabled)
      if skipButton and skipButton:isEnabled() then
        if (installButton and not installButton:isEnabled()) or (replaceButton and not replaceButton:isEnabled()) then
          return true
        end
      end
      
      return false
    end
    
    local fontNotValidatedCase = string.find(dialogText, "The font could not be validated", 1, true) ~= nil

    -- Handle font validation failed case first
    if fontNotValidatedCase then
      local installButton = nil
      local skipButton = nil
      
      -- Find Install and Skip buttons
      for _, button in ipairs(buttons) do
        local buttonTitle = button:title()
        if buttonTitle == "Install" then
          installButton = button
        elseif buttonTitle == "Skip" then
          skipButton = button
        end
      end
      
      -- If Install button is enabled, click it
      if installButton and installButton:isEnabled() then
        hs.alert.show("Font validation failed - clicking 'Install' for '" .. windowTitle .. "'.")
        installButton:press()
        actionTaken = true
      -- Otherwise, if Install button is disabled, click Skip
      elseif installButton and not installButton:isEnabled() and skipButton and skipButton:isEnabled() then
        hs.alert.show("Font validation failed - Install disabled, clicking 'Skip' for '" .. windowTitle .. "'.")
        skipButton:press()
        actionTaken = true
      end
    end

    -- Handle conflict dialog case
    if not actionTaken and isConflictDialog then
      -- 1. Prioritize clicking "Install" if it's available and enabled.
      for _, button in ipairs(buttons) do
        Logger.d(hs.inspect(buttons))
        local buttonTitle = button:title()
        if buttonTitle == "Install" and button:isEnabled() then
          hs.alert.show("Clicking 'Install' for '" .. windowTitle .. "'.")
          button:press()
          actionTaken = true
          break -- Action taken, no need to check other buttons in this dialog
        end
      end
    end

    -- Handle canSkip case
    if not actionTaken and canSkip() then
      for _, button in ipairs(buttons) do
        local buttonTitle = button:title()
        if buttonTitle == "Skip" and button:isEnabled() then
          hs.alert.show("Clicking 'Skip' for '" .. windowTitle .. "'.")
          button:press()
          actionTaken = true
          break
        end
      end
    end

    -- Fallback: if no specific condition was met, try to handle any remaining dialogs
    if not actionTaken then
      for _, button in ipairs(buttons) do
        local buttonTitle = button:title()
        Logger.d(("Found button: %s"):format(buttonTitle))
        if buttonTitle == "Skip" and button:isEnabled() then
          hs.alert.show("Fallback - clicking 'Skip' for '" .. windowTitle .. "'.")
          button:press()
          actionTaken = true
          break
        end
      end
    end

    -- Optional: If an action was taken for this dialog, you might want to introduce
    -- a small delay before the next check. This can give Font Book a moment to process
    -- the click and close the dialog before the script attempts to interact again.
    -- hs.timer.doAfter(0.1, function() end) -- Example: 100ms delay

    -- No need for `if actionTaken then ... end` here, as the loop naturally moves on
    -- or the timer will re-evaluate in the next cycle.

    ::continue_next_window:: -- Label for `goto` statement to continue to the next window.
  end
end

-- --- Public Functions / Timer Setup ---

--- Starts the Font Book conflict resolution timer.
-- This function should be called once, typically when Hammerspoon loads.
function M.startFontConflictResolver(interval)
  interval = interval or 1.0 -- Default to 1 second if no interval is provided
  -- If a timer already exists, stop it first to prevent multiple timers running.
  if fontConflictResolverTimer then fontConflictResolverTimer:stop() end
  -- Create a new timer that runs the `resolveFontConflicts` function every 1.0 second.
  -- You can adjust this interval (e.g., 0.5 for half a second, 2.0 for two seconds)
  -- based on how frequently you want it to check.
  fontConflictResolverTimer = hs.timer.new(interval, resolveFontConflicts)
  fontConflictResolverTimer:start() -- Start the timer
  hs.alert.show(string.format("Hammerspoon: Font Conflict Resolver STARTED. Checking every %d second.", interval))
  Logger.i("Font Conflict Resolver: Started.")
end

--- Stops the Font Book conflict resolution timer.
-- This can be useful for debugging or when you don't want the automation running.
function M.stopFontConflictResolver()
  if fontConflictResolverTimer then
    fontConflictResolverTimer:stop()
    fontConflictResolverTimer = nil -- Clear the reference to allow garbage collection
    hs.alert.show("Hammerspoon: Font Conflict Resolver STOPPED.")
    Logger.i("Font Conflict Resolver: Stopped.")
  end
end

-- --- Auto-start on Hammerspoon Reload ---
-- This line ensures that the font conflict resolver starts automatically
-- every time Hammerspoon is launched or its configuration is reloaded.
-- startFontConflictResolver()

-- --- Optional: Hotkeys to manually control the resolver ---
-- You can uncomment and use these lines to define keyboard shortcuts
-- to start or stop the resolver if needed.

-- Example Hotkey: Cmd+Option+Control+F to stop the resolver
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "f", stopFontConflictResolver)

-- Example Hotkey: Cmd+Option+Control+Shift+F to start the resolver (if it was stopped)
-- hs.hotkey.bind({"cmd", "alt", "ctrl", "shift"}, "f", startFontConflictResolver)

return M

--- @class ButtonClicker
--- @field state.button_clicker_timer hs.timer | nil Timer for clicking the OK button
--- @field state.not_found_count number Count of consecutive times the OK button was not found
--- @field config.imagePath string Path to the OK button image
local M = {
  state = {
    okButtonTimer = nil,
    notFoundCount = 0,
  },
  config = {
    imagePath = "assets/osx_dark/ok_button.png", -- Make sure this image is in your ~/.hammerspoon/ folder
  },
}

-- Load the image of the "OK" button.
local okButtonImage = hs.image.new(hs.filesystem.pathToAbsolute(M.config.imagePath))

if not okButtonImage then
  hs.alert.show("Error: Could not load " .. M.config.imagePath .. ". Make sure it's in your ~/.hammerspoon/ folder.")
  return
end

-- Function to find and click the OK button
local function findAndClickOkButton()
  local match = hs.screen.findImage(okButtonImage)

  if match then
    -- Button found, click its center
    local clickPoint = match:center()
    hs.mouse.click(clickPoint)
    -- hs.alert.show("OK button clicked!") -- Uncomment for visual feedback
    M.state.notFoundCount = 0 -- Reset count if found
  else
    -- Button not found
    M.state.notFoundCount = M.state.notFoundCount + 1
    -- hs.alert.show("OK button not found. Consecutive misses: " .. M.state.notFoundCount) -- Uncomment for visual feedback

    -- If not found for 10 seconds (2 * 5-second intervals), stop the timer
    if M.state.notFoundCount >= 2 then
      if M.state.okButtonTimer then
        M.state.okButtonTimer:stop()
        M.state.okButtonTimer = nil
        hs.alert.show("OK button not found for 10 seconds. Stopping auto-clicker.")
      end
    end
  end
end

-- Function to start clicking the OK button
function M.startOkButtonClicker()
  if M.state.okButtonTimer then
    hs.alert.show("OK button clicker is already running.")
    return
  end

  M.state.notFoundCount = 0 -- Reset count when starting
  -- Create a new timer that fires every 5 seconds
  M.state.okButtonTimer = hs.timer.new(5, findAndClickOkButton)
  M.state.okButtonTimer:start()
  hs.alert.show("Started clicking OK button every 5 seconds.")
end

-- Function to stop clicking the OK button (optional, for manual control)
function M.stopOkButtonClicker()
  if M.state.okButtonTimer then
    M.state.okButtonTimer:stop()
    M.state.okButtonTimer = nil
    hs.alert.show("Stopped OK button clicker.")
  else
    hs.alert.show("OK button clicker is not running.")
  end
end

-- You can assign these functions to hotkeys for easy access
-- Uncomment and modify the hotkeys as you prefer
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "o", startOkButtonClicker) -- Example hotkey to start
-- hs.hotkey.bind({"cmd", "alt", "ctrl"}, "p", stopOkButtonClicker)  -- Example hotkey to stop

-- To start the clicker automatically when Hammerspoon launches, uncomment the line below:
-- startOkButtonClicker()

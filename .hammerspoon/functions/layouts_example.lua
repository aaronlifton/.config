local M = {}

-- Example usage of the layouts module
-- This shows how to replace the original binding logic with the new modular functions
local layouts = require("functions.layouts")

-- Example 1: Using the original three-column tiling layout
-- This replaces the original complex binding with a simple function call
function M.setupOriginalThreeColumnLayout()
  -- Create the binding using the helper function
  layouts.createThreeColumnBinding(HyperBinding, "0")
end

M.customLayouts = {
  ["1"] = function()
    -- Define a custom pattern (e.g., three equal columns)
    local threeEqualColumnsPattern = {
      { "0,0 0.33x2" }, -- Left third
      { "0.33,0 0.33x2" }, -- Middle third
      { "0.66,0 0.34x2" }, -- Right third
    }

    layouts.tileWindowsWithPattern(threeEqualColumnsPattern, function(windows, startIndex, lastScreen)
      -- Custom overflow handling - minimize remaining windows
      layouts.minimizeRemainingWindows(windows, startIndex)
    end)
  end,
}

-- Example 2: Creating a custom tiling pattern
function M.setupCustomLayout()
  -- Define a custom pattern (e.g., three equal columns)
  local threeEqualColumnsPattern = {
    { "0,0 0.33x2" }, -- Left third
    { "0.33,0 0.33x2" }, -- Middle third
    { "0.66,0 0.34x2" }, -- Right third
  }

  -- Create a custom tiling function
  local function customTiling()
    return layouts.tileWindowsWithPattern(threeEqualColumnsPattern, function(windows, startIndex, lastScreen)
      -- Custom overflow handling - minimize remaining windows
      layouts.minimizeRemainingWindows(windows, startIndex)
    end)
  end

  -- Bind it to a hotkey
  layouts.createTilingBinding(HyperBinding, "1", customTiling, "Three equal columns layout")
end

-- Example 3: Quick setup for all common layouts
function M.setupAllLayouts()
  local hyperBinding = HyperBinding

  -- This single call sets up:
  -- - Three-column layout on Hyper+0
  -- - Two-column layout on Hyper+9
  -- - Four-quadrant layout on Hyper+8
  layouts.setupCommonLayouts(hyperBinding)
end

-- Usage examples:
-- M.setupOriginalThreeColumnLayout()  -- Just the original layout
-- M.setupCustomLayout()               -- Add a custom layout
-- M.setupAllLayouts()                 -- Set up all common layouts
return M

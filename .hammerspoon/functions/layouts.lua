local M = {}

-- ========================================
-- Window Utility Functions
-- ========================================

-- Get all valid, visible, non-minimized windows
function M.getValidWindows()
  local allWindows = hs.window.visibleWindows()
  local validWindows = {}

  for _, window in ipairs(allWindows) do
    if not window:isMinimized() and window:isStandard() then table.insert(validWindows, window) end
  end

  return validWindows
end

-- Sort windows with focused window first, then by application name
function M.sortWindowsWithFocusedFirst(windows)
  local focusedWindow = hs.window.focusedWindow()
  if not focusedWindow then return windows end

  local sortedWindows = {}
  table.insert(sortedWindows, focusedWindow)

  for _, window in ipairs(windows) do
    if window:id() ~= focusedWindow:id() then table.insert(sortedWindows, window) end
  end

  return sortedWindows
end

-- Filter windows by screen
function M.getWindowsOnScreen(windows, screen)
  local screenWindows = {}
  for _, window in ipairs(windows) do
    if window:screen():id() == screen:id() then table.insert(screenWindows, window) end
  end
  return screenWindows
end

-- ========================================
-- Screen Management Functions
-- ========================================

-- Get all available screens
function M.getAvailableScreens()
  return hs.screen.allScreens()
end

-- Check if multiple screens are available and configured
function M.hasMultipleScreens()
  return Config.screenCount and Config.screenCount > 1
end

-- Get the primary screen
function M.getPrimaryScreen()
  return hs.screen.primaryScreen()
end

-- Move window to screen if different from current
function M.moveWindowToScreen(window, screen)
  if window:screen():id() ~= screen:id() then window:moveToScreen(screen) end
end

-- ========================================
-- Window Positioning Functions
-- ========================================

-- Position window using grid and raise it
function M.positionWindow(window, gridPosition)
  hs.grid.set(window, gridPosition)
  window:raise()
end

-- Position window on specific screen with grid position
function M.positionWindowOnScreen(window, screen, gridPosition)
  M.moveWindowToScreen(window, screen)
  M.positionWindow(window, gridPosition)
end

-- Create a custom grid position string
function M.createGridPosition(x, y, width, height)
  return x .. "," .. y .. " " .. width .. "x" .. height
end

-- ========================================
-- Window Layout Patterns
-- ========================================

-- Three-column layout: left half, right top half, right bottom half
M.ThreeColumnPattern = {
  { Grid.leftHalf },
  { Grid.rightTopHalf },
  { Grid.rightBottomHalf },
}

-- Two-column layout: left half, right half
M.TwoColumnPattern = {
  { Grid.leftHalf },
  { Grid.rightHalf },
}

-- Four-quadrant layout
M.QuadrantPattern = {
  { Grid.topLeftQuarter },
  { Grid.topRightQuarter },
  { Grid.bottomLeftQuarter },
  { Grid.bottomRightQuarter },
}

-- ========================================
-- Overflow Handling Functions
-- ========================================

-- Minimize remaining windows
function M.minimizeRemainingWindows(windows, startIndex)
  for i = startIndex, #windows do
    windows[i]:minimize()
  end
end

-- Stack remaining windows on the last screen
function M.stackRemainingWindows(windows, startIndex, screen)
  for i = startIndex, #windows do
    local window = windows[i]
    local stackIndex = i - startIndex
    local stackPosition = 1 + (stackIndex * 0.5)
    if stackPosition > 2 then stackPosition = 2 end

    local gridString = M.createGridPosition(1, stackPosition - 1, 1, 0.5)
    M.positionWindowOnScreen(window, screen, gridString)
  end
end

-- Hide remaining windows (alternative to minimize)
function M.hideRemainingWindows(windows, startIndex)
  for i = startIndex, #windows do
    windows[i]:application():hide()
  end
end

-- ========================================
-- Main Tiling Functions
-- ========================================

-- Generic tiling function that applies a pattern across screens
function M.tileWindowsWithPattern(pattern, overflowHandler)
  local focusedWindow = hs.window.focusedWindow()
  if not focusedWindow then return false end

  local validWindows = M.getValidWindows()
  if #validWindows <= 1 then return false end

  local sortedWindows = M.sortWindowsWithFocusedFirst(validWindows)
  local screens = M.getAvailableScreens()
  local hasMultipleScreens = M.hasMultipleScreens()

  local windowIndex = 1
  local screenIndex = 1
  local patternLength = #pattern

  -- Process windows according to pattern
  while windowIndex <= #sortedWindows and screenIndex <= #screens do
    local currentScreen = screens[screenIndex]
    local windowsPlacedOnScreen = 0

    -- Place windows according to pattern on current screen
    for patternIndex = 1, patternLength do
      if windowIndex > #sortedWindows then break end

      local window = sortedWindows[windowIndex]
      local gridPosition = pattern[patternIndex][1]

      M.positionWindowOnScreen(window, currentScreen, gridPosition)

      windowIndex = windowIndex + 1
      windowsPlacedOnScreen = windowsPlacedOnScreen + 1
    end

    -- Move to next screen if we have multiple screens and more windows
    if hasMultipleScreens and windowIndex <= #sortedWindows then
      screenIndex = screenIndex + 1
    else
      break
    end
  end

  -- Handle remaining windows using the provided overflow handler
  if windowIndex <= #sortedWindows and overflowHandler then
    if hasMultipleScreens and #screens > 0 then
      overflowHandler(sortedWindows, windowIndex, screens[#screens])
    else
      overflowHandler(sortedWindows, windowIndex, nil)
    end
  end

  return true
end

-- Three-column tiling layout (original layout from the binding)
function M.threeColumnTiling()
  return M.tileWindowsWithPattern(M.ThreeColumnPattern, function(windows, startIndex, lastScreen)
    if M.hasMultipleScreens() and lastScreen then
      M.stackRemainingWindows(windows, startIndex, lastScreen)
    else
      M.minimizeRemainingWindows(windows, startIndex)
    end
  end)
end

-- Two-column tiling layout
function M.twoColumnTiling()
  return M.tileWindowsWithPattern(M.TwoColumnPattern, function(windows, startIndex, lastScreen)
    if M.hasMultipleScreens() and lastScreen then
      M.stackRemainingWindows(windows, startIndex, lastScreen)
    else
      M.minimizeRemainingWindows(windows, startIndex)
    end
  end)
end

-- Four-quadrant tiling layout
function M.quadrantTiling()
  return M.tileWindowsWithPattern(M.QuadrantPattern, function(windows, startIndex, lastScreen)
    if M.hasMultipleScreens() and lastScreen then
      M.stackRemainingWindows(windows, startIndex, lastScreen)
    else
      M.minimizeRemainingWindows(windows, startIndex)
    end
  end)
end

-- ========================================
-- Hotkey Binding Helpers
-- ========================================

-- Create a hotkey binding for a tiling function
function M.createTilingBinding(modifiers, key, tilingFunction, description)
  return hs.hotkey.bind(modifiers, key, description or "Tiling Layout", tilingFunction)
end

-- Create the original three-column tiling binding
function M.createThreeColumnBinding(modifiers, key)
  return M.createTilingBinding(modifiers, key, M.threeColumnTiling, "Three-column tiling layout")
end

-- Create a two-column tiling binding
function M.createTwoColumnBinding(modifiers, key)
  return M.createTilingBinding(modifiers, key, M.twoColumnTiling, "Two-column tiling layout")
end

-- Create a quadrant tiling binding
function M.createQuadrantBinding(modifiers, key)
  return M.createTilingBinding(modifiers, key, M.quadrantTiling, "Four-quadrant tiling layout")
end

-- ========================================
-- Convenience Functions
-- ========================================

-- Quick setup for common tiling layouts
function M.setupCommonLayouts(hyperBinding)
  if not hyperBinding then
    print("Warning: No HyperBinding provided to setupCommonLayouts")
    return
  end

  -- Three-column layout (original)
  M.createThreeColumnBinding(hyperBinding, "0")

  -- Two-column layout
  M.createTwoColumnBinding(hyperBinding, "9")

  -- Four-quadrant layout
  M.createQuadrantBinding(hyperBinding, "8")
end

return M

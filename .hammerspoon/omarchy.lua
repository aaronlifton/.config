-- Omarchy-inspired Hammerspoon Configuration
-- Based on typical Hyprland/i3-style tiling window manager keybindings
-- Inspired by Omarchy's navigation patterns and hotkeys
--
-- Key Features:
-- - Uses Super/Cmd as the main modifier (like Hyprland/i3)
-- - Vim-style hjkl navigation for window focus
-- - Master-stack layout management
-- - Workspace/space navigation (1-9)
-- - Window swapping and resizing
-- - Quick application launching
-- - Floating window toggle
--
-- Usage:
-- 1. In your init.lua, add:
--    local omarchy = require("omarchy")
--    omarchy.init()
--
-- 2. Key bindings overview:
--    Super + Space         - Application launcher (Raycast)
--    Super + Return        - Terminal (Kitty)
--    Super + w             - Close window
--    Super + f             - Toggle fullscreen
--    Super + hjkl          - Focus window in direction
--    Super + Shift + hjkl  - Move window between screens
--    Super + Ctrl + hjkl   - Resize window
--    Super + t             - Apply tiled layout
--    Super + Tab           - Cycle windows forward
--    Super + 1-9           - Go to workspace
--    Super + Shift + 1-9   - Move window to workspace
--    Super + Alt + hjkl    - Snap window to screen halves
--    Super + Alt + uinm    - Snap window to quarters
--    Super + Alt + c       - Center window
--    Super + Shift + r     - Reload Hammerspoon
--    Super + Shift + q     - Lock screen

local M = {}

K = {
  mod = {
    hyper = { "cmd", "alt", "ctrl", "shift" },
    super = { "cmd" },
    superShift = { "cmd", "shift" },
    superAlt = { "cmd", "alt" },
    superCtrl = { "cmd", "ctrl" },
    superShiftAlt = { "cmd", "shift", "alt" },
    alt = { "alt" },
    ctrl = { "ctrl" },
    shift = { "shift" },
  },
}

-- Import required modules
local window = require("functions.window")

-- Define modifier keys (using Super/Cmd as the main modifier like Hyprland)
local default_mod = {
  super = { "cmd" },
  superShift = { "cmd", "shift" },
  superAlt = { "cmd", "alt" },
  superCtrl = { "cmd", "ctrl" },
  superShiftAlt = { "cmd", "shift", "alt" },
  alt = { "alt" },
  ctrl = { "ctrl" },
  shift = { "shift" },
}

-- Window management functions
local function focusWindowInDirection(direction)
  local focused = hs.window.focusedWindow()
  if not focused then return end

  local targetWindow = nil

  if direction == "left" then
    targetWindow = focused:windowsToWest()[1]
  elseif direction == "right" then
    targetWindow = focused:windowsToEast()[1]
  elseif direction == "up" then
    targetWindow = focused:windowsToNorth()[1]
  elseif direction == "down" then
    targetWindow = focused:windowsToSouth()[1]
  end

  if targetWindow then
    targetWindow:focus()
    targetWindow:raise()
  else
    -- Fallback: cycle through all windows if no directional window found
    local windows = hs.window.orderedWindows()
    local currentIndex = nil

    for i, win in ipairs(windows) do
      if win:id() == focused:id() then
        currentIndex = i
        break
      end
    end

    if currentIndex then
      local nextIndex
      if direction == "right" or direction == "down" then
        nextIndex = currentIndex % #windows + 1
      else -- "left" or "up"
        nextIndex = currentIndex == 1 and #windows or currentIndex - 1
      end

      if windows[nextIndex] then
        windows[nextIndex]:focus()
        windows[nextIndex]:raise()
      end
    end
  end
end

local function moveWindowInDirection(direction)
  local focused = hs.window.focusedWindow()
  if not focused then return end

  local frame = focused:frame()
  local screen = focused:screen():frame()
  local moveDistance = 50

  if direction == "left" then
    frame.x = math.max(screen.x, frame.x - moveDistance)
  elseif direction == "right" then
    frame.x = math.min(screen.x + screen.w - frame.w, frame.x + moveDistance)
  elseif direction == "up" then
    frame.y = math.max(screen.y, frame.y - moveDistance)
  elseif direction == "down" then
    frame.y = math.min(screen.y + screen.h - frame.h, frame.y + moveDistance)
  end

  focused:setFrame(frame)
end

local function resizeWindow(direction, amount)
  local focused = hs.window.focusedWindow()
  if not focused then return end

  local frame = focused:frame()
  local screen = focused:screen():frame()
  amount = amount or 50

  if direction == "left" then
    frame.w = math.max(100, frame.w - amount)
  elseif direction == "right" then
    frame.w = math.min(screen.w, frame.w + amount)
  elseif direction == "up" then
    frame.h = math.max(100, frame.h - amount)
  elseif direction == "down" then
    frame.h = math.min(screen.h, frame.h + amount)
  end

  focused:setFrame(frame)
end

local function moveWindowToWorkspace(workspace)
  local focused = hs.window.focusedWindow()
  if not focused then return end

  -- Move window to specified space/workspace
  local spaces = hs.spaces.allSpaces()
  local screen = focused:screen()
  local screenSpaces = spaces[screen:getUUID()]

  if screenSpaces and screenSpaces[workspace] then
    Logger.d(
      string.format("Moving window (%s) to workspace %s (%s)", focused:title(), workspace, screenSpaces[workspace])
    )
    hs.spaces.moveWindowToSpace(focused, screenSpaces[workspace])
    -- Follow the window to the new space
    hs.spaces.gotoSpace(screenSpaces[workspace])
  end
end

local function gotoWorkspace(workspace)
  local screen = hs.screen.mainScreen()
  local spaces = hs.spaces.allSpaces()
  local screenSpaces = spaces[screen:getUUID()]

  if screenSpaces and screenSpaces[workspace] then
    hs.spaces.gotoSpace(screenSpaces[workspace])
  else
    -- If workspace doesn't exist, create it by going to the space
    -- This is a limitation of macOS spaces - they need to be created manually
    Logger.d("Workspace " .. workspace .. " doesn't exist")
  end
end

-- Additional Omarchy-inspired functions
local function cycleWindowForward()
  local windows = hs.window.orderedWindows()
  if #windows > 1 then
    local window = windows[2] -- Second window in the list
    window:focus()
    window:raise()
  end
end

local function cycleWindowBackward()
  local windows = hs.window.orderedWindows()
  if #windows > 1 then
    local window = windows[#windows] -- Last window in the list
    window:focus()
    window:raise()
  end
end

local function minimizeWindow()
  local focused = hs.window.focusedWindow()
  if focused then focused:minimize() end
end

local function unminimizeAllWindows()
  local windows = hs.window.allWindows()
  for _, win in ipairs(windows) do
    if win:isMinimized() then win:unminimize() end
  end
end

-- Hyprland-style window swapping
local function swapWindowInDirection(direction)
  local focused = hs.window.focusedWindow()
  if not focused then return end

  local targetWindow = nil

  if direction == "left" then
    targetWindow = focused:windowsToWest()[1]
  elseif direction == "right" then
    targetWindow = focused:windowsToEast()[1]
  elseif direction == "up" then
    targetWindow = focused:windowsToNorth()[1]
  elseif direction == "down" then
    targetWindow = focused:windowsToSouth()[1]
  end

  if targetWindow then
    local focusedFrame = focused:frame()
    local targetFrame = targetWindow:frame()

    focused:setFrame(targetFrame)
    targetWindow:setFrame(focusedFrame)

    -- Keep focus on the originally focused window
    focused:focus()
  end
end

-- Omarchy-style master-stack layout adjustments
local function increaseMasterRatio()
  local windows = hs.window.orderedWindows()
  local visibleWindows = {}

  for _, win in ipairs(windows) do
    if win:isVisible() and win:isStandard() then table.insert(visibleWindows, win) end
  end

  if #visibleWindows < 2 then return end

  local screen = hs.screen.mainScreen():frame()
  local masterRatio = 0.65 -- Increase master window size

  local masterFrame = {
    x = screen.x,
    y = screen.y,
    w = screen.w * masterRatio,
    h = screen.h,
  }

  visibleWindows[1]:setFrame(masterFrame)

  -- Adjust stack windows
  local stackWidth = screen.w * (1 - masterRatio)
  local stackHeight = screen.h / (#visibleWindows - 1)

  for i = 2, #visibleWindows do
    local stackFrame = {
      x = screen.x + screen.w * masterRatio,
      y = screen.y + (i - 2) * stackHeight,
      w = stackWidth,
      h = stackHeight,
    }
    visibleWindows[i]:setFrame(stackFrame)
  end
end

local function decreaseMasterRatio()
  local windows = hs.window.orderedWindows()
  local visibleWindows = {}

  for _, win in ipairs(windows) do
    if win:isVisible() and win:isStandard() then table.insert(visibleWindows, win) end
  end

  if #visibleWindows < 2 then return end

  local screen = hs.screen.mainScreen():frame()
  local masterRatio = 0.45 -- Decrease master window size

  local masterFrame = {
    x = screen.x,
    y = screen.y,
    w = screen.w * masterRatio,
    h = screen.h,
  }

  visibleWindows[1]:setFrame(masterFrame)

  -- Adjust stack windows
  local stackWidth = screen.w * (1 - masterRatio)
  local stackHeight = screen.h / (#visibleWindows - 1)

  for i = 2, #visibleWindows do
    local stackFrame = {
      x = screen.x + screen.w * masterRatio,
      y = screen.y + (i - 2) * stackHeight,
      w = stackWidth,
      h = stackHeight,
    }
    visibleWindows[i]:setFrame(stackFrame)
  end
end

local function toggleFullscreen()
  local focused = hs.window.focusedWindow()
  if focused then focused:toggleFullScreen() end
end

local function killWindow()
  local focused = hs.window.focusedWindow()
  if focused then focused:close() end
end

local function toggleFloating()
  local focused = hs.window.focusedWindow()
  if not focused then return end

  -- Check if window is in a "floating" state (centered and smaller)
  local frame = focused:frame()
  local screen = focused:screen():frame()

  local isFloating = frame.w < screen.w * 0.9 and frame.h < screen.h * 0.9

  if isFloating then
    -- Make it tiled (maximize)
    focused:maximize()
  else
    -- Make it floating (centered, 75% size)
    local newW = screen.w * 0.75
    local newH = screen.h * 0.75
    local newX = screen.x + (screen.w - newW) / 2
    local newY = screen.y + (screen.h - newH) / 2

    focused:setFrame({
      x = newX,
      y = newY,
      w = newW,
      h = newH,
    })
  end
end

-- Layout functions inspired by tiling window managers
local function layoutTiled()
  local windows = hs.window.orderedWindows()
  local visibleWindows = {}

  -- Filter for visible, standard windows
  for _, win in ipairs(windows) do
    if win:isVisible() and win:isStandard() then table.insert(visibleWindows, win) end
  end

  if #visibleWindows == 0 then return end

  local screen = hs.screen.mainScreen():frame()

  if #visibleWindows == 1 then
    -- Single window - maximize
    visibleWindows[1]:setFrame(screen)
  elseif #visibleWindows == 2 then
    -- Two windows - split vertically
    local leftFrame = {
      x = screen.x,
      y = screen.y,
      w = screen.w / 2,
      h = screen.h,
    }
    local rightFrame = {
      x = screen.x + screen.w / 2,
      y = screen.y,
      w = screen.w / 2,
      h = screen.h,
    }

    visibleWindows[1]:setFrame(leftFrame)
    visibleWindows[2]:setFrame(rightFrame)
  else
    -- Multiple windows - master/stack layout
    local masterFrame = {
      x = screen.x,
      y = screen.y,
      w = screen.w * 0.6,
      h = screen.h,
    }

    visibleWindows[1]:setFrame(masterFrame)

    local stackWidth = screen.w * 0.4
    local stackHeight = screen.h / (#visibleWindows - 1)

    for i = 2, #visibleWindows do
      local stackFrame = {
        x = screen.x + screen.w * 0.6,
        y = screen.y + (i - 2) * stackHeight,
        w = stackWidth,
        h = stackHeight,
      }
      visibleWindows[i]:setFrame(stackFrame)
    end
  end
end

local function swapWithMaster()
  local focused = hs.window.focusedWindow()
  if not focused then return end

  local windows = hs.window.orderedWindows()
  if #windows < 2 then return end

  -- Swap focused window with the first window
  local masterWindow = windows[1]
  local focusedFrame = focused:frame()
  local masterFrame = masterWindow:frame()

  focused:setFrame(masterFrame)
  masterWindow:setFrame(focusedFrame)

  -- Keep focus on the originally focused window
  focused:focus()
end

-- Terminal and application launchers
local function openTerminal()
  hs.application.launchOrFocus("Kitty")
end

local function openLauncher()
  -- Use Raycast as the launcher (similar to rofi/dmenu in Linux)
  hs.urlevent.openURL("raycast://")
end

-- Initialize Omarchy-style keybindings
function M.init(mod)
  mod = mod or default_mod
  Logger.d("Initializing Omarchy-inspired keybindings")

  local spaces = hs.spaces.allSpaces()
  local mainScreenUUID = hs.screen.mainScreen():getUUID()
  local mainScreeenSpaces = spaces[mainScreenUUID]
  local spaceCount = #mainScreeenSpaces or 1
  Logger.d("Space count: " .. spaceCount)
  -- Single monitor support
  if spaceCount < 9 then
    Logger.d("Iterating from " .. spaceCount + 0 .. " to " .. 9 - spaceCount .. " to create spaces")
    for _ = spaceCount + 1, 9 do
      hs.spaces.addSpaceToScreen() -- Create additional spaces if needed
    end
  end
  if spaceCount > 9 then
    Logger.d("More than 9 spaces detected, removing excess spaces")
    for i = 10, spaceCount do
      Logger.d(string.format("Removing space %s (%s)", i, mainScreeenSpaces[i]))
      hs.spaces.removeSpace(mainScreeenSpaces[i])
    end
  end

  -- Application launcher (Super + Space)
  hs.hotkey.bind(mod.super, "space", openLauncher)

  -- Terminal (Super + Return)
  hs.hotkey.bind(mod.super, "return", openTerminal)

  -- Window management
  hs.hotkey.bind(mod.super, "w", killWindow) -- Close window
  hs.hotkey.bind(mod.super, "f", toggleFullscreen) -- Toggle fullscreen
  hs.hotkey.bind(mod.superShift, "space", toggleFloating) -- Toggle floating

  -- Window focus (vim-style navigation)
  hs.hotkey.bind(mod.super, "h", function()
    -- Focus window to the left
    local focused = hs.window.focusedWindow()
    if focused then
      local leftWindow = focused:windowsToWest()[1]
      if leftWindow then leftWindow:focus() end
    end
  end)

  hs.hotkey.bind(mod.super, "l", function()
    -- Focus window to the right
    local focused = hs.window.focusedWindow()
    if focused then
      local rightWindow = focused:windowsToEast()[1]
      if rightWindow then rightWindow:focus() end
    end
  end)

  hs.hotkey.bind(mod.super, "j", function()
    -- Focus window below
    local focused = hs.window.focusedWindow()
    if focused then
      local belowWindow = focused:windowsToSouth()[1]
      if belowWindow then belowWindow:focus() end
    end
  end)

  hs.hotkey.bind(mod.super, "k", function()
    -- Focus window above
    local focused = hs.window.focusedWindow()
    if focused then
      local aboveWindow = focused:windowsToNorth()[1]
      if aboveWindow then aboveWindow:focus() end
    end
  end)

  -- Window movement (Super + Shift + hjkl)
  hs.hotkey.bind(mod.superShift, "h", function()
    local focused = hs.window.focusedWindow()
    if focused then focused:moveOneScreenWest() end
  end)

  hs.hotkey.bind(mod.superShift, "l", function()
    local focused = hs.window.focusedWindow()
    if focused then focused:moveOneScreenEast() end
  end)

  hs.hotkey.bind(mod.superShift, "j", function()
    local focused = hs.window.focusedWindow()
    if focused then focused:moveOneScreenSouth() end
  end)

  hs.hotkey.bind(mod.superShift, "k", function()
    local focused = hs.window.focusedWindow()
    if focused then focused:moveOneScreenNorth() end
  end)

  -- Window resizing (Super + Ctrl + hjkl)
  hs.hotkey.bind(mod.superCtrl, "h", function()
    local focused = hs.window.focusedWindow()
    if focused then
      local frame = focused:frame()
      frame.w = frame.w - 50
      focused:setFrame(frame)
    end
  end)

  hs.hotkey.bind(mod.superCtrl, "l", function()
    local focused = hs.window.focusedWindow()
    if focused then
      local frame = focused:frame()
      frame.w = frame.w + 50
      focused:setFrame(frame)
    end
  end)

  hs.hotkey.bind(mod.superCtrl, "j", function()
    local focused = hs.window.focusedWindow()
    if focused then
      local frame = focused:frame()
      frame.h = frame.h + 50
      focused:setFrame(frame)
    end
  end)

  hs.hotkey.bind(mod.superCtrl, "k", function()
    local focused = hs.window.focusedWindow()
    if focused then
      local frame = focused:frame()
      frame.h = frame.h - 50
      focused:setFrame(frame)
    end
  end)

  -- Layout management
  hs.hotkey.bind(mod.super, "t", layoutTiled) -- Tiled layout
  hs.hotkey.bind(mod.superShift, "return", swapWithMaster) -- Swap with master

  -- Master-stack ratio adjustments (typical in tiling WMs)
  hs.hotkey.bind(mod.superShift, "h", function()
    decreaseMasterRatio() -- Shrink master area
  end)

  hs.hotkey.bind(mod.superShift, "l", function()
    increaseMasterRatio() -- Expand master area
  end)

  -- Window swapping (Hyprland-style)
  hs.hotkey.bind(mod.superCtrl, "h", function()
    swapWindowInDirection("left")
  end)

  hs.hotkey.bind(mod.superCtrl, "l", function()
    swapWindowInDirection("right")
  end)

  hs.hotkey.bind(mod.superCtrl, "j", function()
    swapWindowInDirection("down")
  end)

  hs.hotkey.bind(mod.superCtrl, "k", function()
    swapWindowInDirection("up")
  end)

  -- Window cycling (Alt+Tab style)
  hs.hotkey.bind(mod.super, "tab", cycleWindowForward)
  hs.hotkey.bind(mod.superShift, "tab", cycleWindowBackward)

  -- Minimize/Restore windows
  hs.hotkey.bind(mod.super, "m", minimizeWindow)
  hs.hotkey.bind(mod.superShift, "m", unminimizeAllWindows)

  -- Workspace navigation (Super + 1-9)
  for i = 1, 9 do
    hs.hotkey.bind(mod.super, tostring(i), function()
      gotoWorkspace(i)
    end)

    -- Move window to workspace (Super + Shift + 1-9)
    Logger.d("Binding Super + Shift + " .. tostring(i) .. " to move window to workspace " .. i)
    hs.hotkey.bind(mod.superShift, tostring(i), function()
      moveWindowToWorkspace(i)
    end)
  end

  -- Quick window arrangements (like your existing grid system)
  hs.hotkey.bind(mod.superAlt, "h", function()
    window.push({ left = 0, top = 0, width = 0.5, height = 1 }) -- Left half
  end)

  hs.hotkey.bind(mod.superAlt, "l", function()
    window.push({ left = 0.5, top = 0, width = 0.5, height = 1 }) -- Right half
  end)

  hs.hotkey.bind(mod.superAlt, "k", function()
    window.push({ left = 0, top = 0, width = 1, height = 0.5 }) -- Top half
  end)

  hs.hotkey.bind(mod.superAlt, "j", function()
    window.push({ left = 0, top = 0.5, width = 1, height = 0.5 }) -- Bottom half
  end)

  -- Quarter screen layouts
  hs.hotkey.bind(mod.superAlt, "u", function()
    window.push({ left = 0, top = 0, width = 0.5, height = 0.5 }) -- Top-left quarter
  end)

  hs.hotkey.bind(mod.superAlt, "i", function()
    window.push({ left = 0.5, top = 0, width = 0.5, height = 0.5 }) -- Top-right quarter
  end)

  hs.hotkey.bind(mod.superAlt, "n", function()
    window.push({ left = 0, top = 0.5, width = 0.5, height = 0.5 }) -- Bottom-left quarter
  end)

  hs.hotkey.bind(mod.superAlt, "m", function()
    window.push({ left = 0.5, top = 0.5, width = 0.5, height = 0.5 }) -- Bottom-right quarter
  end)

  -- Center window
  hs.hotkey.bind(mod.superAlt, "c", function()
    window.push({ left = 0.125, top = 0.125, width = 0.75, height = 0.75 }) -- Centered 3/4 size
  end)

  -- Maximize
  hs.hotkey.bind(mod.superAlt, "f", function()
    window.push({ left = 0, top = 0, width = 1, height = 1 }) -- Full screen
  end)

  -- Monitor management
  hs.hotkey.bind(mod.superShift, ".", function()
    local focused = hs.window.focusedWindow()
    if focused then focused:moveToScreen(focused:screen():next()) end
  end)

  hs.hotkey.bind(mod.superShift, ",", function()
    local focused = hs.window.focusedWindow()
    if focused then focused:moveToScreen(focused:screen():previous()) end
  end)

  -- Quick app switching (like your existing hyper bindings)
  local quickApps = {
    b = "Google Chrome",
    e = "Finder",
    v = "Neovide",
    s = "Slack",
    d = "Dash",
    p = "TablePlus",
    o = "Obsidian",
  }

  for key, app in pairs(quickApps) do
    hs.hotkey.bind(mod.super, key, function()
      hs.application.launchOrFocus(app)
    end)
  end

  -- System controls
  hs.hotkey.bind(mod.superShift, "r", function()
    hs.reload() -- Reload Hammerspoon config
  end)

  hs.hotkey.bind(mod.superShift, "q", function()
    -- Lock screen (equivalent to Super+L in many Linux WMs)
    hs.caffeinate.lockScreen()
  end)

  Logger.d("Omarchy-inspired keybindings initialized")
end

-- Function to disable Omarchy bindings
function M.disable()
  Logger.d("Disabling Omarchy-inspired keybindings")
  -- Note: In a real implementation, you'd want to store hotkey references
  -- and disable them here. For now, this is a placeholder.
end

return M

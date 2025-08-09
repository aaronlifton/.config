-- https://www.hammerspoon.org/docs/hs.window.html
local window = require("hs.window")
-- https://www.hammerspoon.org/docs/hs.grid.html
local grid = require("hs.grid")
local logger = require("functions.logger")

window.animationDuration = 0
grid.MARGINX = 0
grid.MARGINY = 0
grid.GRIDWIDTH = 2
grid.GRIDHEIGHT = 2

---@class Window
---@field restorable_frames table<string, hs.geometry> -- Store frames of windows that can be restored
---@field window_iteration_state table<string, number> -- Track current window index per com.apple.FontBook
---@field push fun(params: table<string, number|hs.window>) : boolean
---@field thunk_push fun(params: table<string, number|hs.window>) : function
---@field grid fun(cell: hs.geometry) : boolean
---@field thunk_grid fun(cell: hs.geometry) : function
---@field maximize_window fun() : boolean
---@field maximize_with_delay fun(delay: number) : nil
---@field move_and_resize fun(layout: table<string, number>) : function
---@field move_one_screen_south fun() : nil
---@field bring_app_to_front fun(bundleID: string) : nil
---@field check_frontmost_window fun(target_bundle_id: string) : nil
---@field activateAndMoveToLayout fun(appName: string, layout: table<string, number>, beforeFn: function|nil, afterFn: function|nil) : nil
---@field iterateMonitorWindows fun(appNameOrBundleID: string) : function
---@field iterateWindows fun(appNameOrBundleID: string) : function
---@field activateApp fun(appNameOrBundleID: string, shouldToggle?: boolean) : nil
---@field alternateMonitorApps fun(appName: string) : function
local M = {}

M.restorable_frames = {}
M.window_iteration_state = {} -- Track current window index per app

-- Move a window to the given coordinates
-- top/left/width/height as a percent of the screen
-- window (optional) the window to move, defaults to the focused window
function M.push(params)
  local window = params["window"] or hs.window.focusedWindow()
  if not window then
    logger.d("No focused window to move")
    return false
  end

  local windowFrame = window:frame()
  local screen = window:screen()
  local screenFrame = screen:frame()

  local moved = false
  local function cas(old, new)
    if old ~= new then moved = true end
    return new
  end

  windowFrame.x = cas(windowFrame.x, screenFrame.x + (screenFrame.w * (params["left"] or 0)))
  windowFrame.y = cas(windowFrame.y, screenFrame.y + (screenFrame.h * (params["top"] or 0)))
  windowFrame.w = cas(windowFrame.w, screenFrame.w * (params["width"] or 1))
  windowFrame.h = cas(windowFrame.h, screenFrame.h * (params["height"] or 1))

  window:setFrame(windowFrame, { duration = 0 })
  return moved
end

function M.thunk_push(params)
  local function thunk()
    M.push(params)
  end
  return thunk
end

function M.grid(cell)
  hs.grid.set(hs.window.focusedWindow(), cell)
  return true
end

function M.thunk_grid(cell)
  local function thunk()
    M.grid(cell)
  end
  return thunk
end

M.maximize_window = grid.maximizeWindow

function M.maximize_with_delay(delay)
  hs.timer.doAfter(delay or 0.5, M.maximize_window)
end

---@param layout fun(x: table): table<string, number>
M.move_and_resize = function(layout)
  return function()
    if type(layout) == "function" then
      layout = layout() -- Call the function if it's a thunk
    end
    M.push(layout)
  end
end

M.move_one_screen_south = function()
  local win = hs.window.focusedWindow()
  if win then
    local currentScreen = win:screen()
    local currentScreenName = currentScreen:name()

    -- Check if already on the Built-in Display (southernmost screen)
    if currentScreenName == "Built-in Display" then
      -- Do nothing if already on the Built-in Display
      return
    end

    win:moveOneScreenSouth(false, true, 0) -- false for wrapping, true for resize, 0 duration
  end
end

M.bring_app_to_front = function(bundleID)
  local app = hs.application.get(bundleID)
  if app then
    app:activate() -- Brings the app to the front
  else
    hs.application.launchOrFocusByBundleID(bundleID) -- Launch or focus on the app
  end
end

-- Function to check the frontmost window's application
M.check_frontmost_window = function(target_bundle_id)
  local focused_window = hs.window.frontmostWindow()
  if focused_window then
    local app = focused_window:application()
    local bundleID = app:bundleID()

    -- Check if the frontmost app is Raycast or ChatGPT, and if it is an overlay
    if bundleID == target_bundle_id and not focused_window:isStandard() then
      hs.alert.show("Raycast Overlay Window Detected")
      M.bring_app_to_front(target_bundle_id)
    end
  end
end

M.unmimizeApp = function(app)
  if app then
    local windows = app:allWindows()
    for _, window in ipairs(windows) do
      if window:isMinimized() then window:unminimize() end
    end
  end
end

M.unmimizeAppByName = function(appName)
  local app = hs.application.get(appName)
  if app then
    local windows = app:allWindows()
    for _, window in ipairs(windows) do
      if window:isMinimized() then window:unminimize() end
    end
  end
end

--- Activate an application and move its window to a specific layout
--- e.g. `activate_and_move_to_layout("Calendar", Layout.first_two_thirds)`
---@param appName string
---@param layout WindowLayout
---@param beforeFn fun(win: Window)|nil
---@param afterFn fun(win: Window)|nil
function M.activateAndMoveToLayout(appName, layout, beforeFn, afterFn)
  local appInstance = hs.application.get(appName)
  M.unmimizeApp(appInstance)
  if appInstance then
    appInstance:activate()
  else
    hs.application.launchOrFocusByBundleID(appName)
  end
  if beforeFn then beforeFn(M) end
  local move = M.move_and_resize(layout)
  move()
  if afterFn then afterFn(M) end
end

function M.appExistsOnBuiltInDisplay(appName)
  local app = hs.application.get(appName)
  if not app then
    return false -- App is not running
  end
  -- Get all app windows
  local appWindows = app:allWindows()
  if not appWindows or #appWindows == 0 then
    return false -- No windows for the app
  end
  -- Check if any window is on the Built-in Display
  for _, window in ipairs(appWindows) do
    if window:screen():name() == Screens.main then
      return true -- Found a window on the Built-in Display
    end
  end
  return false -- No windows found on the Built-in Display
end

function M.iterateMonitorWindows(appNameOrBundleID)
  if Config.screenCount < 2 then return M.iterateWindows(appNameOrBundleID) end

  return function()
    local app = hs.application.get(appNameOrBundleID)
    if not app then
      -- If app is not running, launch it
      logger.d("App not running, launching: " .. appNameOrBundleID)
      hs.application.launchOrFocus(appNameOrBundleID)
      return
    end

    -- Get all app windows
    local appWindows = app:allWindows()
    if not appWindows or #appWindows == 0 then
      -- No app windows, launch app (should ideally not happen if app exists)
      logger.e("No windows found for app: " .. appNameOrBundleID)
      hs.application.launchOrFocus(appNameOrBundleID)
      return
    end

    -- Find windows on main and secondary screens
    local mainWindow = nil
    local secondaryWindow = nil

    logger.d(hs.inspect(appWindows))
    for _, window in ipairs(appWindows) do
      local screenName = window:screen():name()
      if screenName == Screens.main and not mainWindow then
        mainWindow = window
      elseif screenName == Screens.secondary and not secondaryWindow then
        secondaryWindow = window
      end
    end
    logger.d(
      string.format(
        "mainWindow: %s, secondaryWindow: %s",
        mainWindow and mainWindow:title() or "nil",
        secondaryWindow and secondaryWindow:title() or "nil"
      )
    )

    -- Get current focused window to determine next window to focus
    local currentWindow = hs.window.focusedWindow()
    local currentApp = currentWindow and currentWindow:application()
    logger.d("currentApp: " .. (currentApp and currentApp:name() or "nil"))
    local isCurrentWindowOfTargetApp = currentApp and currentApp:name():lower() == appNameOrBundleID:lower()
    local currentWindowScreenName = currentWindow and currentWindow:screen():name() or nil

    -- Logic to focus based on current state
    if isCurrentWindowOfTargetApp then
      logger.d(string.format("Target app (%s) window is currently focused.", appNameOrBundleID))
      -- A window of the target app is currently focused
      if currentWindowScreenName == Screens.main and secondaryWindow then
        -- Currently on main screen, switch to secondary if window exists
        logger.d("Target app window focused on main, switching to secondary.")
        secondaryWindow:raise()
        secondaryWindow:focus()
      elseif currentWindowScreenName == Screens.secondary and mainWindow then
        -- Currently on secondary screen, switch to main if window exists
        logger.d("Target app window focused on secondary, switching to main.")
        mainWindow:raise()
        mainWindow:focus()
      else
        -- Target app window is focused, but no window on the other screen, or current screen is not main/secondary.
        -- Do nothing, as there's no other specific instance to switch to.
        logger.d("Target app window focused, but no switch target found or necessary.")
      end
    else
      -- No window of the target app is currently focused
      if mainWindow then
        logger.d("Target app not focused, focusing main window.")
        mainWindow:raise()
        mainWindow:focus()
      elseif secondaryWindow then
        secondaryWindow:raise()
        secondaryWindow:focus()
        logger.d("Target app not focused, focusing secondary window.")
      else
        -- Fallback: if no specific main/secondary window found, focus any available window of the app.
        -- This case should ideally be rare if appWindows is not empty.
        if appWindows[1] then
          logger.d("Target app not focused, focusing first available window.")
          appWindows[1]:raise()
          appWindows[1]:focus()
        else
          logger.d("No windows found for app, nothing to focus.")
        end
      end
    end
  end
end

-- Iterate through all windows of an app in order, regardless of screen
function M.iterateWindows(appNameOrBundleID)
  return function()
    local app = hs.application.get(appNameOrBundleID)
    if not app then
      -- If app is not running, launch it
      hs.application.launchOrFocus(appNameOrBundleID)
      M.window_iteration_state[appNameOrBundleID] = nil -- Reset state when launching
      return
    end

    -- Get all app windows
    local appWindows = app:allWindows()
    if not appWindows or #appWindows == 0 then
      -- No app windows, launch app
      hs.application.launchOrFocus(appNameOrBundleID)
      M.window_iteration_state[appNameOrBundleID] = nil -- Reset state
      return
    end

    -- Initialize or get current window index for this app
    local currentIndex = M.window_iteration_state[appNameOrBundleID] or 1

    -- Check if the currently focused window is from this app and update index accordingly
    local currentWindow = hs.window.focusedWindow()
    local currentApp = currentWindow and currentWindow:application()
    logger.d("currentWindow: " .. (currentWindow and currentWindow:title() or "nil"))
    logger.d("currentApp: " .. (currentApp and currentApp:name() or "nil"))
    local isCurrentWindowOfTargetApp = currentApp and currentApp:name():lower() == appNameOrBundleID:lower()
    logger.d("isCurrentWindowOfTargetApp: " .. tostring(isCurrentWindowOfTargetApp))

    if isCurrentWindowOfTargetApp then
      if #appWindows == 1 then
        currentIndex = 1
      else
        -- Find the index of the currently focused window
        for i, win in ipairs(appWindows) do
          if win:id() == currentWindow:id() then
            currentIndex = i
            break
          end
        end
        -- Move to next window
        currentIndex = currentIndex + 1
        if currentIndex > #appWindows then
          currentIndex = 1 -- Wrap around to first window
        end
      end
    else
      -- If no window of target app is focused, start with first window
      currentIndex = 1
    end

    -- Store the new index
    M.window_iteration_state[appNameOrBundleID] = currentIndex

    -- Focus the window at the current index
    local targetWindow = appWindows[currentIndex]
    if targetWindow then
      targetWindow:raise()
      targetWindow:focus()
      logger.d(string.format("Focused window %d of %d for app %s", currentIndex, #appWindows, appNameOrBundleID))
    else
      logger.e(string.format("No window found at index %d for app %s", currentIndex, appNameOrBundleID))
    end
  end
end

function M.activateApp(appNameOrBundleID, shouldToggle)
  if string.match(appNameOrBundleID, "^[%w%.]+%.[%w%.]+") or not string.match(appNameOrBundleID, "%.app$") then
    -- Treat as bundle identifier
    local appInstance = hs.application.get(appNameOrBundleID)
    local appName = appInstance:name()
    local bundleID = appInstance:bundleID()
    if appInstance then
      if shouldToggle then
        if appInstance:isFrontmost() then
          appInstance:hide()
        else
          M.unmimizeApp(appInstance)

          -- local windows = app:allWindows()
          -- for _, window in ipairs(windows) do
          --   if window:isMinimized() then window:unminimize() end
          -- end
          appInstance:activate()
        end
      else
        appInstance:activate()
      end
    else
      hs.application.launchOrFocusByBundleID(bundleID)
    end
  else
    -- Treat as application name
    hs.application.launchOrFocus(appName)
  end
end

function M.alternateMonitorApps(appName)
  return function()
    -- hs.execute('open -na "Google Chrome" --args --profile-directory="Profile 2"', true)
    local app = hs.application.get(appName)
    if not app then
      -- If app is not running, launch it
      return
    end

    -- Get all app windows
    local appWindows = app:allWindows()
    if not appWindows or #appWindows == 0 then
      -- No app windows, launch app
      hs.application.launchOrFocus(appName)
      return
    end

    -- Find app window on Built-in Display
    local builtInWindow = nil
    for _, win in ipairs(appWindows) do
      if win:screen():name() == Screens.secondary then
        builtInWindow = win
        break
      end
    end

    if builtInWindow then
      -- Focus the app window on Built-in Display
      builtInWindow:focus()
      builtInWindow:raise()
    else
      -- No app window on Built-in Display, focus any app window
      appWindows[1]:focus()
      appWindows[1]:raise()
    end
  end
end

function M.hasMultipleExternalDisplays()
  Config.hasBuiltInScreen = false
  local allScreens = hs.screen.allScreens()
  if not allScreens or #allScreens < 2 then
    return false -- Not enough screens to have multiple external displays
  end

  for _, screen in ipairs(allScreens) do
    if string.find(screen:name(), "^Built%-in") then
      Config.hasBuiltInScreen = true
      break
    end
  end
end

return M

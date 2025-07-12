local window = require("hs.window")
local grid = require("hs.grid")

window.animationDuration = 0
grid.MARGINX = 0
grid.MARGINY = 0
grid.GRIDWIDTH = 2
grid.GRIDHEIGHT = 2

---@class Window
local M = {}

M.restorable_frames = {}

-- Move a window to the given coordinates
-- top/left/width/height as a percent of the screen
-- window (optional) the window to move, defaults to the focused window
function M.push(params)
  local window = params["window"] or hs.window.focusedWindow()
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

--- Activate an application and move its window to a specific layout
--- e.g. `activate_and_move_to_layout("Calendar", Layout.first_two_thirds)`
---@param appName string
---@param layout WindowLayout
---@param beforeFn fun(win: Window)|nil
---@param afterFn fun(win: Window)|nil
function M.activate_and_move_to_layout(appName, layout, beforeFn, afterFn)
  local appInstance = hs.application.get(appName)
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

return M

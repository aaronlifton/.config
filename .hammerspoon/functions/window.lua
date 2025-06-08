local window = require("hs.window")
local grid = require("hs.grid")

window.animationDuration = 0
grid.MARGINX = 0
grid.MARGINY = 0
grid.GRIDWIDTH = 2
grid.GRIDHEIGHT = 2

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
  function cas(old, new)
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
  function thunk()
    M.push(params)
  end
  return thunk
end

function M.grid(cell)
  hs.grid.set(hs.window.focusedWindow(), cell)
  return true
end

function M.thunk_grid(cell)
  function thunk()
    M.grid(cell)
  end
  return thunk
end

M.maximize_window = grid.maximizeWindow

function M.maximize_with_delay(delay)
  hs.timer.doAfter(delay or 0.5, M.maximize_window)
end

return M

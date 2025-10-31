local M = {}

function M.moveWindowInDirection(direction)
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

function M.swapWindowInDirection(direction)
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

    focused:focus()
  end
end

function M.swapWithMaster()
  local focused = hs.window.focusedWindow()
  if not focused then return end

  local windows = hs.window.orderedWindows()
  if #windows < 2 then return end

  local masterWindow = windows[1]
  local focusedFrame = focused:frame()
  local masterFrame = masterWindow:frame()

  focused:setFrame(masterFrame)
  masterWindow:setFrame(focusedFrame)

  focused:focus()
end

function M.toggleFullscreen()
  local focused = hs.window.focusedWindow()
  if focused then focused:toggleFullScreen() end
end

function M.killWindow()
  local focused = hs.window.focusedWindow()
  if focused then focused:close() end
end

function M.toggleFloating()
  local focused = hs.window.focusedWindow()
  if not focused then return end

  local frame = focused:frame()
  local screen = focused:screen():frame()

  local isFloating = frame.w < screen.w * 0.9 and frame.h < screen.h * 0.9

  if isFloating then
    focused:maximize()
  else
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

return M
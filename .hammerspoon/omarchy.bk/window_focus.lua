local M = {}

function M.focusWindowInDirection(direction)
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
      else
        nextIndex = currentIndex == 1 and #windows or currentIndex - 1
      end

      if windows[nextIndex] then
        windows[nextIndex]:focus()
        windows[nextIndex]:raise()
      end
    end
  end
end

function M.cycleWindowForward()
  local windows = hs.window.orderedWindows()
  if #windows > 1 then
    local window = windows[2]
    window:focus()
    window:raise()
  end
end

function M.cycleWindowBackward()
  local windows = hs.window.orderedWindows()
  if #windows > 1 then
    local window = windows[#windows]
    window:focus()
    window:raise()
  end
end

function M.minimizeWindow()
  local focused = hs.window.focusedWindow()
  if focused then focused:minimize() end
end

function M.unminimizeAllWindows()
  local windows = hs.window.allWindows()
  for _, win in ipairs(windows) do
    if win:isMinimized() then win:unminimize() end
  end
end

return M
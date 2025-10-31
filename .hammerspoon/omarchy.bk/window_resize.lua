local M = {}

function M.resizeWindow(direction, amount)
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

function M.increaseMasterRatio()
  local windows = hs.window.orderedWindows()
  local visibleWindows = {}

  for _, win in ipairs(windows) do
    if win:isVisible() and win:isStandard() then table.insert(visibleWindows, win) end
  end

  if #visibleWindows < 2 then return end

  local screen = hs.screen.mainScreen():frame()
  local masterRatio = 0.65

  local masterFrame = {
    x = screen.x,
    y = screen.y,
    w = screen.w * masterRatio,
    h = screen.h,
  }

  visibleWindows[1]:setFrame(masterFrame)

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

function M.decreaseMasterRatio()
  local windows = hs.window.orderedWindows()
  local visibleWindows = {}

  for _, win in ipairs(windows) do
    if win:isVisible() and win:isStandard() then table.insert(visibleWindows, win) end
  end

  if #visibleWindows < 2 then return end

  local screen = hs.screen.mainScreen():frame()
  local masterRatio = 0.45

  local masterFrame = {
    x = screen.x,
    y = screen.y,
    w = screen.w * masterRatio,
    h = screen.h,
  }

  visibleWindows[1]:setFrame(masterFrame)

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

return M
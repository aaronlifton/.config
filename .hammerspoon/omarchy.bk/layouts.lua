local M = {
  maxTiledWindows = 6,
  currentLayout = nil,
}

function M.layoutTiled()
  local windows = hs.window.orderedWindows()
  local visibleWindows = {}

  for _, win in ipairs(windows) do
    if win:isVisible() and win:isStandard() then table.insert(visibleWindows, win) end
  end

  if #visibleWindows == 0 then return end

  -- Find the current master window (the one in the master position)
  local function findCurrentMaster()
    local screen = hs.screen.mainScreen():frame()
    local masterArea = {
      x = screen.x,
      y = screen.y,
      w = screen.w * 0.6,
      h = screen.h,
    }

    -- Look for a window that's roughly in the master position
    for _, win in ipairs(visibleWindows) do
      local frame = win:frame()
      local centerX = frame.x + frame.w / 2
      local centerY = frame.y + frame.h / 2
      local masterCenterX = masterArea.x + masterArea.w / 2
      local masterCenterY = masterArea.y + masterArea.h / 2

      -- Check if window center is in the master area (with some tolerance)
      local tolerance = 100
      if
        math.abs(centerX - masterCenterX) < tolerance
        and math.abs(centerY - masterCenterY) < tolerance
        and frame.w > screen.w * 0.4
      then -- Must be wider than stack windows
        return win
      end
    end

    return nil
  end

  local currentMaster = findCurrentMaster()

  -- If we found a current master, move it to the front of the list
  if currentMaster then
    for i, win in ipairs(visibleWindows) do
      if win:id() == currentMaster:id() then
        table.remove(visibleWindows, i)
        break
      end
    end
    table.insert(visibleWindows, 1, currentMaster)
  end

  local screen = hs.screen.mainScreen():frame()

  if #visibleWindows == 1 then
    visibleWindows[1]:setFrame(screen)
  elseif #visibleWindows == 2 then
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

  M.currentLayout = "tiled"
end

function M.layoutTiledWithHidden()
  local windows = hs.window.orderedWindows()
  local visibleWindows = {}

  for _, win in ipairs(windows) do
    if win:isVisible() and win:isStandard() then table.insert(visibleWindows, win) end
  end

  if #visibleWindows == 0 then return end

  local tiledWindows = {}
  local hiddenWindows = {}

  for i, win in ipairs(visibleWindows) do
    if i <= M.maxTiledWindows then
      table.insert(tiledWindows, win)
    else
      table.insert(hiddenWindows, win)
    end
  end

  for _, win in ipairs(hiddenWindows) do
    win:application():hide()
  end

  if #tiledWindows == 0 then return end

  local screen = hs.screen.mainScreen():frame()

  if #tiledWindows == 1 then
    tiledWindows[1]:setFrame(screen)
  elseif #tiledWindows == 2 then
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

    tiledWindows[1]:setFrame(leftFrame)
    tiledWindows[2]:setFrame(rightFrame)
  else
    local masterFrame = {
      x = screen.x,
      y = screen.y,
      w = screen.w * 0.6,
      h = screen.h,
    }

    tiledWindows[1]:setFrame(masterFrame)

    local stackWidth = screen.w * 0.4
    local stackHeight = screen.h / (#tiledWindows - 1)

    for i = 2, #tiledWindows do
      local stackFrame = {
        x = screen.x + screen.w * 0.6,
        y = screen.y + (i - 2) * stackHeight,
        w = stackWidth,
        h = stackHeight,
      }
      tiledWindows[i]:setFrame(stackFrame)
    end
  end
end

function M.layoutTiledMultiSpace()
  local windows = hs.window.orderedWindows()
  local visibleWindows = {}

  for _, win in ipairs(windows) do
    if win:isVisible() and win:isStandard() then table.insert(visibleWindows, win) end
  end

  if #visibleWindows == 0 then return end

  local maxWindowsPerSpace = M.maxTiledWindows
  local spacesNeeded = math.ceil(#visibleWindows / maxWindowsPerSpace)

  local spaces = hs.spaces.allSpaces()
  local mainScreenUUID = hs.screen.mainScreen():getUUID()
  local screenSpaces = spaces[mainScreenUUID]

  if #screenSpaces < spacesNeeded then
    for _ = #screenSpaces + 1, spacesNeeded do
      hs.spaces.addSpaceToScreen()
    end
    spaces = hs.spaces.allSpaces()
    screenSpaces = spaces[mainScreenUUID]
  end
  Logger.d(("screenSpaces: %s, spacesNeeded: %s"):format(screenSpaces, spacesNeeded))

  for spaceIndex = 1, spacesNeeded do
    local startWindowIndex = (spaceIndex - 1) * maxWindowsPerSpace + 1
    local endWindowIndex = math.min(spaceIndex * maxWindowsPerSpace, #visibleWindows)
    local spaceWindows = {}

    Logger.d("visibleWindows: %s" .. hs.inspect(visibleWindows))
    for i = startWindowIndex, endWindowIndex do
      table.insert(spaceWindows, visibleWindows[i])
    end

    local currentSpace = screenSpaces[spaceIndex]
    if currentSpace then
      Logger.d(("Found currentSpace (%s/%s)"):format(spaceIndex, #screenSpaces))
      for idx, window in ipairs(spaceWindows) do
        Logger.d(("Moving window %s to space %s"):format(idx, spaceIndex))
        -- hs.spaces.moveWindowToSpace(window, currentSpace)
        window:focus()
        Drag:focusedWindowToSpace(currentSpace)
      end

      hs.spaces.gotoSpace(currentSpace)

      local screen = hs.screen.mainScreen():frame()

      if #spaceWindows == 1 then
        spaceWindows[1]:setFrame(screen)
      elseif #spaceWindows == 2 then
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

        spaceWindows[1]:setFrame(leftFrame)
        spaceWindows[2]:setFrame(rightFrame)
      else
        local masterFrame = {
          x = screen.x,
          y = screen.y,
          w = screen.w * 0.6,
          h = screen.h,
        }

        spaceWindows[1]:setFrame(masterFrame)

        local stackWidth = screen.w * 0.4
        local stackHeight = screen.h / (#spaceWindows - 1)

        for i = 2, #spaceWindows do
          local stackFrame = {
            x = screen.x + screen.w * 0.6,
            y = screen.y + (i - 2) * stackHeight,
            w = stackWidth,
            h = stackHeight,
          }
          spaceWindows[i]:setFrame(stackFrame)
        end
      end
    end
  end
end

function M.rotateLayout()
  local windows = hs.window.orderedWindows()
  local visibleWindows = {}

  for _, win in ipairs(windows) do
    if win:isVisible() and win:isStandard() then table.insert(visibleWindows, win) end
  end

  if #visibleWindows < 2 then return end

  local screen = hs.screen.mainScreen():frame()

  -- Determine current layout orientation by checking the first two windows
  local win1Frame = visibleWindows[1]:frame()
  local win2Frame = visibleWindows[2]:frame()

  local isHorizontalSplit = false
  local isVerticalSplit = false
  local isMasterStack = false

  -- Check if it's a horizontal split (windows side by side)
  if
    math.abs(win1Frame.y - win2Frame.y) < 50
    and math.abs(win1Frame.h - win2Frame.h) < 50
    and math.abs(win1Frame.w - screen.w / 2) < 100
  then
    isHorizontalSplit = true
  -- Check if it's a vertical split (windows stacked vertically)
  elseif
    math.abs(win1Frame.x - win2Frame.x) < 50
    and math.abs(win1Frame.w - win2Frame.w) < 50
    and math.abs(win1Frame.h - screen.h / 2) < 100
  then
    isVerticalSplit = true
  -- Check if it's master-stack layout
  elseif win1Frame.w > screen.w * 0.5 and win2Frame.w < screen.w * 0.5 then
    isMasterStack = true
  end

  if #visibleWindows == 2 then
    if isHorizontalSplit then
      -- Rotate to vertical split
      Logger.d("Rotating from horizontal to vertical split")
      local topFrame = {
        x = screen.x,
        y = screen.y,
        w = screen.w,
        h = screen.h / 2,
      }
      local bottomFrame = {
        x = screen.x,
        y = screen.y + screen.h / 2,
        w = screen.w,
        h = screen.h / 2,
      }
      visibleWindows[1]:setFrame(topFrame)
      visibleWindows[2]:setFrame(bottomFrame)
    elseif isVerticalSplit then
      -- Rotate to master-stack layout
      Logger.d("Rotating from vertical to master-stack")
      local masterFrame = {
        x = screen.x,
        y = screen.y,
        w = screen.w * 0.6,
        h = screen.h,
      }
      local stackFrame = {
        x = screen.x + screen.w * 0.6,
        y = screen.y,
        w = screen.w * 0.4,
        h = screen.h,
      }
      visibleWindows[1]:setFrame(masterFrame)
      visibleWindows[2]:setFrame(stackFrame)
    else
      -- Default to horizontal split
      Logger.d("Rotating to horizontal split")
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
    end
  else
    -- For more than 2 windows, rotate between different master-stack orientations
    if isMasterStack then
      -- Rotate to horizontal master-stack (master on top)
      Logger.d("Rotating to horizontal master-stack")
      local masterFrame = {
        x = screen.x,
        y = screen.y,
        w = screen.w,
        h = screen.h * 0.6,
      }
      visibleWindows[1]:setFrame(masterFrame)

      local stackWidth = screen.w / (#visibleWindows - 1)
      for i = 2, #visibleWindows do
        local stackFrame = {
          x = screen.x + (i - 2) * stackWidth,
          y = screen.y + screen.h * 0.6,
          w = stackWidth,
          h = screen.h * 0.4,
        }
        visibleWindows[i]:setFrame(stackFrame)
      end
    else
      -- Default to vertical master-stack (master on left)
      Logger.d("Rotating to vertical master-stack")
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
end

return M

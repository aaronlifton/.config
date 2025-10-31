local M = {}

function M.moveWindowToWorkspace(workspace)
  local focused = hs.window.focusedWindow()
  if not focused then
    Logger.d("No focused window to move")
    return
  end

  -- Get fresh space data each time
  local spaces = hs.spaces.allSpaces()
  local screen = focused:screen()
  local screenSpaces = spaces[screen:getUUID()]

  Logger.d(string.format("screenSpaces: %s", hs.inspect(screenSpaces)))

  Logger.d(string.format("Available spaces: %s", hs.inspect(screenSpaces)))
  Logger.d(string.format("Trying to move to workspace index: %s", workspace))

  if screenSpaces and screenSpaces[workspace] then
    local targetSpaceId = screenSpaces[workspace]
    Logger.d(
      string.format("Moving window (%s) to workspace %s (space ID: %s)", focused:title(), workspace, targetSpaceId)
    )

    -- Try to move the window
    -- local success = hs.spaces.moveWindowToSpace(focused, targetSpaceId)
    local success = Drag:focusedWindowToSpace(targetSpaceId)

    if success then
      Logger.d("Window move succeeded")
      hs.spaces.gotoSpace(targetSpaceId)
    else
      Logger.d("Window move failed")
    end
  else
    Logger.d(string.format("Workspace %s not found in spaces: %s", workspace, hs.inspect(screenSpaces)))
  end
end

function M.gotoWorkspace(workspace)
  local screen = hs.screen.mainScreen()
  local spaces = hs.spaces.allSpaces()
  local screenSpaces = spaces[screen:getUUID()]

  Logger.d(string.format("Going to workspace %s. Available spaces: %s", workspace, hs.inspect(screenSpaces)))

  if screenSpaces and screenSpaces[workspace] then
    local targetSpaceId = screenSpaces[workspace]
    Logger.d(string.format("Going to workspace %s (space ID: %s)", workspace, targetSpaceId))
    hs.spaces.gotoSpace(targetSpaceId)
  else
    Logger.d(string.format("Workspace %s doesn't exist. Available: %s", workspace, hs.inspect(screenSpaces)))
  end
end

function M.setup()
  local spaces = hs.spaces.allSpaces()
  local mainScreenUUID = hs.screen.mainScreen():getUUID()
  local mainScreeenSpaces = spaces[mainScreenUUID]
  local spaceCount = #mainScreeenSpaces or 1
  Logger.d("Space count: " .. spaceCount)

  if spaceCount < 9 then
    Logger.d("Iterating from " .. spaceCount + 0 .. " to " .. 9 - spaceCount .. " to create spaces")
    for _ = spaceCount + 1, 9 do
      hs.spaces.addSpaceToScreen()
    end
  end

  if spaceCount > 9 then
    Logger.d("More than 9 spaces detected, removing excess spaces")
    for i = 10, spaceCount do
      Logger.d(string.format("Removing space %s (%s)", i, mainScreeenSpaces[i]))
      hs.spaces.removeSpace(mainScreeenSpaces[i])
    end
  end
end

function M.teardown()
  Logger.d("Tearing down workspace module")

  local spaces = hs.spaces.allSpaces()
  local mainScreenUUID = hs.screen.mainScreen():getUUID()
  local mainScreeenSpaces = spaces[mainScreenUUID]
  local spaceCount = #mainScreeenSpaces or 1

  for i = 2, spaceCount do
    if mainScreeenSpaces[i] then
      Logger.d(string.format("Removing space %s (%s)", i, mainScreeenSpaces[i]))
      hs.spaces.removeSpace(mainScreeenSpaces[i])
    end
  end
end

return M

local M = {}

-- BetterDisplay CLI Lua Script for Hammerspoon (Coding Workflow)
local betterDisplayCLI = "/Users/alifton/.local/bin/betterdisplaycli" -- Adjust path if needed

-- Define virtual screen M.presets for coding
M.presets = {
  {
    name = "Kitty+Chrome",
    width = 1920,
    height = 1080,
    position = "right", -- Position relative to main display
    apps = {
      { name = "Kitty", position = "main" }, -- VS Code on main screen
      { name = "Google Chrome", position = "virtual" }, -- Docs on virtual
    },
  },
  {
    name = "GoLand+Kitty",
    width = 1600,
    height = 900,
    position = "left",
    apps = {
      { name = "GoLand", position = "main" },
      { name = "Kitty", position = "virtual" }, -- For logs
    },
  },
}

-- Create a virtual screen using BetterDisplay CLI
function M.createVirtualScreen(preset)
  local positionArg = preset.position == "right" and "--right" or "--left"
  hs.execute(
    string.format(
      "%s create --width %d --height %d --name '%s' %s --nogui",
      betterDisplayCLI,
      preset.width,
      preset.height,
      preset.name,
      positionArg
    )
  )

  -- Optional: Move apps to their designated screens
  for _, app in ipairs(preset.apps) do
    if app.position == "virtual" then
      hs.timer.doAfter(1, function()
        hs.application.launchOrFocus(app.name)
        hs.eventtap.keyStroke({ "cmd", "ctrl" }, "f") -- BetterDisplay move-to-screen shortcut
      end)
    end
  end
end

-- Delete all virtual screens (cleanup)
function M.deleteAllVirtualScreens()
  hs.execute(betterDisplayCLI .. " delete-all --nogui")
end

M.modes = {
  coding = {
    name = M.presets[1].name,
    mod = { "cmd", "ctrl" },
    key = "1",
    action = function()
      M.deleteAllVirtualScreens()
      M.createVirtualScreen(M.presets[1]) -- Kitty+Chrome
    end,
  },
  debugging = {
    name = M.presets[1].name,
    mod = { "cmd", "ctrl" },
    key = "2",
    action = function()
      M.deleteAllVirtualScreens()
      M.createVirtualScreen(M.presets[2]) -- GoLand+Kitty
    end,
  },
  clear = {
    name = "Clear Virtual Screens",
    mod = { "cmd", "ctrl" },
    key = "0",
    action = M.deleteAllVirtualScreens,
  },
}

-- Gets all virtual screens (enabled or disabled) and returns as table
function M.virtualScreens()
  local handle = io.popen(betterDisplayCLI .. " list --virtual --json")
  if not handle then return {} end

  local result = handle:read("*a")
  handle:close()

  if not result or result == "" then return {} end

  local success, screens = pcall(hs.json.decode, result)
  if not success or type(screens) ~= "table" then
    hs.alert.show("Failed to parse virtual screens")
    return {}
  end

  -- Extract names and status
  local virtualScreens = {}
  for _, screen in ipairs(screens) do
    if screen.isVirtual then
      table.insert(virtualScreens, {
        name = screen.name or "Unnamed",
        id = screen.id,
        connected = screen.connected,
        width = screen.width,
        height = screen.height,
      })
    end
  end

  return virtualScreens
end

-- Connecting to a virtual screen
function M.toggleVirtualScreen(name)
  local targetName = name
  if not targetName then
    -- Default to first preset name containing "virtual" or fallback to "virtual"
    local screens = M.virtualScreens()
    for _, screen in ipairs(screens) do
      if string.find(string.lower(screen.name), "virtual") then
        targetName = screen.name
        break
      end
    end
    targetName = targetName or "virtual"
  end

  local cmd = string.format("%s set -namelike=%s -connected=on", betterDisplayCLI, targetName)
  hs.execute(cmd)
end

-- Discard a virtual screen (use any identifier parameters to narrow the virtual screens to be discarded)
function M.discardVirtualScreenByName(namePattern)
  local cmd = string.format("%s discard -namelike=%s", betterDisplayCLI, namePattern or "virtual")
  hs.execute(cmd)
end

-- Discard all virtual screens (rather dangerous, will happen with no comment)
function M.discardAllVirtualScreens()
  local cmd = string.format("%s discard", betterDisplayCLI)
  hs.execute(cmd)
end

-- Rename a virtual screen from oldName to newName
function M.renameVirtualScreen(oldName, newName)
  local cmd = string.format("%s set -name=%s -virtualscreenname=%s", betterDisplayCLI, oldName, newName)
  hs.execute(cmd)
end

return M

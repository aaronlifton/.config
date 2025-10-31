local M = {}

function M.openTerminal()
  hs.application.launchOrFocus("Kitty")
end

function M.openLauncher()
  hs.urlevent.openURL("raycast://")
end

function M.lockScreen()
  hs.caffeinate.lockScreen()
end

function M.reloadHammerspoon()
  hs.reload()
end

return M
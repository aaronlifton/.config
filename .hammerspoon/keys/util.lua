local M = {}

--- Utility bindings
--- @type { [string]: KeyBinding[] }
M.bindings = {
  -- Kill git process (Assuming ProcessManager exists)
  {
    mod = K.mod.cmdShiftAlt,
    key = "G",
    action = function()
      ProcessManager.findAndKillProcesses(("git -C /Users/%s"):format(Config.username))
    end,
  },

  -- Disable Cmd+Q example
  -- { mod = K.mod.cmd, key = "q", action = function() hs.alert.show("Cmd+Q is disabled", 1) end },

  -- Reload Hammerspoon config
  {
    mod = K.mod.cmdShiftAlt,
    key = "r",
    action = function()
      hs.reload()
    end,
  },
  -- Neovide configuration
  {
    mod = K.mod.cmdAlt,
    key = "z",
    action = function()
      local currentSpace = hs.spaces.focusedSpace()
      -- Get neovide app
      local app = hs.application.get("neovide")
      -- If app already open:
      if app then
        -- If no main window, then open a new window
        if not app:mainWindow() then
          app:selectMenuItem("New OS Window", true)
          -- If app is already in front, then hide it
        elseif app:isFrontmost() then
          app:hide()
          -- If there is a main window somewhere, bring it to current space and to
          -- front
        else
          -- First move the main window to the current space
          hs.spaces.moveWindowToSpace(app:mainWindow(), currentSpace)
          -- Activate the app
          app:activate()
          -- Raise the main window and position correctly
          app:mainWindow():raise()
        end
        -- If app not open, open it
      else
        hs.application.launchOrFocus("neovide")
        app = hs.application.get("neovide")
      end
    end,
  },
}

return M

local M = {}

local window = require("functions.window")

function M.setup(mod, modules, omarchy)
  local window_focus = modules.window_focus or require("omarchy.bk.window_focus")
  local window_movement = modules.window_movement or require("omarchy.bk.window_movement")
  local window_resize = modules.window_resize or require("omarchy.bk.window_resize")
  local workspace = modules.workspace or require("omarchy.bk.workspace")
  local layouts = modules.layouts or require("omarchy.bk.layouts")
  local applications = modules.applications or require("omarchy.bk.applications")

  local function bind_with_restore(mod_keys, key, thunk)
    hs.hotkey.bind(mod_keys, key, function()
      local current_window = hs.window.focusedWindow()
      if not current_window then return end
      local current_frame = current_window:frame()
      local window_id = current_window:id()
      if not window_id then return end

      local restorable_frame = omarchy.restorable_frames[window_id]
      if restorable_frame then
        current_window:setFrame(restorable_frame)
        omarchy.restorable_frames[window_id] = nil
      else
        omarchy.restorable_frames[window_id] = current_frame
        thunk()
      end
    end)
  end

  hs.hotkey.bind(mod.super, "space", applications.openLauncher)
  -- TODO: need this for things such as: sending emails in gmail, sending messages in slack, etc.
  -- hs.hotkey.bind(mod.super, "return", applications.openTerminal)

  -- Hyprland style window management
  -- hs.hotkey.bind(mod.super, "q", window_movement.killWindow)
  -- hs.hotkey.bind(mod.superShift, "space", window_movement.toggleFloating)
  hs.hotkey.bind(mod.superShift, "f", window_movement.toggleFloating)

  hs.hotkey.bind(mod.super, "h", function()
    local focused = hs.window.focusedWindow()
    if focused then
      local leftWindow = focused:windowsToWest()[1]
      if leftWindow then leftWindow:focus() end
    end
  end)

  hs.hotkey.bind(mod.super, "l", function()
    local focused = hs.window.focusedWindow()
    local app = focused:application()
    -- Logger.d(("bundleID: %s, isFrontmost: %s"):format(app:bundleID(), tostring(app:isFrontmost())))
    if app:bundleID() == "com.google.Chrome" then
      if app:isFrontmost() then
        -- Emit cmd+l keyboard event for focusing on address bar
        hs.eventtap.keyStroke({ "cmd" }, "l", 0, app)
        return
      end
    end
    if focused then
      local rightWindow = focused:windowsToEast()[1]
      if rightWindow then rightWindow:focus() end
    end
  end)

  hs.hotkey.bind(mod.super, "j", function()
    local focused = hs.window.focusedWindow()
    if focused then
      local belowWindow = focused:windowsToSouth()[1]
      if belowWindow then belowWindow:focus() end
    end
  end)

  hs.hotkey.bind(mod.super, "k", function()
    local focused = hs.window.focusedWindow()
    local app = focused:application()
    -- Logger.d(("bundleID: %s, isFrontmost: %s"):format(app:bundleID(), tostring(app:isFrontmost())))
    if app:bundleID() == "com.raycast.macos" then
      if app:isFrontmost() then
        -- Emit cmd+k keyboard event for Raycast
        -- hs.eventtap.keyStroke({ "cmd" }, "k")
        hs.eventtap.keyStroke({ "cmd" }, "k", 0, app)
        return
      end
    end
    if focused then
      local aboveWindow = focused:windowsToNorth()[1]
      if aboveWindow then aboveWindow:focus() end
    end
  end)

  local function isTerminalApp(win)
    if not win then return false end
    local appName = win:application():name()
    for _, termApp in ipairs(omarchy.config.terminalApps) do
      if appName == termApp then return true end
    end
    return false
  end
  -- local focused = hs.window.focusedWindow()
  -- if isTerminalApp(focused) and omarchy.config.nvimMappings.superShiftH then
  --   Logger.d("superShiftH already bound in nvim, using superShiftAltH")
  --   return
  -- end

  hs.hotkey.bind(mod.superShift, "h", function()
    local focused = hs.window.focusedWindow()

    if focused then focused:moveOneScreenWest() end
  end)

  hs.hotkey.bind(mod.superShift, "l", function()
    local focused = hs.window.focusedWindow()

    if focused then focused:moveOneScreenEast() end
  end)

  hs.hotkey.bind(mod.superShift, "j", function()
    local focused = hs.window.focusedWindow()
    if focused then focused:moveOneScreenSouth() end
  end)

  hs.hotkey.bind(mod.superShift, "k", function()
    local focused = hs.window.focusedWindow()
    if focused then focused:moveOneScreenNorth() end
  end)

  hs.hotkey.bind(mod.superCtrl, "h", function()
    local focused = hs.window.focusedWindow()
    if focused then
      local frame = focused:frame()
      frame.w = frame.w - 50
      focused:setFrame(frame)
    end
  end)

  hs.hotkey.bind(mod.superCtrl, "l", function()
    local focused = hs.window.focusedWindow()
    if focused then
      local frame = focused:frame()
      frame.w = frame.w + 50
      focused:setFrame(frame)
    end
  end)

  hs.hotkey.bind(mod.superCtrl, "j", function()
    local focused = hs.window.focusedWindow()
    if focused then
      local frame = focused:frame()
      frame.h = frame.h + 50
      focused:setFrame(frame)
    end
  end)

  hs.hotkey.bind(mod.superCtrl, "k", function()
    local focused = hs.window.focusedWindow()
    if focused then
      local frame = focused:frame()
      frame.h = frame.h - 50
      focused:setFrame(frame)
    end
  end)

  -- Layout Modal
  local layoutModal = hs.hotkey.modal.new({}, nil, nil)

  layoutModal:bind({}, "1", function()
    layouts.layoutTiled()
    layoutModal:exit()
  end)

  layoutModal:bind({}, "2", function()
    layouts.layoutTiledWithHidden()
    layoutModal:exit()
  end)

  layoutModal:bind({}, "3", function()
    layouts.layoutTiledMultiSpace()
    layoutModal:exit()
  end)

  layoutModal:bind({}, "r", function()
    layouts.rotateLayout()
    layoutModal:exit()
  end)

  layoutModal:bind({}, "escape", function()
    layoutModal:exit()
  end)

  -- Activate layout modal with Hyper+L
  hs.hotkey.bind(mod.hyper, "l", function()
    layoutModal:enter()
    local layoutOptions = {
      ["1"] = "Tiled",
      ["2"] = "Hidden",
      ["3"] = "MultiSpace",
      ["r"] = "Rotate",
    }
    help_text = "Layout Mode:\n\n"
    for key, name in pairs(layoutOptions) do
      help_text = string.format("%s%s  →  %s\n", help_text, key, name)
    end
    hs.alert.show(help_text, 2)
  end)

  hs.hotkey.bind(mod.superCtrl, "return", window_movement.swapWithMaster)
  hs.hotkey.bind(mod.superShift, "return", window_movement.swapWithMaster)

  hs.hotkey.bind(mod.superShift, "h", function()
    window_resize.decreaseMasterRatio()
  end)

  hs.hotkey.bind(mod.superShift, "l", function()
    window_resize.increaseMasterRatio()
  end)

  hs.hotkey.bind(mod.superCtrl, "h", function()
    window_movement.swapWindowInDirection("left")
  end)

  hs.hotkey.bind(mod.superCtrl, "l", function()
    window_movement.swapWindowInDirection("right")
  end)

  hs.hotkey.bind(mod.superCtrl, "j", function()
    window_movement.swapWindowInDirection("down")
  end)

  hs.hotkey.bind(mod.superCtrl, "k", function()
    window_movement.swapWindowInDirection("up")
  end)

  hs.hotkey.bind(mod.super, "tab", window_focus.cycleWindowForward)
  hs.hotkey.bind(mod.superShift, "tab", window_focus.cycleWindowBackward)

  hs.hotkey.bind(mod.super, "m", window_focus.minimizeWindow)
  hs.hotkey.bind(mod.superShift, "m", window_focus.unminimizeAllWindows)

  for i = 1, 9 do
    -- hs.hotkey.bind(mod.super, tostring(i), function()
    hs.hotkey.bind(mod.hyper, tostring(i), function()
      workspace.gotoWorkspace(i)
    end)

    Logger.d("Binding Super + Shift + " .. tostring(i) .. ' to "Move window to workspace" ' .. i)
    hs.hotkey.bind(mod.superShift, tostring(i), function()
      workspace.moveWindowToWorkspace(i)
    end)
  end

  hs.hotkey.bind(mod.superAlt, "h", function()
    window.push({ left = 0, top = 0, width = 0.5, height = 1 })
  end)

  hs.hotkey.bind(mod.superAlt, "l", function()
    window.push({ left = 0.5, top = 0, width = 0.5, height = 1 })
  end)

  hs.hotkey.bind(mod.superAlt, "k", function()
    window.push({ left = 0, top = 0, width = 1, height = 0.5 })
  end)

  hs.hotkey.bind(mod.superAlt, "j", function()
    window.push({ left = 0, top = 0.5, width = 1, height = 0.5 })
  end)

  hs.hotkey.bind(mod.superAlt, "u", function()
    window.push({ left = 0, top = 0, width = 0.5, height = 0.5 })
  end)

  hs.hotkey.bind(mod.superAlt, "i", function()
    window.push({ left = 0.5, top = 0, width = 0.5, height = 0.5 })
  end)

  hs.hotkey.bind(mod.superAlt, "n", function()
    window.push({ left = 0, top = 0.5, width = 0.5, height = 0.5 })
  end)

  hs.hotkey.bind(mod.superAlt, "m", function()
    window.push({ left = 0.5, top = 0.5, width = 0.5, height = 0.5 })
  end)

  hs.hotkey.bind(mod.superAlt, "c", function()
    window.push({ left = 0.125, top = 0.125, width = 0.75, height = 0.75 })
  end)

  -- OSX style fullscreen
  hs.hotkey.bind(mod.superAlt, "f", window_movement.toggleFullscreen)

  -- "Fake" fullscreen (restorable)
  bind_with_restore(mod.superAlt, "f", function()
    window.push({ left = 0, top = 0, width = 1, height = 1 })
  end)

  hs.hotkey.bind(mod.superShift, ".", function()
    local focused = hs.window.focusedWindow()
    if focused then focused:moveToScreen(focused:screen():next()) end
  end)

  hs.hotkey.bind(mod.superShift, ",", function()
    local focused = hs.window.focusedWindow()
    if focused then focused:moveToScreen(focused:screen():previous()) end
  end)

  hs.hotkey.bind(mod.superShift, "r", applications.reloadHammerspoon)
  hs.hotkey.bind(mod.superShift, "q", applications.lockScreen)
end

return M

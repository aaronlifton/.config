local logger = require("functions.logger")

---@diagnostic disable-next-line: lowercase-global
escape = hs.hotkey.bind({ "cmd" }, "escape", function()
  local window = hs.window.frontmostWindow()
  local application = window:application()
  local id = application:bundleID()

  if not application then
    hs.alert.show("No frontmost application found.")
    return
  end
  if not window then
    hs.alert.show("No frontmost window found.")
    return
  end
  if window:isStandard() then
    hs.alert.show("Bundle ID: " .. hs.window.frontmostWindow():application():bundleID())
    application:hide()
    return
  end

  logger.d("Checking apps...")(({
    ["com.apple.Spotlight"] = function()
      hs.eventtap.keyStroke({}, "escape")
    end,

    ["com.raycast.macos"] = function()
      escape:disable()
      -- hs.eventtap.keyStroke({ "cmd" }, "escape")
      hs.alert.show("Bundle ID: " .. id)
      escape:enable()
    end,
  })[id] or function()
    application:hide()
  end)()
end)

local betterdisplaycli = require("functions.better_display")
local Layout = require("keys.window").layouts
local win = require("functions.window")

-- ## Alphabetical list of table keys:
--
-- 1. `"0"` (1Password)
-- 2. `"7"` (Spotify)
-- 3. `"8"` (com.apple.systempreferences)
-- 4. `a` (AI/Apple Intelligence sub-table)
-- 5. `b` (BetterDisplay)
-- 6. `c` (Chrome function)
-- 7. `d` (Dash)
-- 8. `f` (Finder)
-- 9. `g` (GoLand)
-- 10. `h` (Hammerspoon sub-table)
-- 11. `k` (Kitty function)
-- 12. `l` (Calendar function)
-- 13. `m` (Mac utilities sub-table)
-- 14. `n` (Neovide)
-- 15. `o` (Obsidian function)
-- 16. `p` (TablePlus)
-- 17. `r` (Raycast/Cursor sub-table)
-- 18. `s` (Slack function)
-- 19. `t` (Terminal sub-table)
-- 20. `u` (Cursor)
-- 21. `w` (Warp)
-- 22. `x` (Hammerspoon console function)
-- 23. `z` (Chrome secondary screen function)
local bindings = {
  -- [A]I
  -- BetterDisplay
  -- b = function()
  --   betterDisplayCli.toggleVirtualScreen()
  -- end,
  a = {
    -- [C]ursor
    c = {
      -- [d]ocumentation
      d = function()
        hs.urlevent.openURL("raycast://extensions/degouville/cursor/index")
      end,
    },
    -- Apple [I]ntelligence
    i = {
      c = function()
        hs.urlevent.openURL("raycast://extensions/EvanZhouDev/raycast-apple-intelligence/compose")
      end,
      -- [e]dit text
      e = {
        -- [c]oncise
        c = function()
          hs.urlevent.openURL("raycast://extensions/EvanZhouDev/raycast-apple-intelligence/make-concise")
        end,
        -- [f]riendly
        f = function()
          hs.urlevent.openURL("raycast://extensions/EvanZhouDev/raycast-apple-intelligence/make-friendly")
        end,
      },
      -- [k]ey points
      k = function()
        hs.urlevent.openURL("raycast://extensions/EvanZhouDev/raycast-apple-intelligence/create-key-points")
      end,
      s = function()
        hs.urlevent.openURL("raycast://extensions/EvanZhouDev/raycast-apple-intelligence/summarize")
      end,
      -- ask about [w]ebpage
      w = function()
        hs.urlevent.openURL("raycast://ai-commands/ask-about-webpage?arguments=")
      end,
    },
    g = function()
      hs.urlevent.openURL(
        "raycast://extensions/EvanZhouDev/raycast-gemini/askAboutScreen?arguments=%9B%22query%22%3A%22%22%7D"
      )
    end,
    l = "com.anthropic.claudefordesktop",
    -- Model [C]ontext Protocol (MCP)
    m = {
      -- Context[7]
      ["7"] = function()
        local val = hs.dialog.textPrompt("Ask Context 7", "Question:", "", "Enter", "Cancel")
        hs.urlevent.openURL(("raycast://ai-commands/ask-context-7-query?arguments=%s"):format(val))
        -- hs.urlevent.openURL(("raycast://extensions/raycast/context-7/ask-context-7?arguments="):format(val))
      end,
    },
    o = "Ollama",
  },
  b = "BetterDisplay",
  -- c = "Google Chrome",
  c = function()
    -- win.iterateWindows("Google Chrome"),

    -- Function to switch to Chrome window on Built-in Display
    local chromeApp = hs.application.get("Google Chrome")
    if not chromeApp then
      -- If Chrome is not running, launch it
      hs.application.launchOrFocus("Google Chrome")
      return
    end

    -- Get all Chrome windows
    local chromeWindows = chromeApp:allWindows()
    if not chromeWindows or #chromeWindows == 0 then
      -- No Chrome windows, launch Chrome
      hs.application.launchOrFocus("Google Chrome")
      return
    end

    -- Find Chrome window on Built-in Display
    local builtInWindow = nil
    for _, window in ipairs(chromeWindows) do
      if window:screen():name() == Screens.main then
        builtInWindow = window
        break
      end
    end

    if builtInWindow then
      -- Focus the Chrome window on Built-in Display
      builtInWindow:focus()
      builtInWindow:raise()
    else
      -- No Chrome window on Built-in Display, focus any Chrome window
      chromeWindows[1]:focus()
      chromeWindows[1]:raise()
    end
  end,
  d = "Dash",
  f = "Finder",
  g = "GoLand",
  -- Hammerspoon
  h = {
    c = function()
      hs.urlevent.openURL("raycast://extensions/bjrmatos/hammerspoon/open-console")
    end,
    o = "Hammerspoon",
    r = function()
      hs.alert.show("Reloading hammerspoon config...")
      hs.reload()
    end,
  },
  -- k = "Kitty",
  k = function()
    Logger.d(string.format("Hyper+k pressed;; Screen count: %d", Config.screenCount))
    if Config.screenCount > 1 then
      win.iterateMonitorWindows("Kitty")()
    else
      win.iterateWindows("Kitty")()
      -- win.activateApp("Kitty", true)
    end
  end,
  -- l = "calendar",
  l = function()
    Window.activateAndMoveToLayout("Calendar", Layout.first_two_thirds, function(win)
      win.move_one_screen_south()
    end)
  end,
  -- [m]ac (mac) - thought this would be [s]settings or [s]ystem
  m = {
    c = function()
      hs.urlevent.openURL("raycast://extensions/raycast/clipboard-history/clipboard-history")
    end,
    f = "com.apple.FontBook",
    k = function()
      hs.urlevent.openURL("raycast://extensions/raycast/keyboard/keyboard")
    end,
    i = "com.apple.ScreenContinuity",
  },
  n = win.iterateWindows("Neovide"),
  -- Obsidian
  o = function()
    local app = hs.application.frontmostApplication()
    if app:name() == "Finder" then
      -- https://www.hammerspoon.org/docs/hs.eventtap.html#keyStroke
      hs.eventtap.keyStroke({ "cmd" }, "o", 0, app)
    else
      -- hs.eventtap.keyStroke({}, "Return", 0)
      Window.activateApp("md.obsidian")
    end
  end,
  -- Table[P]lus 1[P]assword
  p = {
    t = "TablePlus",
    ["1"] = "1Password",
  },
  -- Raycast
  r = {
    d = function()
      hs.urlevent.openURL("raycast://extensions/degouville/cursor/index")
    end,
    p = function()
      hs.urlevent.openURL("raycast://extensions/degouville/cursor-recent-projects/index")
    end,
    s = function()
      hs.urlevent.openURL("raycast://extensions/raycast/calendar/my-schedule")
    end,
  },
  -- Terminal
  t = {
    a = "Alacritty",
    g = "Ghostty",
    w = "Warp",
    ["return"] = function()
      hs.execute("kitten quick-access-terminal", true)
    end,
  },
  -- Slack
  s = function()
    -- hs.urlevent.openURL("raycast://extensions/raycast/system-preferences/system-preferences")
    local app = hs.application.get("Slack")
    if app then
      local windows = app:allWindows()
      for _, window in ipairs(windows) do
        if window:isMinimized() then window:unminimize() end
      end
    end
    Window.activateAndMoveToLayout("Slack", Layout.slack, function(win)
      win.move_one_screen_south()
    end)
  end,
  u = "Cursor",
  v = "com.microsoft.VSCode",
  w = "Warp",
  -- Hammerspoon console
  x = function()
    local success, output, code = hs.osascript.applescript([[
      tell application "Hammerspoon"
        execute lua code "hs.openConsole()"
      end tell
    ]])
    Logger.d("Success: " .. tostring(success) .. ", Output: " .. tostring(output) .. ", Code: " .. tostring(code))
  end,
  y = function()
    -- local appName = "Floorp"
    local bundleID = "org.mozilla.floorp"
    local app = hs.application.get(bundleID)
    if not app then
      Logger.d("Floorp not found")
      -- If Chrome is not running, launch it
      win.iterateWindows(appNameOrBundleID)()
    end

    -- Get all Chrome windows
    local chromeWindows = app:allWindows()
    if not chromeWindows or #chromeWindows == 0 then
      -- No Chrome windows, launch Chrome
      hs.application.launchOrFocus("Google Chrome")
      return
    end
    win.iterateWindows("Floorp")
  end,
  -- Alternate Work/Personal Chrome between monitors
  z = win.alternateMonitorApps("Google Chrome"),
  -- z = function()
  --   -- hs.execute('open -na "Google Chrome" --args --profile-directory="Profile 2"', true)
  --   local chromeApp = hs.application.get("Google Chrome")
  --   if not chromeApp then
  --     -- If Chrome is not running, launch it
  --     return
  --   end
  --
  --   -- Get all Chrome windows
  --   local chromeWindows = chromeApp:allWindows()
  --   if not chromeWindows or #chromeWindows == 0 then
  --     -- No Chrome windows, launch Chrome
  --     hs.application.launchOrFocus("Google Chrome")
  --     return
  --   end
  --
  --   -- Find Chrome window on Built-in Display
  --   local builtInWindow = nil
  --   for _, window in ipairs(chromeWindows) do
  --     if window:screen():name() == Screens.secondary then
  --       builtInWindow = window
  --       break
  --     end
  --   end
  --
  --   if builtInWindow then
  --     -- Focus the Chrome window on Built-in Display
  --     builtInWindow:focus()
  --     builtInWindow:raise()
  --   else
  --     -- No Chrome window on Built-in Display, focus any Chrome window
  --     chromeWindows[1]:focus()
  --     chromeWindows[1]:raise()
  --   end
  -- end,
  ["1"] = function()
    hs.urlevent.openURL("raycast://extensions/raycast/calendar/my-schedule")
  end,
  ["6"] = "com.electron.scrypted",
  ["7"] = "Spotify",
  ["8"] = "com.apple.systempreferences",
  -- ["9"] = "System Preferences"
}

if spoon.HSearch then
  -- Bind Hsearch to Hyper+8
  bindings["8"] = {
    h = function()
      spoon.HSearch:toggleShow()
    end,
    ["/"] = function()
      local help_text = "HSearch Sources:\n"
      help_text = help_text .. "  e - Emoji Search\n"
      help_text = help_text .. "  d - Date Formatter\n"
      help_text = help_text .. "  t - Browser Tabs\n"
      help_text = help_text .. "  y - Dictionary\n"
      help_text = help_text .. "  n - Notes\n"
      hs.alert.show(help_text, 3)
    end,
  }
end

-- Add better_display bindings
-- for _, preset in ipairs(betterDisplayCli.presets) do
--   local key = preset.name:sub(1, 1):lower() -- Use first letter of preset name
--   bindings[key] = function()
--     betterDisplayCli.createVirtualScreen(preset)
--   end
-- end

-- for _, mode in pairs(betterDisplayCli.modes) do
--   bindings[mode.key] = mode.action
-- end

return bindings

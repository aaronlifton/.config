local betterDisplayCli = require("functions.better_display")
local Layout = require("keys").layouts
local logger = require("functions.logger")
local win = require("functions.window")

local bindings = {
  -- [A]I
  -- BetterDisplay
  -- b = function()
  --   betterDisplayCli.toggleVirtualScreen()
  -- end,
  b = "BetterDisplay",
  -- c = "Google Chrome",
  -- ["999"] = iterateWindows("Google Chrome"),
  c = function()
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
  z = function()
    -- hs.execute('open -na "Google Chrome" --args --profile-directory="Profile 2"', true)
    local chromeApp = hs.application.get("Google Chrome")
    if not chromeApp then
      -- If Chrome is not running, launch it
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
      if window:screen():name() == Screens.secondary then
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
  a = {
    -- Apple [I]ntelligence
    i = {
      s = function()
        hs.urlevent.openURL("raycast://extensions/EvanZhouDev/raycast-apple-intelligence/summarize")
      end,
      c = function()
        hs.urlevent.openURL("raycast://extensions/EvanZhouDev/raycast-apple-intelligence/compose")
      end,
      -- [e]dit text
      e = {
        -- [f]riendly, [c]oncise
        f = function()
          hs.urlevent.openURL("raycast://extensions/EvanZhouDev/raycast-apple-intelligence/make-friendly")
        end,
        c = function()
          hs.urlevent.openURL("raycast://extensions/EvanZhouDev/raycast-apple-intelligence/make-concise")
        end,
      },
      -- [k]ey points
      k = function()
        hs.urlevent.openURL("raycast://extensions/EvanZhouDev/raycast-apple-intelligence/create-key-points")
      end,
      -- ask about [w]ebpage
      w = function()
        hs.urlevent.openURL("raycast://ai-commands/ask-about-webpage?arguments=")
      end,
    },
    l = "Claude",
    o = "Ollama",
    -- Model [C]ontext Protocol (MCP)
    m = {
      -- Context[7]
      ["7"] = function()
        hs.dialog.textPrompt("Ask Context 7", "Question:", "", "Enter", "Cancel")
        hs.urlevent.openURL("raycast://ai-commands/ask-context-7-query?arguments=")
      end,
    },
    -- [C]ursor
    c = {
      -- [d]ocumentation
      d = function()
        hs.urlevent.openURL("raycast://extensions/degouville/cursor/index")
      end,
    },
    g = {
      g = function()
        hs.urlevent.openURL(
          "raycast://extensions/EvanZhouDev/raycast-gemini/askAboutScreen?arguments=%9B%22query%22%3A%22%22%7D"
        )
      end,
    },
  },
  k = win.iterateMonitorWindows("Kitty"),
  f = "Finder",
  g = "GoLand",
  -- k = "Kitty",
  n = "Neovide",
  o = "Obsidian",
  p = "TablePlus",
  s = function()
    -- hs.urlevent.openURL("raycast://extensions/raycast/system-preferences/system-preferences")

    Window.activate_and_move_to_layout("Slack", Layout.slack, function(win)
      win.move_one_screen_south()
    end)
  end,
  -- l = "calendar",
  -- l = {
  --   c = function()
  --     Window.activate_and_move_to_layout("Calendar", Layout.first_two_thirds, function(win)
  --       win.move_one_screen_south()
  --     end)
  --   end,
  --   s = function()
  --     hs.urlevent.openURL("raycast://extensions/raycast/calendar/my-schedule")
  --   end,
  -- },
  l = function()
    Window.activate_and_move_to_layout("Calendar", Layout.first_two_thirds, function(win)
      win.move_one_screen_south()
    end)
  end,
  u = "Cursor",
  w = "Warp",
  -- Terminal
  t = {
    -- ["padenter"] = function()
    --   hs.execute("kitten quick-access-terminal", true)
    -- end,
    a = "Alacritty",
    g = "Ghostty",
    w = "Warp",
  },
  r = {
    p = function()
      hs.urlevent.openURL("raycast://extensions/degouville/cursor-recent-projects/index")
    end,
    i = function()
      hs.urlevent.openURL("raycast://extensions/degouville/cursor/index")
    end,
  },
  -- Hammerspoon
  h = {
    o = "Hammerspoon",
    c = function()
      hs.urlevent.openURL("raycast://extensions/bjrmatos/hammerspoon/open-console")
    end,
    r = function()
      hs.alert.show("Reloading hammerspoon config...")
      hs.reload()
    end,
  },
  -- d ? - thought this would be [s]settings or [s]ystem
  -- [m]ac
  m = {
    c = function()
      hs.urlevent.openURL("raycast://extensions/raycast/clipboard-history/clipboard-history")
    end,
    f = "Font Book",
    k = function()
      hs.urlevent.openURL("raycast://extensions/raycast/keyboard/keyboard")
    end,
  },
  ["0"] = "1Password",
  -- ["9"] = "System Preferences"
  ["7"] = "Spotify",
  ["8"] = function()
    hs.urlevent.openURL("raycast://extensions/raycast/system-preferences/system-preferences")
  end,
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

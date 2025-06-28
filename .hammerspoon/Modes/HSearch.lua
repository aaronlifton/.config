local colors = require("colors")

local function test()
  hs.loadSpoon("HSearch")
  spoon.HSearch:loadSources()
end

if spoon.HSearch then
  local modal_mgr = spoon.ModalMgr
  -- Main hotkey to activate HSearch
  hs.hotkey.bind({ "alt" }, "g", function()
    spoon.HSearch:toggleShow()
  end)

  -- Make sure to load sources on init
  spoon.HSearch:loadSources()

  -- Create a modal for HSearch features
  modal_mgr:new("HSearch")
  local hsearch_modal = modal_mgr.modal_list["HSearch"]

  -- Bind the modal to Hyper+h
  hs.hotkey.bind(HyperBinding, "z", function()
    modal_mgr:activate({ "HSearch" }, "#8aadf4", true)
    hs.alert.show("HSearch mode active", 1)
  end)

  -- Bind keys for different HSearch sources
  -- hsearch_modal:bind("", "e", "Emoji Search", function()
  --   spoon.HSearch:toggleShow()
  --   hs.eventtap.keyStrokes("e")
  --   hs.eventtap.keyStroke({}, "tab")
  --   modal_mgr:deactivate({ "HSearch" })
  -- end)

  -- hsearch_modal:bind("", "d", "Date Formatter", function()
  --   spoon.HSearch:toggleShow()
  --   hs.eventtap.keyStrokes("d")
  --   hs.eventtap.keyStroke({}, "tab")
  --   modal_mgr:deactivate({ "HSearch" })
  -- end)

  hsearch_modal:bind("", "t", "Browser Tabs", function()
    spoon.HSearch:toggleShow()
    hs.eventtap.keyStrokes("b")
    hs.eventtap.keyStroke({}, "tab")
    modal_mgr:deactivate({ "HSearch" })
  end)

  -- hsearch_modal:bind("", "y", "Dictionary", function()
  --   spoon.HSearch:toggleShow()
  --   hs.eventtap.keyStrokes("y")
  --   hs.eventtap.keyStroke({}, "tab")
  --   modal_mgr:deactivate({ "HSearch" })
  -- end)

  hsearch_modal:bind("", "n", "Notes", function()
    spoon.HSearch:toggleShow()
    hs.eventtap.keyStrokes("n")
    hs.eventtap.keyStroke({}, "tab")
    modal_mgr:deactivate({ "HSearch" })
  end)

  -- Add escape key to exit the modal
  hsearch_modal:bind("", "escape", function()
    modal_mgr:deactivate({ "HSearch" })
  end)

  -- Add help key to show available options
  hsearch_modal:bind("shift", "/", "Show available sources", function()
    local help_text = "HSearch Sources:\n"
    help_text = help_text .. "  e - Emoji Search\n"
    help_text = help_text .. "  d - Date Formatter\n"
    help_text = help_text .. "  t - Browser Tabs\n"
    help_text = help_text .. "  y - Dictionary\n"
    help_text = help_text .. "  n - Notes\n"
    hs.alert.show(help_text, 3)
  end)

  return hsearch_modal
else
  hs.alert.show("HSearch spoon not found. Please install it from Hammerspoon Spoons repository.", 3)
end

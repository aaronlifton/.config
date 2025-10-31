local M = {}

local hyperLogger = hs.logger.new("hyper")
local appMap = require("hyper_apps")
-- Create a modal manager for nested key sequences
local modal_mgr = spoon.ModalMgr

-- hyperLogger.d("Creating single letter app bindings")
-- -- spoon.SpoonInstall:andUse("AppWindowSwitcher", {
-- --   hotkeys = singleLetterApps,
-- -- })
-- hs.loadSpoon("AppWindowSwitcher"):setLogLevel("debug"):bindHotkeys(singleLetterApps)

-- Function to handle app binding execution
local function check_binding(app, key)
  if type(app) == "string" then
    -- Check if the string starts with com., org., etc. (likely a bundle ID)
    Window.activateApp(app)
  elseif type(app) == "function" then
    app()
  else
    hyperLogger:e("Invalid mapping for key '" .. tostring(key) .. "'")
  end
end

-- Recursive function to create modal bindings for nested key maps
-- path is the sequenje of keys pressed so far (for display purposes)
-- prefix is the modal name prefix
local function create_modal_bindings(keymap, path, prefix)
  local modal_name = prefix
  ---@diagnostic disable-next-line: undefined-field
  local cmodal = modal_mgr.modal_list[modal_name]

  -- For each key in this level
  for key, action in pairs(keymap) do
    local current_path = path .. key

    if type(action) == "table" then
      -- This is a nested keymap, create a new modal for it
      local nested_modal_name = prefix .. "_" .. key
      modal_mgr:new(nested_modal_name)

      -- Bind the key to activate the nested modal
      cmodal:bind("", key, function()
        modal_mgr:deactivate({ modal_name })
        modal_mgr:activate({ nested_modal_name }, "#FFBD2E", true)

        -- Show a hint about which modal is active
        hs.alert.show(current_path .. " mode active", 1)
      end)

      -- Recursively create bindings for the nested keymap
      create_modal_bindings(action, current_path .. "+", nested_modal_name)
    else
      -- This is a leaf action, bind it directly
      cmodal:bind("", key, function()
        check_binding(action)
        modal_mgr:deactivate({ modal_name })
      end)
    end
  end

  -- Add escape key to exit the modal
  cmodal:bind("", "escape", function()
    modal_mgr:deactivate({ modal_name })
  end)

  -- Add a help key to show available options
  cmodal:bind("shift", "/", "Show available keys", function()
    local help_text = "Available keys for " .. path:sub(1, -2) .. ":\n"
    for nested_key, nested_action in pairs(keymap) do
      if type(nested_action) == "table" then
        help_text = string.format("%s %s → [submenu]\n", help_text, nested_key)
      else
        if type(nested_action) == "string" then
          help_text = string.format("%s %s  → %s\n", help_text, nested_key, nested_action)
        else
          -- help_text = string.format("%s %s\n", help_text, nested_key)
          help_text = string.format("%s %s  → [function]\n", help_text, nested_key)
        end
      end
    end
    hs.alert.show(help_text, 3)
  end)
end

-- Process the app mappings
for key, app in pairs(appMap) do
  if type(app) == "table" then
    -- Create a new modal for this key
    local modal_name = "Hyper_" .. key
    modal_mgr:new(modal_name)

    -- Bind the initial key to activate the modal
    hs.hotkey.bind(HyperBinding, key, function()
      -- Activate the modal for this key
      modal_mgr:activate({ modal_name }, Theme.green, true)

      -- Show a hint about which modal is active
      Logger.d("Activating modal for key: " .. key)
      -- hs.alert.show("Hyper+" .. key .. " mode active", 1)
    end)

    -- Create recursive bindings for this keymap
    create_modal_bindings(app, "Hyper+" .. key .. "+", modal_name)
  else
    -- For non-nested keys, bind directly
    hs.hotkey.bind(HyperBinding, key, function()
      check_binding(app, key)
    end)
  end
end

return M

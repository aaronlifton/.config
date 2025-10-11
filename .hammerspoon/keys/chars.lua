local M = {}

--- @type { [string]: KeyBinding[] }
M.bindings = {
  -- Now implemented by karabiner.edn:
  -- [:!Sescape :!Sgrave_accent_and_tilde]
  -- [:!Tescape :grave_accent_and_tilde]
  -- [:!Oescape :grave_accent_and_tilde]
  -- ` character using different modifiers
  -- {
  --   mod = K.mod.ctrl,
  --   key = "escape",
  --   action = function()
  --     hs.eventtap.keyStrokes("`")
  --   end,
  -- },
  -- {
  --   mod = K.mod.alt,
  --   key = "escape",
  --   action = function()
  --     hs.eventtap.keyStrokes("`")
  --   end,
  -- }, -- Faster
  -- ~ character
  {
    mod = K.mod.shift,
    key = "escape",
    action = function()
      hs.eventtap.keyStrokes("~")
    end,
  },
}

M.altBindings = {
  -- Escape key produces tilde (~) when pressed alone
  {
    mod = {},
    key = "escape",
    action = function()
      hs.eventtap.keyStrokes("~")
    end,
  },

  -- Shift+escape, Alt+escape, Ctrl+escape, Super+escape produce actual escape key
  {
    mod = K.mod.alt,
    key = "escape",
    action = function()
      hs.eventtap.keyStroke({}, "escape")
    end,
  },
  {
    mod = K.mod.ctrl,
    key = "escape",
    action = function()
      hs.eventtap.keyStroke({}, "escape")
    end,
  },
  {
    mod = K.mod.super,
    key = "escape",
    action = function()
      hs.eventtap.keyStroke({}, "escape")
    end,
  },
}

return M

local M = {}

--- @type { [string]: KeyBinding[] }
M.bindings = {
  -- ` character using different modifiers
  {
    mod = K.mod.ctrl,
    key = "escape",
    action = function()
      hs.eventtap.keyStrokes("`")
    end,
  },
  {
    mod = K.mod.alt,
    key = "escape",
    action = function()
      hs.eventtap.keyStrokes("`")
    end,
  }, -- Faster

  -- ~ character
  {
    mod = K.mod.shift,
    key = "escape",
    action = function()
      hs.eventtap.keyStrokes("~")
    end,
  },
}

return M

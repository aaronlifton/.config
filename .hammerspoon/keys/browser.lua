local M = {}
local browser = require("functions.browser")

--- @type { [string]: KeyBinding[] }
M.bindings = {
  { mod = K.mod.cmdShift, key = "T", action = browser.newTabToRight },
}

return M

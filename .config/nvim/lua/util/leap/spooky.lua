---@class util.leap.spooky
local M = {}

M.leap_spooky_viw = function()
  require("leap").leap({
    target_windows = { vim.fn.win_getid() },
    action = require("leap-spooky").spooky_action(function()
      return "viw"
    end, {
      keeppos = true,
      on_exit = (vim.v.operator == "y") and "p",
    }),
  })
end

M.leap_spooky_diw = function()
  require("leap").leap({
    target_windows = { vim.fn.win_getid() },
    action = require("leap-spooky").spooky_action(function()
      return "diw"
    end, {
      keeppos = true,
      on_exit = (vim.v.operator == "y") and "p",
    }),
  })
end

M.leap_spooky_dd = function()
  require("leap").leap({
    target_windows = { vim.fn.win_getid() },
    action = require("leap-spooky").spooky_action(function()
      return "dd"
    end, {
      keeppos = true,
      on_exit = (vim.v.operator == "y") and "p",
    }),
  })
end

return M

local M = {}

--- Copies a value to the clipboard
---@param val str|number
M.set_clipboard = function(val)
  vim.api.nvim_call_function("setreg", { "+", val })
end

return M

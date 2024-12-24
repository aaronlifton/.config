---@class buf
local M = {}

--- Get current buffer name
M.bufname = function()
  return vim.api.nvim_buf_get_name(vim.fn.bufnr())
end

M.buftype = function()
  return vim.api.nvim_get_option_value("buftype", { buf = 0 })
end

return M

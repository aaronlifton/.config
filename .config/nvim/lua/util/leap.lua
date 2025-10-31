---@class util.leap
local M = {}

---@param buf number
---@return function
function M.get_leap_for_buf(buf)
  return function()
    local win = vim.fn.bufwinid(buf)
    require("leap").leap({ target_windows = { win } })
  end
end

function M.buf_leap()
  local buf = vim.api.nvim_get_current_buf()
  local leap = M.get_leap_for_buf(buf)()
  leap()
end

return M

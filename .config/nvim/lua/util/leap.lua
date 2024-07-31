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

return M

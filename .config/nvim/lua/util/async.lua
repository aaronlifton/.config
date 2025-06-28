---@class util.async
---@field close_handle fun(handle: uv.uv_handle_t | nil)
local M = {}

--- closes given uv handle if open
---@param handle uv.uv_handle_t | nil
function M.close_handle(handle)
  if handle and not handle:is_closing() then handle:close() end
end

return M

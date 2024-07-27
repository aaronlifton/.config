local M = {}

---@param status string
---@return string
M.highlight_for_status = function(status)
  return status:match("ON") and "healthSuccess" or "healthError"
end

return M

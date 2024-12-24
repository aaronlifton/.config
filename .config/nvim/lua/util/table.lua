---@class util.table
local M = {}
local TableExt = {}

---Safely get a nested value in a table
---@param t table The table to search in
---@param ... string The keys to search for
---@return any value The value found or nil if any key in the path is nil
function M.get(t, ...)
  local keys = { ... }
  local result = t

  for _, key in ipairs(keys) do
    if type(result) ~= "table" then return nil end
    result = result[key]
  end

  return result
end

--- Usage: TableExt({ 1, 2, 3 }):find_index(2)
---@param t table
---@return table
function TableExt:new(t)
  ---@param t table
  setmetatable(t, self)
  self.__index = {
    find_index = function(t, value)
      for i, v in ipairs(t) do
        if v == value then return i end
      end
      return nil
    end,
  }
  return t
end
M.TableExt = TableExt

M.find_index = function(t, value)
  for i, v in ipairs(t) do
    if v == value then return i end
  end
  return nil
end

return M

---@class util.table
local M = {}
local TableExt = {}

--- Usage: TableExt({ 1, 2, 3 }):find_index(2)
---@param t table
---@return table
function TableExt:new(t)
  ---@param t table
  setmetatable(t, self)
  self.__index = {
    find_index = function(t, value)
      for i, v in ipairs(t) do
        if v == value then
          return i
        end
      end
      return nil
    end,
  }
  return t
end
M.TableExt = TableExt

M.find_index = function(t, value)
  for i, v in ipairs(t) do
    if v == value then
      return i
    end
  end
  return nil
end

return M

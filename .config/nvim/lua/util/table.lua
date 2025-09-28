---@class util.table
---@field get fun(t: table, ...: string): any
local M = {}
local TableExt = {}

---Compacts the given list-like table, removing empty/0/false/nil values
---@param tbl table<any>
---@return table<any>
function M.compact_list(tbl)
  return vim.tbl_filter(function(element)
    local t = type(element)
    if vim.tbl_contains({ "string", "table" }, t) then
      return #element > 0
    elseif t == "number" then
      return element ~= 0
    elseif t == "nil" then
      return false
    else
      return element
    end
  end, tbl)
end

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

-- function M.tbl_slice(tbl, start_idx, end_idx)
--   local ret = {}
--   if not start_idx then start_idx = 1 end
--   if not end_idx then end_idx = #tbl end
--   for i = start_idx, end_idx do
--     table.insert(ret, tbl[i])
--   end
--   return ret
-- end

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

return M

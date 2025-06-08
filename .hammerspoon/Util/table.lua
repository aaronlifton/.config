---@class hs.util.table
---@field tbl_contains fun(t: table, value: any, opts?: { predicate?: fun(v: any): boolean? }): boolean
local M = {}
M.__index = M

-- Taken from vim.tbl_contains
function M.tbl_contains(t, value, opts)
  --- @cast t table<any,any>
  local pred --- @type fun(v: any): boolean?
  if opts and opts.predicate then
    pred = value
  else
    pred = function(v)
      return v == value
    end
  end

  for _, v in pairs(t) do
    if pred(v) then return true end
  end
  return false
end

return M

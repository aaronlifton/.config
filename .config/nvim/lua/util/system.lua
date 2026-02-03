local M = {}
local _cache = {}

---@return string
function M.hostname()
  return vim.fn.hostname()
end

function M.user()
  return vim.fn.expand("$USER")
end

---@class util.system
---@field hostname fun(): string
---@field user fun(): string
local Mcache = {}
setmetatable(Mcache, {
  __index = function(_, key)
    return function()
      if _cache[key] then
        return _cache[key]
      else
        _cache[key] = M[key]()
        return _cache[key]
      end
    end
  end,
})

return Mcache

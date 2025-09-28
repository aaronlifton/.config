---@class util.system
local M = {}
local _cache = {}

---@return string|nil
function M.hostname()
  local f = io.popen("hostname")
  if not f then return nil end
  local hostname = f:read("*a")
  hostname = string.sub(hostname, 1, -2)
  f:close()
  return hostname
end

function M.user()
  return vim.fn.expand("$USER")
end

function M.sysopen()
  local sysopen
  if vim.uv.os_uname().sysname == "Darwin" then
    sysopen = "open"
  else
    sysopen = "xdg-open"
  end
end

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

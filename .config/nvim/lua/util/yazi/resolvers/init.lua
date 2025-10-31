---@class util.yazi.resolvers
local M = {}

setmetatable(M, {
  __index = function(_, key)
    local ok, module = pcall(require, "util.yazi.resolvers." .. key)
    if ok then
      return module
    else
      error("Module util.yazi.resolvers." .. key .. " not found")
    end
  end,
})

return M

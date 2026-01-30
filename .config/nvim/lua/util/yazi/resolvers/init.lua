---@class util.yazi.resolvers
local M = {}

setmetatable(M, {
  __index = function(_, key)
    local ok, module = pcall(require, "util.yazi.resolvers." .. key)
    if ok then
      return module
    else
      return nil
    end
  end,
})

return M

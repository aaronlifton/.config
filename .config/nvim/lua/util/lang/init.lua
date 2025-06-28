---@class util.lang
---@field go util.lang.go
local M = {
  go = require("util.lang.go"),
}

-- Metatable to enable direct access to nested functions
setmetatable(M, {
  __index = function(t, k)
    -- First, try to find it as a direct submodule
    local success, module = pcall(require, "util.lang.go." .. k)
    if success then
      t[k] = module
      return module
    end
    
    -- If not a direct submodule, check if it's a function in a nested module
    -- For example: util.lang.prepare_ginkgo_command_from_clipboard should find
    -- the function in util.lang.go.ginkgo.prepare_ginkgo_command_from_clipboard
    
    -- Check if the function exists in go.ginkgo or any other nested module
    if t.go and t.go.ginkgo and t.go.ginkgo[k] then
      -- Return the function directly
      return t.go.ginkgo[k]
    end
    
    -- Check if it exists in other go submodules
    if t.go and t.go[k] then
      return t.go[k]
    end
    
    -- If we reach here, the key doesn't exist
    return nil
  end,
})

return M

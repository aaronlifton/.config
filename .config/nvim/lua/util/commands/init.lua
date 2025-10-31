local M = {}

setmetatable(M, {
  __index = function(_, module)
    local ok, cmd = pcall(require, ("util.commands.%s"):format(module))
    if ok then
      rawset(M, module, cmd)
      return cmd
    else
      error(("Module 'util.commands.%s' not found"):format(module))
    end
  end,
})

return M

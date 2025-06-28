local autocmds = require("config.abstract.autocmds")
local mappings = require("config.abstract.mappings")
local M = {}

-- Set metatable to allow requiring autocmds from the same directory
setmetatable(M, {
  __index = function(_, key)
    if key == "autocmds" then
      return autocmds
    elseif key == "mappings" then
      return mappings
    end
    return nil
  end,
})

function M.setup(opts)
  if opts == nil then return end

  local commands = vim.tbl_extend("force", autocmds, mappings)

  for key, value in pairs(opts) do
    if value then
      -- if no option is passed
      if value == true then
        commands[key]()
        goto continue
      end
      -- if option is passed
      if value.enable then commands[key](value.opts) end
    end
    ::continue::
  end
end

return M

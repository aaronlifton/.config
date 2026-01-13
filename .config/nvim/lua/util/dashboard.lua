local M = {}

local pad = string.rep(" ", 22)

--- Creates a new section for mini.starter dashboard
---@param name string
---@param action string
---@param section string
M.new_section = function(name, action, section)
  return { name = name, action = action, section = pad .. section }
end

setmetatable(M, {
  __index = function(t, k)
    local picker = require("util.minipick_registry.picker")
    if picker[k] ~= nil then
      t[k] = picker[k]
      return t[k]
    end

    ---@diagnostic disable-next-line: no-unknown
    t[k] = require("util." .. k)
    return rawget(t, k)
  end,
})

return M

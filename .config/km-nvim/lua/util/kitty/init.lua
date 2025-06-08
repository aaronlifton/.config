---@class util.kitty
---@field cmd fun(args: string[]): string
local M = {}

---@param args string[]
function M.cmd(args)
  return vim.fn.system({
    "kitty",
    unpack(args),
  })
end
---
---@param cmd string
---@param args? string[]
function M.rc(cmd, args)
  return vim.fn.system({
    "kitty",
    "@",
    cmd,
    args and unpack(args) or nil,
  })
end

---@param name string
---@param args? string[]
---@param opts? table<string, string>
function M.kitten(name, args)
  return vim.fn.system({
    "kitty",
    "@",
    "kitten",
    name,
    args and unpack(args) or nil,
  })
end

return M

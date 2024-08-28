---@class util.path
---@field current_abs_path fun():string
---@field current_rel_path fun():string
---@field file_line fun():string
---@field echo fun(string)
---@field set_clipboard fun(string)
---@field copy_abs_file_line fun():string
---@field copy_rel_file_line fun():string
local M = {}

M.current_abs_path = function()
  return vim.fn.expand("%:p")
end

M.current_rel_path = function()
  local abs_path = vim.fn.expand("%:p")
  return vim.fn.fnamemodify(abs_path, ":.")
end

M.rel_file_line = function()
  local rel_path = M.current_rel_path()
  local current_line = vim.fn.line(".")
  return rel_path .. ":" .. tostring(current_line)
end

M.abs_file_line = function()
  local rel_path = M.current_abs_path()
  local current_line = vim.fn.line(".")
  return rel_path .. ":" .. tostring(current_line)
end

M.set_clipboard = function(str)
  vim.api.nvim_call_function("setreg", { "+", str })
end

M.echo = function(path)
  vim.api.nvim_echo({
    { "Current path\n", "Title" },
    { path, "Normal" },
  }, false, {})
end

M.copy_abs_path = function()
  local abs_path = M.current_abs_path()
  M.set_clipboard(abs_path)
end

M.copy_rel_path = function()
  local rel_path = M.current_rel_path()
  M.set_clipboard(rel_path)
end

M.copy_rel_file_line = function()
  local file_line = M.rel_file_line()
  M.set_clipboard(file_line)
end

M.copy_abs_file_line = function()
  local file_line = M.abs_file_line()
  M.set_clipboard(file_line)
end

M.echo_abs_path = function()
  local abs_path = M.current_abs_path()
  M.echo(abs_path)
end

M.echo_rel_path = function()
  local rel_path = M.current_rel_path()
  M.echo(rel_path)
end

return M

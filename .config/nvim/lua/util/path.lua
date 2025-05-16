---@class util.path
---@field absolute fun():string
---@field relative fun():string
---@field file_line fun():string
---@field echo fun(string)
---@field set_clipboard fun(string)
---@field copy_abs_file_line fun()
---@field copy_rel_file_line fun()
local M = {}

local function set_clipboard(str)
  vim.api.nvim_call_function("setreg", { "+", str })
end

--- Get the absolute path of the current file.
M.absolute = function()
  return vim.fn.expand("%:p")
end

-- NOTE: this has been replaced by function below
-- M.current_rel_path = function()
--   local abs_path = vim.fn.expand("%:p")
--   return vim.fn.fnamemodify(abs_path, ":.")
-- end

--- Get the relative path of the current file.
M.relative = function()
  return vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
end

M.relative_file_line = function()
  local rel_path = M.relative()
  local current_line = vim.fn.line(".")
  return rel_path .. ":" .. tostring(current_line)
end

M.absolute_file_line = function()
  local abs_path = M.absolute()
  local current_line = vim.fn.line(".")
  return abs_path .. ":" .. tostring(current_line)
end

M.echo = function(path)
  vim.api.nvim_echo({
    { "Current path\n", "Title" },
    { path, "Normal" },
  }, false, {})
end

M.copy_abs_path = function()
  local abs_path = M.absolute()
  M.echo(abs_path)
  set_clipboard(abs_path)
end

M.copy_rel_path = function()
  local rel_path = M.relative()
  M.echo(rel_path)
  set_clipboard(rel_path)
end

M.copy_rel_file_line = function()
  local file_line = M.relative_file_line()
  M.echo(file_line)
  set_clipboard(file_line)
end

M.copy_rel_pwd = function()
  local pwd = vim.fn.expand("%:p:h")
  local rel_pwd = vim.fn.fnamemodify(pwd, ":.")
  M.echo(rel_pwd)
  set_clipboard(rel_pwd)
end

M.copy_rel_pwd_rg_glob = function()
  local pwd = vim.fn.expand("%:p:h")
  local rel_pwd = vim.fn.fnamemodify(pwd, ":.")
  local rg_glob = rel_pwd .. "/**"
  M.echo(rg_glob)
  set_clipboard(rg_glob)
end

M.copy_abs_file_line = function()
  local file_line = M.absolute_file_line()
  set_clipboard(file_line)
end

return M

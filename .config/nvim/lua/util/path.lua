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

--- Convert parts table with highlight groups into a plain string
--- @param parts table Array of {text, highlight_group} pairs
--- @return string Combined text from all parts
local function parts_to_string(parts)
  local result = {}
  for _, part in ipairs(parts) do
    table.insert(result, part[1]) -- Extract just the text portion
  end
  return table.concat(result)
end

--- Alternative approach using parts structure (if you need to build complex messages)
--- @param parts table Array of {text, highlight_group} pairs
--- @param level? number|string Log level
--- @param opts? table Additional notification options
local function notify_with_parts(parts, level, opts)
  local msg = parts_to_string(parts)
  local notification_opts = vim.tbl_extend("force", {
    timeout = 2000,
    hl = {
      title = "Title",
      icon = "DiagnosticSignInfo",
      border = "FloatBorder",
      footer = "Comment",
      msg = "Normal",
    },
  }, opts or {})

  vim.notify(msg, level or vim.log.levels.INFO, notification_opts)
end

--- Example of how to use highlights with Snacks notifier
--- For Snacks notifier, use the title field and hl option instead of parts
M.echo = function(path)
  -- Use Snacks notifier with proper title and highlight options
  vim.notify(path, vim.log.levels.INFO, {
    title = "Current path",
    timeout = 2000,
    -- Custom highlight overrides if needed
    hl = {
      title = "Title", -- Use Title highlight for the title
      icon = "DiagnosticSignInfo", -- Highlight for the icon
      border = "FloatBorder", -- Highlight for the border
      footer = "Comment", -- Highlight for the footer
      msg = "Normal", -- Use Normal highlight for the message
    },
  })
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

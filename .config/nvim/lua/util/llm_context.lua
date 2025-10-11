local M = {}

---@param path string
---@param set_current_buf? boolean
---@return integer bufnr
function M.open_buffer(path, set_current_buf)
  if set_current_buf == nil then set_current_buf = true end

  local abs_path = vim.fn.fnamemodify(path, ":p")

  local bufnr ---@type integer
  if set_current_buf then
    bufnr = vim.fn.bufnr(abs_path)
    if bufnr ~= -1 and vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].modified then
      vim.api.nvim_buf_call(bufnr, function()
        vim.cmd("noautocmd write")
      end)
    end
    vim.cmd("noautocmd edit " .. abs_path)
    bufnr = vim.api.nvim_get_current_buf()
  else
    bufnr = vim.fn.bufnr(abs_path, true)
    pcall(vim.fn.bufload, bufnr)
  end

  vim.cmd("filetype detect")

  return bufnr
end

local severity = {
  [1] = "ERROR",
  [2] = "WARNING",
  [3] = "INFORMATION",
  [4] = "HINT",
}
---@class AvanteDiagnostic
---@field content string
---@field start_line number
---@field end_line number
---@field severity string
---@field source string

---@param bufnr integer
---@return AvanteDiagnostic[]
function M.get_diagnostics(bufnr)
  if bufnr == nil then bufnr = vim.api.nvim_get_current_buf() end
  local diagnositcs = ---@type vim.Diagnostic[]
    vim.diagnostic.get(bufnr, {
      severity = {
        vim.diagnostic.severity.ERROR,
        vim.diagnostic.severity.WARN,
        vim.diagnostic.severity.INFO,
        vim.diagnostic.severity.HINT,
      },
    })
  return vim
    .iter(diagnositcs)
    :map(function(diagnostic)
      local d = {
        content = diagnostic.message,
        start_line = diagnostic.lnum + 1,
        end_line = diagnostic.end_lnum and diagnostic.end_lnum + 1 or diagnostic.lnum + 1,
        severity = severity[diagnostic.severity],
        source = diagnostic.source,
      }
      return d
    end)
    :totable()
end

function M.bufnr_diagnostics(bufnr)
  local diagnostics = M.get_diagnostics(bufnr)
  return diagnostics
end

return M

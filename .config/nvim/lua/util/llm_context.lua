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

function M.curline_diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local curline = cursor[1]
  local diagnostics = M.get_diagnostics(bufnr)
  return vim
    .iter(diagnostics)
    :filter(function(diagnostic)
      return diagnostic.start_line <= curline and diagnostic.end_line >= curline
    end)
    :totable()
end

function M.visual_selection_diagnostics()
  local bufnr = vim.api.nvim_get_current_buf()
  local start_line = vim.fn.getpos("'<")[2]
  local end_line = vim.fn.getpos("'>")[2]
  local buf_diagnostics = M.get_diagnostics(bufnr)

  local diagnostics
  vim
    .iter(buf_diagnostics)
    :filter(function(diagnostic)
      return not (diagnostic.end_line < start_line or diagnostic.start_line > end_line)
    end)
    :totable()

  local diaglist = M.diagnostics_to_markdown(diagnostics)
  local filepath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
  if filepath == "" then return end
  local start_line = vim.fn.getpos("'<")[2]
  local end_line = vim.fn.getpos("'>")[2]

  -- Format reference
  local reference
  if start_line == end_line then
    reference = string.format("@%s#L%d", filepath, start_line)
  else
    reference = string.format("@%s#L%d-L%d", filepath, start_line, end_line)
  end

  return reference .. "\n" .. diaglist
end

function M.diagnostics_to_markdown(diagnostics)
  local lines = {}
  for _, diag in ipairs(diagnostics) do
    table.insert(lines, string.format("- [%s] %s", diag.severity, diag.content))
  end
  return table.concat(lines, "\n")
end

M.codex = {
  yank_line_with_diagnostics = function()
    -- First, yank the current line to trigger TextYankPost
    vim.cmd('normal! "+y')

    -- Get file path
    local filepath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
    if filepath == "" then return end

    -- Get the current line number
    local line = vim.fn.line(".")

    -- Format reference
    local reference = string.format("@%s#L%d", filepath, line)

    -- Get diagnostics for the current line
    local diagnostics = M.curline_diagnostics()
    local diag_texts = {}
    for _, diag in ipairs(diagnostics) do
      table.insert(diag_texts, string.format("[%s] %s", diag.severity, diag.content))
    end
    local diag_content = table.concat(diag_texts, "\n")

    -- Prepare text to yank
    local text_to_yank = reference .. "\n"
    if diag_content ~= "" then text_to_yank = text_to_yank .. diag_content .. "\n" end

    -- Replace clipboard content
    vim.fn.setreg("+", text_to_yank)
    vim.fn.setreg("*", text_to_yank)

    vim.notify("Copied with diagnostics: " .. reference, vim.log.levels.INFO, { title = "Yank for Codex" })
  end,
  yank_selection_with_diagnostics = function()
    -- First, yank the visual selection to trigger TextYankPost
    vim.cmd('normal! "+y')

    -- Get file path
    local filepath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
    if filepath == "" then return end

    -- Get the visual selection range
    local start_line = vim.fn.getpos("'<")[2]
    local end_line = vim.fn.getpos("'>")[2]

    -- Format reference
    local reference
    if start_line == end_line then
      reference = string.format("@%s#L%d", filepath, start_line)
    else
      reference = string.format("@%s#L%d-L%d", filepath, start_line, end_line)
    end

    -- Get diagnostics for the visual selection
    local diagnostics = M.visual_selection_diagnostics()

    -- Prepare text to yank
    local text_to_yank = reference .. "\n" .. diagnostics

    -- Replace clipboard content
    vim.fn.setreg("+", text_to_yank)
    vim.fn.setreg("*", text_to_yank)

    vim.notify("Copied selection with diagnostics: " .. reference, vim.log.levels.INFO, { title = "Yank for Codex" })
  end,
  yank_line = function(with_content)
    with_content = with_content or false
    vim.cmd('normal! "+y')

    -- Get file path
    local filepath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
    if filepath == "" then return end

    -- Get the visual selection range
    local start_line = vim.fn.getpos("'<")[2]
    local end_line = vim.fn.getpos("'>")[2]

    -- Format reference
    local reference
    if start_line == end_line then
      reference = string.format("@%s#L%d", filepath, start_line)
    else
      reference = string.format("@%s#L%d-L%d", filepath, start_line, end_line)
    end

    -- Get the actual code content
    local text_to_yank
    if with_content then
      local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
      local content = table.concat(lines, "\n")
      text_to_yank = reference .. "\n" .. content
    else
      text_to_yank = reference .. "\n"
    end

    -- Replace clipboard content
    vim.fn.setreg("+", text_to_yank)
    vim.fn.setreg("*", text_to_yank)

    if with_content then
      vim.notify("Copied with content: " .. reference, vim.log.levels.INFO, { title = "Yank for Codex" })
    else
      vim.notify("Copied reference: " .. reference, vim.log.levels.INFO, { title = "Yank for Codex" })
    end
  end,
}

return M

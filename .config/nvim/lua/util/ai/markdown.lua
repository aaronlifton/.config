---@class util.ai.markdown
local M = {}

-- Example context
-- {
--   bufnr = 7,
--   buftype = "",
--   cursor_pos = { 10, 3 },
--   end_col = 3,
--   end_line = 10,
--   filetype = "lua",
--   is_normal = false,
--   is_visual = true,
--   lines = { "local function fire_autocmd(status)", '  vim.api.nvim_exec_autocmds("User", { pattern = "CodeCompanionInline", data = { status = status } })', "end" },
--   mode = "V",
--   start_col = 1,
--   start_line = 8,
--   winnr = 1000
-- }

--- Write a markdown code fence with the current selection.
---@param context table
M.markdown_code_fence = function(context)
  local filename = vim.fn.bufname(context.bufnr)

  local position = string.format("(%s-%s)", context.start_line, context.end_line)
  local normalized_lines = require("util.selection").normalize_indentation(context.lines)
  local code = vim.iter(normalized_lines):join("\n")
  return string.format(
    "File: `%s` %s\n```%s\n%s\n```\n\n",
    vim.fn.fnamemodify(filename, ":~:."),
    position,
    context.filetype,
    code
  )
end
return M

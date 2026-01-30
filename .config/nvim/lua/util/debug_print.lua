---@class util.debug_print
local M = {}

M.log_cword = function()
  local buf = vim.api.nvim_get_current_buf()
  local word = vim.fn.expand("<cword>")
  local filetype = vim.bo.filetype
  local new_row
  if filetype == "lua" then
    new_row = ('vim.api.nvim_echo({{ "%s\\n", "Title"}, { vim.inspect(%s), "Normal" } }, true, {})'):format(word, word)
  elseif vim.list_contains({ "javascript", "javascriptreact", "typescript", "typescriptreact" }, filetype) then
    new_row = ("console.log('### %s: ', { %s })"):format(word, word)
  elseif filetype == "ruby" then
    new_row = ('Rails.logger.info("%s")'):format(word)
  else
    vim.notify("Unsupported filetype", vim.log.levels.INFO, { title = "Debug Print" })
    return
  end

  local pos = vim.api.nvim_win_get_cursor(0)
  local row = pos[1]
  local col = pos[2]
  local function cb(scope) end
  Snacks.scope.get(cb, {
    buf = buf,
    pos = {
      row,
      col,
    },
    treesitter = {
      enabled = true,
      blocks = {
        "function_declaration",
        "function_definition",
        "method_declaration",
        "method_definition",
        "class_declaration",
        "class_definition",
        "do_statement",
        "while_statement",
        "repeat_statement",
        "if_statement",
        "for_statement",
      },
    },
  })
end

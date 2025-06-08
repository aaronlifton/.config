-- When creating a new line with o, make sure there is a trailing comma on the current line
vim.keymap.set("n", "o", function()
  local line = vim.api.nvim_get_current_line()

  local should_add_comma = string.find(line, "[^,{[]$")
  if should_add_comma then
    return "A,<cr>"
  else
    return "o"
  end
end, { buffer = true, expr = true })

-- vim.opt_local.foldmethod = "indent"
-- vim.opt_local.cursorline = false
-- vim.opt_local.cursorcolumn = false
-- vim.opt_local.signcolumn = "yes"
-- vim.opt_local.conceallevel = 0
-- vim.bo.suffixesadd = ".json"
--
-- if vim.fn.executable("jq") == 1 then
--    vim.bo.formatprg = "jq"
-- end

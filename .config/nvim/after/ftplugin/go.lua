vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = false

vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.go",
  callback = function()
    local ai = require("mini.ai")
    vim.b.miniai_config = {
      custom_textobjects = {
        P = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
      },
    }
  end,
})

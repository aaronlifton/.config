vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = false

LazyVim.lsp.on_attach(function(_, _)
  vim.lsp.inlay_hint.enable(false, { bufnr = 0 })
end, "gopls")

if LazyVim.has("mini.ai") then
  local ai = require("mini.ai")
  vim.b.miniai_config = {
    custom_textobjects = {
      P = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
    },
  }
end

vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = false

Util.lazy.lsp.on_attach(function(_, _)
  -- Nightly feature
  vim.lsp.inlay_hint.enable(false, { bufnr = 0 })
end, "gopls")

if Util.lazy.has_plugin("mini.ai") then
  local ai = require("mini.ai")
  vim.b.miniai_config = {
    custom_textobjects = {
      P = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
    },
  }
end

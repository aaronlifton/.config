-- https://joschua.io/posts/2023/06/22/set-up-nvim-for-astro/
LazyVim.on_very_lazy(function()
  vim.filetype.add({
    astro = "astro",
  })
end)
local inlay_hints_settings = {
  parameterNames = { enabled = "all" },
  parameterTypes = { enabled = true },
  variableTypes = { enabled = true },
  propertyDeclarationTypes = { enabled = true },
  functionLikeReturnTypes = { enabled = true },
  enumMemberValues = { enabled = true },
}

return {
  { import = "lazyvim.plugins.extras.lang.astro" },
  { import = "plugins.extras.lang.web.typescript-extended" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        astro = {
          settings = {
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              inlayHints = inlay_hints_settings,
            },
            javascript = {
              updateImportsOnFileMove = { enabled = "always" },
              inlayHints = inlay_hints_settings,
            },
          },
          handlers = {
            ["textDocument/publishDiagnostics"] = require("util.lsp").publish_to_ts_error_translator,
          },
        },
      },
    },
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    opts = {},
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        astro = { "eslint" },
      },
    },
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "astro",
      },
    },
  },
}

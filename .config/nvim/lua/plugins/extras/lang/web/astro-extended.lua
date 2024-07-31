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
    opts = function(_, opts)
      local lsp_util = require("util.lsp")
      lsp_util.add_linters(opts, {
        -- astro uses eslint instead of biome because eslint has astro rules
        ["astro"] = { "eslint" },
      })
    end,
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    ensure_installed = {
      "astro",
    },
  },
}

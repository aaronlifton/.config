return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = {
        "vue",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        volar = {
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
    "mason-org/mason.nvim",
    optional = true,
    opts = {
      ensure_installed = {
        "vue-language-server",
      },
    },
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "vue-3",
      },
    },
  },
}

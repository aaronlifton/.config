return {
  { import = "lazyvim.plugins.extras.lang.svelte" },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        svelte = {
          handlers = {
            ["textDocument/publishDiagnostics"] = require("util.lsp").publish_to_ts_error_translator,
          },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "svelte-language-server" })
    end,
  },
  {
    "dmmulroy/ts-error-translator.nvim",
    opts = {},
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "svelte",
      },
    },
  },
}

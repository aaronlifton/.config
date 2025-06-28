return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- "clojure-lsp", -- For Clojure development
        "cljfmt", -- For edn files
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        edn = { "cljfmt" },
      },
    },
  },

  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     servers = {
  --       clojure_lsp = {},
  --     },
  --   },
  -- },
}

return {
  -- TODO: Check if we need this
  -- { import = "lazyvim.plugins.extras.lang.docker" },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "clojure-lsp", -- For Clojure development
        "cljfmt", -- For edn files
      },
    },
  },
  { "julienvincent/nvim-paredit", opts = {}, filetype = "clojure" },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      opts.formatters_by_ft["clojure"] = opts.formatters_by_ft["clojure"] or {}
      opts.formatters_by_ft["clojure"] = { "cljfmt" }
      opts.formatters_by_ft["edn"] = { "cljfmt" }
    end,
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        clj = { "clj-kondo" },
        edn = { "clj-kondo" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clojure_lsp = {},
      },
    },
  },
}

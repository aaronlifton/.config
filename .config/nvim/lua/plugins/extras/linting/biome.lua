local lsp_util = require("util.lsp")

return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "biome" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        biome = {},
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      lsp_util.add_formatters(opts, {
        ["jsonc"] = { "biome" },
        ["json"] = { "biome" },
        ["javascript"] = { "biome" },
        ["typescript"] = { "biome" },
        ["typescriptreact"] = { "biome" },
        ["javascriptreact"] = { "biome" },
        ["astro"] = { "biome" },
        ["svelte"] = { "biome" },
        ["vue"] = { "biome" },
      })

      lsp_util.add_formatter_settings(opts, {
        biome = {
          condition = function(self, ctx)
            return vim.fs.find({ "biome.json" }, { path = ctx.filename, upward = true })[1]
          end,
        },
        prettier = {
          condition = function(self, ctx)
            return not vim.fs.find({ "biome.json" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      })

      return opts
    end,
  },
}

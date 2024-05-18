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
      -- setup = {
      --   tsserver = function(server, server_opts)
      --     require("lspconfig").biome.setup({
      --       on_attach = function(client, bufnr)
      --         return 1
      --       end,
      --     })
      --   end,
      -- },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      local lsp_util = require("util.lsp")
      local conform = require("conform")

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

      local prettier_settings = {
        condition = function(_, ctx)
          return not vim.fs.find({ "biome.json" }, { path = ctx.filename, upward = true })[1]
        end,
      }

      lsp_util.add_formatter_settings(opts, {
        biome = {
          condition = function(_, ctx)
            return vim.fs.find({ "biome.json" }, { path = ctx.filename, upward = true })[1]
          end,
        },
        prettier = prettier_settings,
        prettierd = prettier_settings,
      })
    end,
  },
  -- {
  --   "mfussenegger/nvim-lint",
  --   opts = function(_, opts)
  --     local lsp_util = require("util.lsp")
  --     lsp_util.add_linters(opts, {
  --       javascript = { "biome" },
  --       javascriptreact = { "biome" }, --stylelint
  --       typescript = { "biome" },
  --       typescriptreact = { "biome" }, --stylelint
  --     })
  --   end,
  -- },
}

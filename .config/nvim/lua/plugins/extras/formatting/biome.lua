local formatters = { "biome", "prettierd", "prettier", stop_after_first = true }
local json_formatters = { "prettierd", "prettier", "biome", stop_after_first = true }
return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "biome" },
    },
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
    opts = {
      formatters_by_ft = {
        jsonc = json_formatters,
        json = json_formatters,
        javascript = formatters,
        typescript = formatters,
        typescriptreact = formatters,
        javascriptreact = formatters,
        astro = formatters,
        svelte = formatters,
        vue = formatters,
      },
      formatters = {
        biome = {
          condition = function(_, ctx)
            return vim.fs.find({ "biome.json" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      },
    },
  },
}

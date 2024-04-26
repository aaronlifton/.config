local lsp_util = require("util.lsp")
local stylelint = "stylelint"

return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { stylelint })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      lsp_util.add_linters(opts, {
        ["html"] = { "stylelint" },
        ["css"] = { "stylelint" },
        ["scss"] = { "stylelint" },
        ["sass"] = { "stylelint" },
        ["less"] = { "stylelint" },
      })
    end,
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   ---@class PluginLspOpts
  --   opts = {
  --     ---@type lspconfig.options
  --     servers = {
  --       ---@type lspconfig.options.stylelint_lsp
  --       stylelint_lsp = {
  --         settings = {
  --           stylelintplus = {
  --             filetypes = {
  --               "javascript",
  --               "typescript",
  --             },
  --             autoFixOnSave = true,
  --             autoFixOnFormat = true,
  --             cssInJs = true,
  --             customSyntax = "@stylelint/postcss-css-in-js",
  --             validate = {
  --               "css",
  --               "less",
  --               "postcss",
  --             },
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },
}

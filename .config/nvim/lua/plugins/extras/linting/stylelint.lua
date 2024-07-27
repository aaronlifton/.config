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
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        ---@type lspconfig.options.stylelint_lsp
        -- stylelint_lsp = nil,
        stylelint_lsp = {
          filetypes = {
            "html",
            "css",
            "scss",
            "sass",
            "less",
            "astro",
            -- "sugarss",
            -- "vue",
            -- "wxss",
            -- "javascriptreact" -- for cssInJs=true
            -- "typescriptreact"
          },
          settings = {
            -- → stylelintplus.autoFixOnFormat  default: false
            -- → stylelintplus.autoFixOnSave    default: false
            -- → stylelintplus.config
            -- → stylelintplus.configFile
            -- → stylelintplus.configOverrides
            -- → stylelintplus.cssInJs          default: false
            -- → stylelintplus.enable           default: true
            -- → stylelintplus.filetypes        default: ["css","less","postcss","sass","scss","sugarss","vue","wxss"]
            -- → stylelintplus.trace.server     default: "off"
            -- → stylelintplus.validateOnSave   default: false
            -- → stylelintplus.validateOnType   default: true
            --
            -- TODO: Figure out if there is still a way to use autoFix
            -- Disabled, causes the following error:
            -- Unknown word (CssSyntaxError) stylelintplus (CssSyntaxError) [2, 0]
            stylelintplus = {
              autoFixOnSave = true,
              -- autoFixOnFormat = true,
              -- cssInJs = false,
              validate = {
                "css",
                "less",
                "postcss",
                "scss",
              },
              configOverrides = {
                -- { files = { "**/*.html", "*.js", "*.jsx", ".tsx" }, customSyntax = "postcss-html" },
                { files = { "**/*.html" }, customSyntax = "postcss-html" },
                { files = { "*.scss", "**/*.scss" }, customSyntax = "postcss-scss" },
                -- { files = "**/*.{jsx,tsx}", customSyntax = "@stylelint/postcss-css-in-js" },
              },
            },
          },
        },
      },
    },
  },
}

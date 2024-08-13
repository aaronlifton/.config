local stylelint = "stylelint"
local root_patterns = {
  ".stylelintrc",
  ".stylelintrc.cjs",
  ".stylelintrc.js",
  ".stylelintrc.json",
  ".stylelintrc.yaml",
  ".stylelintrc.yml",
  "stylelint.config.cjs",
  "stylelint.config.js",
}

return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylelint",
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        css = { stylelint },
        html = { stylelint },
        scss = { stylelint },
        sass = { stylelint },
        less = { stylelint },
      },
      linters = {
        stylelint = {
          condition = function(ctx)
            return vim.fs.find(root_patterns, { path = ctx.filename, upward = true })[1]
          end,
        },
      },
    },
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
          -- filetypes_exclude = { "javascript" },
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

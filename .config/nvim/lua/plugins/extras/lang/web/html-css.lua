return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = {
        "html",
        "css",
        "scss",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        emmet_language_server = {
          init_options = {
            html = {
              options = {
                -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                ["bem.enabled"] = true,
              },
            },
          },
          -- See ~/.local/share/nvim/lazy/nvim-lspconfig/lsp/emmet_language_server.lua
          -- and ~/.local/share/nvim/lazy/mason-lspconfig.nvim/lua/mason-lspconfig/filetype_mappings.lua
        },
        emmet_ls = {
          enabled = false,
        },
        html = {},
        cssmodules_ls = {},
        css_variables = {},
        cssls = {
          lint = {
            compatibleVendorPrefixes = "ignore",
            vendorPrefix = "ignore",
            unknownVendorSpecificProperties = "ignore",
            -- unknownProperties = "ignore", -- duplicate with "stylelint"
            duplicateProperties = "warning",
            emptyRules = "warning",
            importStatement = "warning",
            zeroUnits = "warning",
            fontFaceProperties = "warning",
            hexColorLength = "warning",
            argumentsInColorFunction = "warning",
            unknownAtRules = "warning",
            ieHack = "warning",
            propertyIgnoredDueToDisplay = "warning",
          },
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = {
      ensure_installed = {
        "emmet-language-server",
        "html-lsp",
        "cssmodules-language-server",
        "css-variables-language-server",
        "css-lsp",
        "htmlhint",
        "stylelint",
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        html = { "htmlhint" },
        css = { "stylelint" },
        scss = { "stylelint" },
        less = { "stylelint" },
        sugarss = { "stylelint" },
        vue = { "stylelint" },
        wxss = { "stylelint" },
        -- javascript = { "stylelint" },
        -- javascriptreact = { "stylelint" },
        -- typescript = { "stylelint" },
        -- typescriptreact = { "stylelint" },
      },
    },
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "html",
        "css",
        "sass",
      },
    },
  },
}

local html_filetypes = {
  "html",
  "javascriptreact",
  "javascript.jsx",
  "typescriptreact",
  "typescript.tsx",
  -- "css",
  "eruby",
  -- "less",
  -- "sass",
  -- "scss",
  "svelte",
  -- "pug",
  "vue",
  "astro",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "html",
        "css",
        "scss",
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- emmet_language_server = {},
        emmet_ls = {
          filetypes = html_filetypes,
          init_options = {
            html = {
              options = {
                -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                ["bem.enabled"] = true,
              },
            },
          },
        },
        html = {
          -- Don't really need this LS
          -- filetypes = html_filetypes,
        },
        cssmodules_ls = {
          -- --- Use :LspStart cssmodules_ls to start this
          -- autostart = false,
          --
          -- ---note: local on_attach happens AFTER autocmd LspAttach
          -- on_attach = function(client)
          --   -- https://github.com/davidosomething/dotfiles/issues/521
          --   -- https://github.com/antonk52/cssmodules-language-server#neovim
          --   -- avoid accepting `definitionProvider` responses from this LSP
          --   client.server_capabilities.definitionProvider = false
          -- end,
        },
        css_variables = {},
        cssls = {
          lint = {
            compatibleVendorPrefixes = "ignore",
            vendorPrefix = "ignore",
            unknownVendorSpecificProperties = "ignore",

            -- unknownProperties = "ignore", -- duplicate with stylelint

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
      setup = {
        emmet_ls = function(_, opts)
          opts.capabilities.textDocument.completion.completionItem.snippetSupport = true
        end,
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "emmet-ls", -- "emmet-language-server",
        "html-lsp",
        "cssmodules-language-server",
        "css-variables-language-server",
        "css-lsp",
        "htmlhint",
        "stylelint",
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local lsp_util = require("util.lsp")

      lsp_util.add_linters(opts, {
        ["html"] = { "htmlhint" },
        ["css"] = { "stylelint" },
        ["scss"] = { "stylelint" },
        ["less"] = { "stylelint" },
        ["sugarss"] = { "stylelint" },
        ["vue"] = { "stylelint" },
        ["wxss"] = { "stylelint" },
        -- ["javascript"] = { "eslint", "stylelint" },
        ["javascriptreact"] = { "eslint", "stylelint" },
        ["typescript"] = { "eslint", "stylelint" },
        ["typescriptreact"] = { "eslint", "stylelint" },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      local lsp_util = require("util.lsp")

      lsp_util.add_formatters(opts, {
        ["css"] = { "prettier" },
        ["scss"] = { "prettier" },
        ["module.css"] = { "prettier" },
      })
    end,
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    ensure_installed = {
      "html",
      "css",
      "sass",
    },
  },
  {
    "dcampos/cmp-emmet-vim",
    keys = {
      {
        "<c-y>",
        mode = "i",
        desc = "Emmet expansion in insert mode (you probably need to type `<c-y>,`)",
      },
    },
    dependencies = {
      {
        "mattn/emmet-vim",
        config = function()
          -- expand emmet snippet with <c-y>,
          vim.g.user_emmet_leader_key = "<C-y>"
        end,
      },
    },
  },
}

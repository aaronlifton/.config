local stylelint = "stylelint"

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
          filetypes = { "html", "javascript" },
        },
        -- emmet_ls = {
        --   filetypes = {
        --     "html",
        --     "javascriptreact",
        --     "javascript.jsx",
        --     "typescriptreact",
        --     "typescript.tsx",
        --     "eruby",
        --     "svelte",
        --     "vue",
        --     "astro",
        --   },
        --   init_options = {
        --     html = {
        --       options = {
        --         -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
        --         ["bem.enabled"] = true,
        --       },
        --     },
        --   },
        -- },
        html = {},
        cssmodules_ls = {},
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
      -- setup = {
      --   emmet_ls = function(_, opts)
      --     opts.capabilities.textDocument.completion.completionItem.snippetSupport = true
      --   end,
      -- },
    },
  },
  {
    "williamboman/mason.nvim",
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
        css = { stylelint },
        scss = { stylelint },
        less = { stylelint },
        sugarss = { stylelint },
        vue = { stylelint },
        wxss = { stylelint },
        -- javascript = { stylelint },
        -- javascriptreact = { stylelint },
        -- typescript = { stylelint },
        -- typescriptreact = { stylelint },
      },
    },
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
  -- Replaced by emmet_language_server
  -- {
  --   "nvim-cmp",
  --   optional = true,
  --   dependencies = {
  --     -- codeium
  --     {
  --       "dcampos/cmp-emmet-vim",
  --       enabled = false,
  --       keys = {
  --         {
  --           "<c-y>",
  --           mode = "i",
  --           desc = "Emmet expansion in insert mode (you probably need to type `<c-y>,`)",
  --         },
  --       },
  --       dependencies = {
  --         {
  --           "mattn/emmet-vim",
  --           -- config = function()
  --           --   -- expand emmet snippet with <c-y>,
  --           --   vim.g.user_emmet_leader_key = "<C-y>"
  --           -- end,
  --         },
  --       },
  --     },
  --   },
  --   ---@param opts cmp.ConfigSchema
  --   opts = function(_, opts)
  --     if LazyVim.has("cmp-emmet-vim") then
  --       table.insert(opts.sources, 1, {
  --         name = "emmet_vim",
  --       })
  --     end
  --   end,
  -- },
}

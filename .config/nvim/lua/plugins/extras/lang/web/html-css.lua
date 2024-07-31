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
    opts = {
      servers = {
        emmet_language_server = {},
        -- emmet_ls = {
        --   filetypes = html_filetypes,
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
    opts = function(_, opts)
      local lsp_util = require("util.lsp")

      local stylelint = "stylelint"
      lsp_util.add_linters(opts, {
        ["html"] = { "htmlhint" },
        ["css"] = { stylelint },
        ["scss"] = { stylelint },
        ["less"] = { stylelint },
        ["sugarss"] = { stylelint },
        ["vue"] = { stylelint },
        ["wxss"] = { stylelint },
        ["javascript"] = { stylelint },
        ["javascriptreact"] = { stylelint },
        ["typescript"] = { stylelint },
        ["typescriptreact"] = { stylelint },
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
    "nvim-cmp",
    dependencies = {
      -- codeium
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
            -- config = function()
            --   -- expand emmet snippet with <c-y>,
            --   vim.g.user_emmet_leader_key = "<C-y>"
            -- end,
          },
        },
      },
    },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      table.insert(opts.sources, 1, {
        name = "emmet_vim",
      })
    end,
  },
}

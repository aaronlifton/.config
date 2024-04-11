local html_filetypes = {
  "html",
  "javascriptreact",
  "javascript.jsx",
  "typescriptreact",
  "typescript.tsx",
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
        emmet_language_server = {},
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
          filetypes = html_filetypes,
        },
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
        "emmet-language-server",
        "html-lsp",
        "cssmodules-language-server",
        "css-lsp",
        "htmlhint",
        "stylelint",
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local stylelint = "stylelint"

      local function add_linters(tbl)
        for ft, linters in pairs(tbl) do
          if opts.linters_by_ft[ft] == nil then
            opts.linters_by_ft[ft] = linters
          else
            vim.list_extend(opts.linters_by_ft[ft], linters)
          end
        end
      end

      add_linters({
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

-- TODO: https://github.com/ngalaiko/tree-sitter-go-template

return {
  { import = "lazyvim.plugins.extras.lang.go" },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- "golangci-lint", -- Installed v1 locally
        "golangci-lint-langserver",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- https://github.com/nametake/golangci-lint-langserver/issues/60
        -- https://github.com/nvimtools/none-ls.nvim/commit/2f6a433e62d0fab6a03dadf2c207fcbe409416c4
        golangci_lint_ls = {
          init_options = {
            -- nvim-lspconfig @ b542bd594a8b9ab76926721e9815ec4b0b1b3c16
            command = { "golangci-lint", "run", "--out-format", "json" },
            -- command = { "golangci-lint", "run", "--out-format=json", "--show-stats=false" },
          },
        },
        gopls = {
          settings = {
            -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
            gopls = {
              gofumpt = false,
              buildFlags = { "-tags", "integration,unit,build" },
            },
          },
        },
      },
    },
  },
  -- {
  --   "nvim-neotest/neotest",
  --   dependencies = {
  --     "nvim-contrib/nvim-ginkgo",
  --   },
  --   opts = {
  --     adapters = {
  --       ["nvim-ginkgo"] = {},
  --     },
  --   },
  -- },
  -- {
  --   "mfussenegger/nvim-lint",
  --   optional = true,
  --   opts = {
  --     linters_by_ft = {
  --       go = { "golangcilint" },
  --       gomod = { "golangcilint" },
  --       gowork = { "golangcilint" },
  --     },
  --   },
  -- },
  --
  -- LazyVim sets this as { "goimports", "gofumpt" }
  -- {
  --   "stevearc/conform.nvim",
  --   opts = {
  --     formatters_by_ft = {
  --       go = { "gofmt" },
  --     },
  --   },
  -- },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "go",
      },
    },
  },
  {
    "ray-x/go.nvim",
    enabled = false,
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    ft = { "go", "gomod" },
    build = function()
      require("go.install").update_all_sync()
      require("go").setup({
        lsp_keymaps = false,
        dap_debug_keymap = false,
        icons = false,
        gofmt = "gopls",
        goimports = "gopls",
        lsp_gofumpt = "true",
        lup_inlay_hints = { enable = false },
        lsp_codelens = { enable = false },
        run_in_floaterm = true,
        trouble = true,
        lsp_cfg = {
          flags = { debounce_text_changes = 500 },
          cmd = { "gopls", "-remote=auto" },
          settings = {
            gopls = {
              usePlaceholders = true,
              analyses = {
                nilness = true,
                shadow = true,
                unusedparams = true,
                unusewrites = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
      })
    end,
  },
  -- {
  --   "yanskun/gotests.nvim",
  --   ft = "go",
  --   config = function()
  --     require("gotests").setup()
  --   end,
  -- },
}

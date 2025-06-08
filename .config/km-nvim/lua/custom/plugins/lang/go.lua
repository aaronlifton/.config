-- TODO: https://github.com/ngalaiko/tree-sitter-go-template

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "go", "gomod", "gowork", "gosum" } },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gopls = {
          settings = {
            gopls = {
              -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
              gofumpt = false,
              buildFlags = { "-tags", "integration,unit,build" },
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
        -- https://github.com/nametake/golangci-lint-langserver/issues/60
        -- https://github.com/nvimtools/none-ls.nvim/commit/2f6a433e62d0fab6a03dadf2c207fcbe409416c4
        golangci_lint_ls = {
          init_options = {
            command = { "golangci-lint", "run", "--out-format", "json" },
          },
        },
      },
      setup = {
        gopls = function(_, opts)
          -- workaround for gopls not supporting semanticTokensProvider
          -- https://github.com/golang/go/issues/54531#issuecomment-1464982242
          Util.lazy.lsp.on_attach(function(client, _)
            if not client.server_capabilities.semanticTokensProvider then
              local semantic = client.config.capabilities.textDocument.semanticTokens
              client.server_capabilities.semanticTokensProvider = {
                full = true,
                legend = {
                  tokenTypes = semantic.tokenTypes,
                  tokenModifiers = semantic.tokenModifiers,
                },
                range = true,
              }
            end
          end, "gopls")
          -- end workaround
        end,
      },
    },
  },
  -- Ensure Go tools are installed
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "goimports", "gofumpt" } },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
      },
    },
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = { ensure_installed = { "delve" } },
      },
      {
        "leoluz/nvim-dap-go",
        opts = {},
      },
    },
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "fredrikaverpil/neotest-golang",
    },
    opts = {
      adapters = {
        ["neotest-golang"] = {
          -- Here we can set options for neotest-golang, e.g.
          -- go_test_args = { "-v", "-race", "-count=1", "-timeout=60s" },
          dap_go_enabled = true, -- requires leoluz/nvim-dap-go
        },
      },
    },
  },

  -- Filetype icons
  {
    "echasnovski/mini.icons",
    opts = {
      file = {
        [".go-version"] = { glyph = "", hl = "MiniIconsBlue" },
      },
      filetype = {
        gotmpl = { glyph = "󰟓", hl = "MiniIconsGrey" },
      },
    },
  },
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
    opts = {},
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
  -- Util.lazy sets this as { "goimports", "gofumpt" }
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

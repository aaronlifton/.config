local ts_server_activated = true -- Change this variable to false if you want to use typescript-tools instead of lspconfig tsserver implementation
local ft = { "typescript", "typescriptreact", "javascript", "javascriptreact" }

local tsInlayHints = {
  includeInlayParameterNameHints = "literal",
  includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = false,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
}
local inlayHints = {
  includeInlayParameterNameHints = "all",
  includeInlayParameterNameHintsWhenArgumentMatchesName = true,
  includeInlayFunctionParameterTypeHints = true,
  includeInlayVariableTypeHints = true,
  includeInlayVariableTypeHintsWhenTypeMatchesName = true,
  includeInlayPropertyDeclarationTypeHints = true,
  includeInlayFunctionLikeReturnTypeHints = true,
  includeInlayEnumMemberValueHints = true,
}

local source_action = function(name)
  return function()
    vim.lsp.buf.code_action({
      apply = true,
      context = {
        only = { string.format("source.%s.ts", name) },
        diagnostics = {},
      },
    })
  end
end

return {
  { import = "lazyvim.plugins.extras.lang.typescript" },
  { import = "plugins.extras.lang.json-extended" },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "deno" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        tsserver = {
          handlers = {
            ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
              require("ts-error-translator").translate_diagnostics(err, result, ctx, config)
              vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
            end,
          },
          enabled = ts_server_activated,
          init_options = {
            preferences = {
              disableSuggestions = true,
            },
          },
          -- root_dir = function(...)
          --   return require("lspconfig.util").root_pattern(".git")(...)
          -- end,
          -- single_file_support = false,
          settings = {
            typescript = {
              inlayHints = tsInlayHints,
              implementationsCodeLens = {
                enabled = true,
              },
              referencesCodeLens = {
                enabled = true,
                showOnAllFunctions = true,
              },
            },
            javascript = {
              inlayHints = inlayHints,
              implementationsCodeLens = {
                enabled = true,
              },
              referencesCodeLens = {
                enabled = true,
                showOnAllFunctions = true,
              },
            },
          },
          keys = {
            {
              "<leader>co",
              source_action("organizeImports"),
              desc = "Organize Imports",
            },
            {
              "<leader>cM",
              source_action("addMissingImports"),
              desc = "Add Missing Imports",
            },
            {
              "<leader>cR",
              source_action("removeUnused"),
              desc = "Remove Unused Imports",
            },
          },
        },
        denols = {},
      },
      setup = {
        tsserver = function(server, server_opts)
          require("lspconfig").tsserver.setup({
            on_attach = function(client, bufnr)
              require("lsp_signature").on_attach({ hint_prefix = "" })
              vim.api.nvim_echo({
                { "TSServer activated", "Type" },
                { "Collecting workspace diagnostics", "DiagnosticWarn" },
              }, false, {})
              require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
            end,
          })
        end,
      },
    },
  },
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    enabled = not ts_server_activated,
    ft = ft,
    opts = {
      cmd = { "typescript-language-server", "--stdio" },
      settings = {
        code_lens = "all",
        expose_as_code_action = "all",
        tsserver_plugins = {
          "@styled/typescript-styled-plugin",
        },
        tsserver_file_preferences = {
          completions = {
            completeFunctionCalls = true,
          },
          init_options = {
            preferences = {
              disableSuggestions = true,
            },
          },
          includeInlayParameterNameHints = "all",
          includeInlayEnumMemberValueHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayVariableTypeHints = true,
        },
      },
    },
    keys = {
      { "<leader>cO", ft = ft, "<cmd>TSToolsOrganizeImports<cr>", desc = "Organize Imports" },
      { "<leader>cR", ft = ft, "<cmd>TSToolsRemoveUnusedImports<cr>", desc = "Remove Unused Imports" },
      { "<leader>cM", ft = ft, "<cmd>TSToolsAddMissingImports<cr>", desc = "Add Missing Imports" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "javascript",
        "jsdoc",
      })
    end,
  },
  {
    "dmmulroy/tsc.nvim",
    opts = {
      auto_start_watch_mode = false,
      use_trouble_qflist = true,
      flags = {
        watch = false,
      },
    },
    keys = {
      { "<leader>ct", ft = { "typescript", "typescriptreact" }, "<cmd>TSC<cr>", desc = "Type Check" },
      { "<leader>xy", ft = { "typescript", "typescriptreact" }, "<cmd>TSCOpen<cr>", desc = "Type Check Quickfix" },
    },
    ft = {
      "typescript",
      "typescriptreact",
    },
    cmd = {
      "TSC",
      "TSCOpen",
      "TSCClose",
    },
  },
  -- {
  --   "dmmulroy/ts-error-translator.nvim",
  --   ft = { "typescript", "typescriptreact" },
  --   dependencies = {
  --     "neovim/nvim-lspconfig",
  --     opts = {
  --       servers = {
  --         tsserver = {
  --           handlers = {
  --             ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
  --               require("ts-error-translator").translate_diagnostics(err, result, ctx, config)
  --               vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
  --             end,
  --           },
  --         },
  --       },
  --     },
  --   },
  --   opts = {},
  -- },
  {
    "dmmulroy/ts-error-translator.nvim",
    opts = {},
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "nvim-neotest/neotest-jest",
      "adrigzr/neotest-mocha",
      "marilari88/neotest-vitest",
      "thenbe/neotest-playwright",
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      vim.list_extend(opts.adapters, {
        require("neotest-jest")({
          jestCommand = "npm test --",
          jestConfigFile = "custom.jest.config.ts",
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        }),
        require("neotest-mocha")({
          command = "npm test --",
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        }),
        require("neotest-vitest")({
          env = { CI = true },
          cwd = function()
            return vim.fn.getcwd()
          end,
        }),
      })
      opts.consumers = opts.consumers or {}
      vim.list_extend(opts.consumers, {
        -- add to your list of consumers
        playwright = require("neotest-playwright.consumers").consumers,
      })
    end,
    -- stylua: ignore
    keys = {
      { "<leader>tw", function() require('neotest').run.run({ jestCommand = 'jest --watch ' }) end, desc = "Run Watch" },
    },
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    ensure_installed = {
      "react",
      "typescript",
    },
  },
}

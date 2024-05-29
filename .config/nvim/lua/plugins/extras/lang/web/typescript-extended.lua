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
  -- {
  --   "folke/which-key.nvim",
  --   opts = {
  --     defaults = {
  --       ["<leader>co"] = { name = "Organize Imports" },
  --       ["<leader>cM"] = { name = "Add Missing Imports" },
  --       ["<leader>cR"] = { name = "Remove Unused Imports" },
  --     },
  --   },
  -- },
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
  {
    "dmmulroy/ts-error-translator.nvim",
    opts = {},
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "adrigzr/neotest-mocha",
      "nvim-neotest/neotest-jest",
      "marilari88/neotest-vitest",
      "thenbe/neotest-playwright",
    },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      vim.list_extend(opts.adapters, {
        require("neotest-jest")({
          jestCommand = "npm test --", -- "npx jest"
          jestConfigFile = "custom.jest.config.ts",
          -- jestConfigFile = function(file)
          --   -- Find the jest config in monorepo projects
          --   if string.find(file, "/(apps|libs|features)/") then
          --     return string.match(file("(.-/[^/]+/)src")) .. "jest.config.ts"
          --   end
          -- end,
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
          filter_dir = function(name, rel_path, dir)
            -- Tests is reserved for Playwright
            return name ~= "tests" -- and name ~= "node_modules"
          end,
          extra_args = {
            filter_dir = function(name, rel_path, dir)
              -- Tests is reserved for Playwright
              return name ~= "tests"
            end,
          },
        }),
        require("neotest-playwright").adapter({
          options = {
            persist_project_selection = true,
            enable_dynamic_test_discovery = true,
            get_playwright_binary = function()
              return "/users/aaron/code/venv/bin/playwright"
            end,
            filter_dir = function(name, rel_path, dir)
              -- Test is reserved for Vitest
              return name == "tests"
            end,
            get_playwright_config = function()
              return vim.loop.cwd() .. "/playwright.config.ts"
            end,
          },
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
      {
        "<leader>tw",
        function() require('neotest').run.run({ jestCommand = 'jest --watch ' }) end,
        desc = "Run Watch",
      },
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
  {
    "mfussenegger/nvim-dap",
    opts = {
      setup = {
        vscode_js_debug = function()
          -- local function get_js_debug()
          --   local install_path = require("mason-registry").get_package("js-debug-adapter"):get_install_path()
          --   return install_path .. "/js-debug/src/dapDebugServer.js"
          -- end

          -- Lazvim sets up pwa-node, but modern-neovim sets up additional adapters, so set them up here
          for _, adapter in ipairs({
            "pwa-chrome",
            "pwa-msedge",
            "node-terminal",
            "pwa-extensionHost",
          }) do
            require("dap").adapters[adapter] = vim.tbl_deep_extend("force", {}, require("dap").adapters["pwa-node"])
          end

          -- Lazyvim already sets up pwa-node for ts and js, but not for Jest, so set that up
          -- as well as pwa-chrome here
          for _, language in ipairs({ "typescript", "javascript" }) do
            require("dap").configurations[language] = {
              {
                type = "pwa-node",
                request = "launch",
                name = "Debug Jest Tests",
                -- trace = true, -- include debugger info
                runtimeExecutable = "node",
                runtimeArgs = {
                  "./node_modules/jest/bin/jest.js",
                  "--runInBand",
                },
                rootPath = "${workspaceFolder}",
                cwd = "${workspaceFolder}",
                console = "integratedTerminal",
                internalConsoleOptions = "neverOpen",
              },
              {
                type = "pwa-chrome",
                name = "Attach - Remote Debugging",
                request = "attach",
                program = "${file}",
                cwd = vim.fn.getcwd(),
                sourceMaps = true,
                protocol = "inspector",
                port = 9222, -- Start Chrome google-chrome --remote-debugging-port=9222
                webRoot = "${workspaceFolder}",
              },
              {
                type = "pwa-chrome",
                name = "Launch Chrome",
                request = "launch",
                url = "http://localhost:5173", -- This is for Vite. Change it to the framework you use
                webRoot = "${workspaceFolder}",
                userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
              },
            }
          end

          -- Lazyvim already sets up pwa-node for tsreact and jsreact, so set up pwa-chome
          for _, language in ipairs({ "typescriptreact", "javascriptreact" }) do
            require("dap").configurations[language] = {
              {
                type = "pwa-chrome",
                name = "Attach - Remote Debugging",
                request = "attach",
                program = "${file}",
                cwd = vim.fn.getcwd(),
                sourceMaps = true,
                protocol = "inspector",
                port = 9222, -- Start Chrome google-chrome --remote-debugging-port=9222
                webRoot = "${workspaceFolder}",
              },
              {
                type = "pwa-chrome",
                name = "Launch Chrome",
                request = "launch",
                url = "http://localhost:5173", -- This is for Vite. Change it to the framework you use
                webRoot = "${workspaceFolder}",
                userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
              },
            }
          end
        end,
      },
    },
  },
}

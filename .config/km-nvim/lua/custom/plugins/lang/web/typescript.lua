Util.lazy.on_very_lazy(function()
  vim.filetype.add({
    extension = {
      mjs = "javascript",
      cjs = "javascript",
    },
  })
end)
-- local source_action = function(name)
--   return function()
--     vim.lsp.buf.code_action({
--       apply = true,
--       context = {
--         only = { string.format("source.%s.ts", name) },
--         diagnostics = {},
--       },
--     })
--   end
-- end

return {
  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        --- @deprecated -- tsserver renamed to ts_ls but not yet released, so keep this for now
        --- the proper approach is to check the nvim-lspconfig release version when it's released to determine the server name dynamically
        tsserver = {
          enabled = false,
        },
        ts_ls = {
          enabled = false,
        },
        -- For using with nx monorepos
        -- https://github.com/yardnsm/.config/blob/3bb50e434c65aa80370e47f249bf0c5fc1a7bcd2/nvim/lua/yardnsm/lsp/settings/vtsls.lua#L12
        vtsls = {
          -- explicitly add default filetypes, so that we can extend
          -- them in related extras
          filetypes = {
            "javascript",
            "javascriptreact",
            "javascript.jsx",
            "typescript",
            "typescriptreact",
            "typescript.tsx",
          },
          handlers = {
            -- The requires adds 004.357msec to startup time
            ["textDocument/publishDiagnostics"] = require("util.lsp").publish_to_ts_error_translator,
          },
          -- https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
          settings = {
            complete_function_calls = true,
            vtsls = {
              enableMoveToFileCodeAction = true,
              autoUseWorkspaceTsdk = true,
              experimental = {
                maxInlayHintLength = 30,
                completion = {
                  enableServerSideFuzzyMatch = true,
                  entriesLimit = 50,
                },
              },
            },
            typescript = {
              updateImportsOnFileMove = { enabled = "always" },
              suggest = {
                completeFunctionCalls = true,
              },
              inlayHints = {
                -- enumMemberValues = { enabled = true },
                -- functionLikeReturnTypes = { enabled = true },
                -- parameterNames = { enabled = "literals" },
                -- parameterTypes = { enabled = true },
                -- propertyDeclarationTypes = { enabled = true },
                -- variableTypes = { enabled = false },
                enumMemberValues = { enabled = true },
                functionLikeReturnTypes = { enabled = true },
                parameterNames = { enabled = "literals", suppressWhenArgumentMatchesName = true },
                parameterTypes = { enabled = false },
                propertyDeclarationTypes = { enabled = true },
                variableTypes = { enabled = false },
              },
              tsserver = {
                maxTsServerMemory = 8192,
                preferences = {
                  -- https://github.com/search?q=path%3A**%2Fnvim%2F**%2F*.lua+autoImportFileExcludePatterns&type=code
                  -- autoImportFileExcludePatterns = { "**/node_modules/**/*", "**/dist/**/*" },
                },
              },
              javascript = {
                updateImportsOnFileMove = { enabled = "always" },
                suggest = {
                  completeFunctionCalls = true,
                },
              },
              -- denols = {
              --   enabled = false,
              --   on_new_config = function(new_config)
              --     local configs = { "deno.json", "deno.jsonc" }
              --     local root = require("lazyvim.util.root").get()
              --
              --     for _, config in ipairs(configs) do
              --       if vim.fn.filereadable(root .. "/" .. config) == 1 then return true end
              --     end
              --
              --     new_config.enabled = false
              --   end,
              -- },
            },
          },
          keys = {
            {
              "gD",
              function()
                local params = vim.lsp.util.make_position_params()
                Util.lazy.lsp.execute({
                  command = "typescript.goToSourceDefinition",
                  arguments = { params.textDocument.uri, params.position },
                  open = true,
                })
              end,
              desc = "Goto Source Definition",
            },
            {
              "gR",
              function()
                Util.lazy.lsp.execute({
                  command = "typescript.findAllFileReferences",
                  arguments = { vim.uri_from_bufnr(0) },
                  open = true,
                })
              end,
              desc = "File References",
            },
            {
              "<leader>co",
              Util.lazy.lsp.action["source.organizeImports"],
              desc = "Organize Imports",
            },
            {
              "<leader>cM",
              Util.lazy.lsp.action["source.addMissingImports.ts"],
              desc = "Add missing imports",
            },
            {
              "<leader>cu",
              Util.lazy.lsp.action["source.removeUnused.ts"],
              desc = "Remove unused imports",
            },
            {
              "<leader>cD",
              Util.lazy.lsp.action["source.fixAll.ts"],
              desc = "Fix all diagnostics",
            },
            {
              "<leader>cV",
              function()
                Util.lazy.lsp.execute({ command = "typescript.selectTypeScriptVersion" })
              end,
              desc = "Select TS workspace version",
            },
          },
        },
      },
      setup = {
        --- @deprecated -- tsserver renamed to ts_ls but not yet released, so keep this for now
        --- the proper approach is to check the nvim-lspconfig release version when it's released to determine the server name dynamically
        tsserver = function()
          -- disable tsserver
          return true
        end,
        ts_ls = function()
          -- disable tsserver
          return true
        end,
        vtsls = function(_, opts)
          Util.lazy.lsp.on_attach(function(client, buffer)
            client.commands["_typescript.moveToFileRefactoring"] = function(command, ctx)
              ---@type string, string, lsp.Range
              local action, uri, range = unpack(command.arguments)

              local function move(newf)
                client.request("workspace/executeCommand", {
                  command = command.command,
                  arguments = { action, uri, range, newf },
                })
              end

              local fname = vim.uri_to_fname(uri)
              client.request("workspace/executeCommand", {
                command = "typescript.tsserverRequest",
                arguments = {
                  "getMoveToRefactoringFileSuggestions",
                  {
                    file = fname,
                    startLine = range.start.line + 1,
                    startOffset = range.start.character + 1,
                    endLine = range["end"].line + 1,
                    endOffset = range["end"].character + 1,
                  },
                },
              }, function(_, result)
                ---@type string[]
                local files = result.body.files
                table.insert(files, 1, "Enter new path...")
                vim.ui.select(files, {
                  prompt = "Select move destination:",
                  format_item = function(f)
                    return vim.fn.fnamemodify(f, ":~:.")
                  end,
                }, function(f)
                  if f and f:find("^Enter new path") then
                    vim.ui.input({
                      prompt = "Enter move destination:",
                      default = vim.fn.fnamemodify(fname, ":h") .. "/",
                      completion = "file",
                    }, function(newf)
                      return newf and move(newf)
                    end)
                  elseif f then
                    move(f)
                  end
                end)
              end)
            end
          end, "vtsls")
          -- copy typescript settings to javascript
          opts.settings.javascript =
            vim.tbl_deep_extend("force", {}, opts.settings.typescript, opts.settings.javascript or {})
        end,
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          table.insert(opts.ensure_installed, "js-debug-adapter")
        end,
      },
    },
    opts = function()
      local dap = require("dap")
      if not dap.adapters["pwa-node"] then
        require("dap").adapters["pwa-node"] = {
          type = "server",
          host = "localhost",
          port = "${port}",
          executable = {
            command = "node",
            -- 💀 Make sure to update this path to point to your installation
            args = {
              LazyVim.get_pkg_path("js-debug-adapter", "/js-debug/src/dapDebugServer.js"),
              "${port}",
            },
          },
        }
      end
      if not dap.adapters["node"] then
        dap.adapters["node"] = function(cb, config)
          if config.type == "node" then config.type = "pwa-node" end
          local nativeAdapter = dap.adapters["pwa-node"]
          if type(nativeAdapter) == "function" then
            nativeAdapter(cb, config)
          else
            cb(nativeAdapter)
          end
        end
      end

      local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }

      local vscode = require("dap.ext.vscode")
      vscode.type_to_filetypes["node"] = js_filetypes
      vscode.type_to_filetypes["pwa-node"] = js_filetypes

      for _, language in ipairs(js_filetypes) do
        if not dap.configurations[language] then
          dap.configurations[language] = {
            {
              type = "pwa-node",
              request = "launch",
              name = "Launch file",
              program = "${file}",
              cwd = "${workspaceFolder}",
            },
            {
              type = "pwa-node",
              request = "attach",
              name = "Attach",
              processId = require("dap.utils").pick_process,
              cwd = "${workspaceFolder}",
            },
          }
        end
      end
    end,
  },

  -- Filetype icons
  {
    "echasnovski/mini.icons",
    opts = {
      file = {
        [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        [".node-version"] = { glyph = "", hl = "MiniIconsGreen" },
        [".prettierrc"] = { glyph = "", hl = "MiniIconsPurple" },
        [".yarnrc.yml"] = { glyph = "", hl = "MiniIconsBlue" },
        ["eslint.config.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        ["package.json"] = { glyph = "", hl = "MiniIconsGreen" },
        ["tsconfig.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["tsconfig.build.json"] = { glyph = "", hl = "MiniIconsAzure" },
        ["yarn.lock"] = { glyph = "", hl = "MiniIconsBlue" },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = {
      -- TODO: uncommenting this doesn't let this work for some reason:
      -- ~/.local/share/nvim/lazy/Util.lazy/lua/lazyvim/plugins/lsp/init.lua:279
      -- ensure_installed = { "deno" },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = {
        "javascript",
        "jsdoc",
      },
    },
  },
  {
    "dmmulroy/tsc.nvim",
    enabled = false,
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
      "TSStop",
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
    -- opts = {
    --   adapters = {
    --     ["neotest-jest"] = {
    --       jestCommand = "npm run test:unit --", -- "npx jest", "npm test"
    --       jestConfigFile = "jest.config.ts",
    --       env = { CI = true },
    --       cwd = function()
    --         return vim.fn.getcwd()
    --       end,
    --     },
    --     ["neotest-mocha"] = {
    --       command = "npm test --",
    --       env = { CI = true },
    --       cwd = function()
    --         return vim.fn.getcwd()
    --       end,
    --     },
    --     ["neotest-vitest"] = {
    --       env = { CI = true },
    --       cwd = function()
    --         return vim.fn.getcwd()
    --       end,
    --     },
    --   },
    --   consumers = {
    --     playwright = require("neotest-playwright.consumers").consumers,
    --   },
    -- },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      vim.list_extend(opts.adapters, {
        require("neotest-jest")({
          -- jestCommand = "npm run test:unit --",
          jestCommand = "npx jest",
          jestConfigFile = "jest.config.js",
          -- jestConfigFile = function(file)
          --   -- Find the jest config in monorepo projects
          --   if string.find(file, "/(apps|libs|features)/") then
          --     return string.match(file("(.-/[^/]+/)src")) .. "jest.config.ts"
          --   end
          -- end,
          env = { CI = true, TZ = "utc" },
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
        require("neotest-playwright").adapter({
          options = {
            persist_project_selection = true,
            enable_dynamic_test_discovery = true,
            -- get_playwright_binary = function()
            --   return "/users/aaron/code/venv/bin/playwright"
            -- end,
            -- get_playwright_config = function()
            --   return vim.uv.cwd() .. "/playwright.config.ts"
            -- end,
          },
        }),
      })
      opts.consumers = opts.consumers or {}
      vim.list_extend(opts.consumers, {
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
    opts = {
      ensure_installed = {
        "react",
        "javascript",
        "typescript",
      },
    },
  },
  -- {
  --   "mfussenegger/nvim-dap",
  --   optional = true,
  --   dependencies = {
  --     {
  --       "mason-org/mason.nvim",
  --       opts = function(_, opts)
  --         opts.ensure_installed = opts.ensure_installed or {}
  --         table.insert(opts.ensure_installed, "chrome-debug-adapter")
  --       end,
  --     },
  --   },
  --   opts = function(_, opts)
  --     -- Lazyvim sets up pwa-node, but modern-neovim sets up additional adapters, so set them up here
  --     local dap = require("dap")
  --     for _, adapter in ipairs({
  --       "pwa-chrome",
  --       -- "pwa-msedge",
  --       -- "node-terminal",
  --       -- "pwa-extensionHost",
  --     }) do
  --       dap.adapters[adapter] = vim.tbl_deep_extend("force", {}, require("dap").adapters["pwa-node"])
  --     end
  --
  --     -- Setup chrome debugging
  --     local js_filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" }
  --     for _, language in ipairs(js_filetypes) do
  --       vim.list_extend(dap.configurations[language], {
  --         {
  --           type = "pwa-chrome",
  --           name = "Attach - Remote Debugging",
  --           request = "attach",
  --           program = "${file}",
  --           cwd = vim.fn.getcwd(),
  --           sourceMaps = true,
  --           protocol = "inspector",
  --           port = 9222, -- Start Chrome google-chrome --remote-debugging-port=9222
  --           webRoot = "${workspaceFolder}",
  --         },
  --         {
  --           type = "pwa-chrome",
  --           name = "Launch Chrome",
  --           request = "launch",
  --           url = "http://localhost:5173", -- This is for Vite. Change it to the framework you use
  --           webRoot = "${workspaceFolder}",
  --           userDataDir = "${workspaceFolder}/.vscode/vscode-chrome-debug-userdatadir",
  --         },
  --         {
  --           type = "pwa-node",
  --           request = "launch",
  --           name = "Debug Jest Tests",
  --           -- trace = true, -- include debugger info
  --           runtimeExecutable = "node",
  --           runtimeArgs = {
  --             "./node_modules/jest/bin/jest.js",
  --             "--runInBand",
  --           },
  --           rootPath = "${workspaceFolder}",
  --           cwd = "${workspaceFolder}",
  --           console = "integratedTerminal",
  --           internalConsoleOptions = "neverOpen",
  --         },
  --       })
  --     end
  --     -- -- Set up jest debugging
  --     -- for _, language in ipairs({ "typescript", "javascript" }) do
  --     --   vim.list_extend(dap.configurations[language], {
  --     --     {
  --     --       type = "pwa-node",
  --     --       request = "launch",
  --     --       name = "Debug Jest Tests",
  --     --       -- trace = true, -- include debugger info
  --     --       runtimeExecutable = "node",
  --     --       runtimeArgs = {
  --     --         "${workspaceFolder}/node_modules/.bin/jest",
  --     --         -- "--runInBand",
  --     --       },
  --     --       args = {
  --     --         "--projects",
  --     --         "src/jest.config.rtl.js",
  --     --         "${file}",
  --     --         "--coverage",
  --     --         "false",
  --     --       },
  --     --       sourceMaps = true,
  --     --       rootPath = "${workspaceFolder}",
  --     --       cwd = "${workspaceFolder}",
  --     --       console = "integratedTerminal",
  --     --       internalConsoleOptions = "neverOpen",
  --     --     },
  --     --   })
  --     -- end
  --   end,
  -- },
}

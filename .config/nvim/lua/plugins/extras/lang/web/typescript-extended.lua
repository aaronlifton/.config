LazyVim.on_very_lazy(function()
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
  { import = "lazyvim.plugins.extras.lang.typescript" },
  -- {
  --   "williamboman/mason.nvim",
  --   optional = true,
  --   opts = {
  --     ensure_installed = { "deno" },
  --   },
  -- },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        vtsls = {
          handlers = {
            -- The requires adds 004.357msec to startup time
            ["textdocument/publishdiagnostics"] = require("util.lsp").publish_to_ts_error_translator,
          },
          init_options = {
            preferences = {
              disableSuggestions = true,
            },
          },
        },
        denols = {
          on_new_config = function(new_config)
            local configs = { "deno.json", "deno.jsonc" }
            local root = require("lazyvim.util.root").get()

            for _, config in ipairs(configs) do
              if vim.fn.filereadable(root .. "/" .. config) == 1 then return true end
            end

            new_config.enabled = false
          end,
        },
      },
      -- setup = {
      -- vtsls = function(server, server_opts)
      --   require("lspconfig").tsserver.setup({
      --     on_attach = function(client, bufnr)
      --       -- if pcall(require, "lsp_signature") then
      --       --   require("lsp_signature").on_attach({ hint_prefix = "" })
      --       -- end
      --
      --       -- if pcall(require, "workspace-diagnostics") then
      --       --   require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
      --       -- end
      --     end,
      --   })
      -- end,
      -- },
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
  --       "williamboman/mason.nvim",
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

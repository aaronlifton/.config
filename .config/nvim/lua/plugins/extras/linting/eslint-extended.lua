return {
  { import = "lazyvim.plugins.extras.linting.eslint" },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    ensure_installed = {
      "eslint",
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local root = LazyVim.root()
      return vim.tbl_deep_extend("force", opts, {
        ---@type lspconfig.options
        servers = {
          eslint = {
            -- https://github.com/Microsoft/vscode-eslint#settings-options
            settings = {
              quiet = true,
              options = {
                overrideConfigFile = root .. "/.eslintrc.js",
              },
            },
          },
        },
      })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = {
      -- formatters_by_ft = {
      --   ["javascript"] = { { "eslint_d" } },
      -- },
      formatters = {
        eslint = {
          prepend_args = function()
            local util = require("util.system")
            if util.hostname() == "ali-d7jf7y.local" then
              return { "-c", ".eslintrc.js", "--quiet" }
            end
          end,
        },
        eslint_d = {
          prepend_args = function()
            local util = require("util.system")
            if util.hostname() == "ali-d7jf7y.local" then
              return { "-c", ".eslintrc.js", "--quiet" }
            end
          end,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        eslint_d = {
          prepend_args = function()
            local util = require("util.system")
            if util.hostname() == "ali-d7jf7y.local" then
              return { "--quiet" }
            end
          end,
        },
      },
    },
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   optional = true,
  --   opts = {
  --     servers = {
  --       eslint = {
  --         quiet = true,
  --       },
  --     },
  --     -- setup = {
  --     --   -- TODO: revisit if needed
  --     --   eslint = function()
  --     --     require("lazyvim.util").lsp.on_attach(function(client)
  --     --       if client.name == "eslint" then
  --     --         client.server_capabilities.documentFormattingProvider = true
  --     --       elseif client.name == "tsserver" or client.name == "vtsls" then
  --     --         client.server_capabilities.documentFormattingProvider = false
  --     --       end
  --     --     end)
  --     --   end,
  --     -- },
  --   },
  -- },
}

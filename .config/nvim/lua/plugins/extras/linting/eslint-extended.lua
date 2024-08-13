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
    opts = {
      servers = {
        eslint = {},
      },
    },
    -- opts = function(_, opts)
    --   local root = LazyVim.root()
    --   local eslint_settings_options = {}
    --   if root then
    --     local has_config = vim.fs.find({ ".eslintrc.js" }, { path = ctx.filename, upward = true })[1]
    --
    --     eslint_settings_options = { overrideConfigFile = root .. "/.eslintrc.js" }
    --   end
    --
    --   return vim.tbl_deep_extend("force", opts, {
    --     ---@type lspconfig.options
    --     servers = {
    --       eslint = {
    --         -- https://github.com/Microsoft/vscode-eslint#settings-options
    --         settings = {
    --           quiet = false,
    --           options = eslint_settings_options,
    --         },
    --       },
    --     },
    --   })
    -- end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      -- opts.formatters_by_ft["javascript"] = { "eslint_d" }
      opts.formatters_by_ft["javascript"] = {}
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
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

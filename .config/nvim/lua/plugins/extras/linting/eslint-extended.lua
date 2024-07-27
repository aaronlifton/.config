local conform_util = require("conform.util")
return {
  { import = "lazyvim.plugins.extras.linting.eslint" },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    ensure_installed = {
      "eslint",
      "eslint_d",
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters = {
        ---@type conform.FileFormatterConfig
        -- eslint = {
        --   command = conform_util.from_node_modules("eslint"),
        --   args = { "--quiet", "--fix", "--stdin", "--stdin-filename", "$FILENAME" },
        --   cwd = conform_util.root_file({
        --     "package.json",
        --   }),
        -- },
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
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        eslint = {
          quiet = true,
        },
      },
      setup = {
        eslint = function()
          require("lazyvim.util").lsp.on_attach(function(client)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
            elseif client.name == "tsserver" or client.name == "vtsls" then
              client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
      },
    },
  },
}

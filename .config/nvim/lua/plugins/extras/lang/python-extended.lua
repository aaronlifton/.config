-- LSP Server to use for Python.
-- Set to "basedpyright" to use basedpyright instead of pyright.
vim.g.lazyvim_python_lsp = "basedpyright"
vim.g.lazyvim_python_ruff = "ruff"
-- local ruff = vim.g.lazyvim_python_ruff

return {
  { import = "lazyvim.plugins.extras.lang.python" },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = {
        "requirements",
      },
    },
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "python-3.13",
        "python-3.11",
        "python-3.9",
      },
    },
  },
  -- Basedpyright is installed automatically with mason-lspconfig - LazyVim/lua/lazyvim/plugins/lsp/init.lua
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     servers = {
  --       ---@type lspconfig.options.basedpyright
  --       basedpyright = {
  --         settings = {
  --           basedpyright = {
  --             analysis = {
  --               diagnosticSeverityOverrides = {
  --                 reportMissingTypeStubs = "information", -- import has no type stub file
  --                 reportIgnoreCommentWithoutRule = "warning",
  --                 reportUnreachable = "error",
  --                 reportPrivateLocalImportUsage = "error",
  --                 reportImplicitRelativeImport = "error",
  --                 reportInvalidCast = "error",
  --                 reportMissingSuperCall = false,
  --                 reportUnusedCallResult = "information",
  --                 reportUnusedExpression = "information",
  --                 reportUnknownMemberType = "none",
  --                 reportUnknownLambdaType = "none",
  --                 reportUnknownParameterType = "none",
  --                 reportMissingParameterType = "none",
  --                 reportUnknownVariableType = "none",
  --                 reportUnknownArgumentType = "none",
  --                 reportAny = "none",
  --               },
  --             },
  --           },
  --         },
  --       },
  --       ---@type lspconfig.options.pyright
  --       pyright = {
  --         settings = {
  --           verboseOutput = true,
  --           autoImportCompletion = true,
  --           python = {
  --             analysis = {
  --               diagnosticSeverityOverrides = {
  --                 reportWildcardImportFromLibrary = "none",
  --                 reportUnusedImport = "information",
  --                 reportUnusedClass = "information",
  --                 reportUnusedFunction = "information",
  --               },
  --               typeCheckingMode = "strict",
  --               autoSearchPaths = true,
  --               useLibraryCodeForTypes = true,
  --               diagnosticMode = "openFilesOnly",
  --               indexing = true,
  --             },
  --           },
  --         },
  --       },
  --       -- [ruff] = {
  --       --   handlers = {
  --       --     ["textDocument/publishDiagnostics"] = function() end,
  --       --   },
  --       -- },
  --     },
  --     -- setup = {
  --     --   [ruff] = function()
  --     --     LazyVim.lsp.on_attach(function(client, _)
  --     --       client.server_capabilities.hoverProvider = false
  --     --       -- Added this line so basedpyright is the only diagnoistics provider
  --     --       client.server_capabilities.diagnosticProvider = false
  --     --     end, ruff)
  --     --   end,
  --     -- },
  --   },
  -- },
  -- {
  --   "MeanderingProgrammer/py-requirements.nvim",
  --   event = {
  --     "BufRead requirements.txt",
  --   },
  --   dependencies = {
  --     { "nvim-lua/plenary.nvim" },
  --     {
  --       "hrsh7th/nvim-cmp",
  --       optional = true,
  --       dependencies = {},
  --       opts = function(_, opts)
  --         table.insert(opts.sources, { name = "py-requirements" })
  --       end,
  --     },
  --   },
  --   opts = {},
  --   -- stylua: ignore
  --   keys = {
  --     { "<leader>Ppu", function() require("py-requirements").upgrade() end, desc = "Update Package" },
  --     { "<leader>Ppi", function() require("py-requirements").show_description() end, desc = "Package Info" },
  --     { "<leader>Ppa", function() require("py-requirements").upgrade_all() end, desc = "Update All Packages" },
  --   },
  -- },
  -- {
  --   "folke/which-key.nvim",
  --   opts = {
  --     spec = {
  --       { "<leader>P", group = "packages/dependencies", icon = " " },
  --       { "<leader>Pp", group = "python", icon = " " },
  --     },
  --   },
  -- },
}

return {
  {
    "sam4llis/nvim-lua-gf",
    lazy = true,
  },
  -- { "LuaCATS/luassert", name = "luassert-types", lazy = true },
  { "LuaCATS/busted", name = "busted-types", lazy = true },
  {
    "folke/lazydev.nvim",
    optional = true,
    opts = function(_, opts)
      opts.library = vim.tbl_extend("keep", opts.library, {
        { path = "nvim-lspconfig", words = { "lspconfig%." } },
        { path = "lazydev.nvim", words = { "lazydev" } },
        { path = "neotest", words = { "neotest%." } },
        { path = "nvim-dap-ui", words = { "dap%." } },
        { path = "fzf-lua", words = { "fzf%." } },
        { path = "codeium.vim", words = { "codeium%." } },
        { path = "conform.nvim", words = { "conform%." } },
        { path = "copilot.lua", words = { "copilot%." } },
        { path = "mini", words = { "MiniExtra" } },
        { path = "mini.diff", words = { "MiniDiff" } },
        { path = "mini.ai", words = { "mini%.ai" } },
        { path = "model.nvim", words = { "model%." } },
        { path = "noice.nvim", words = { "noice%." } },
        { path = "nvim-cmp", words = { "cmp%." } },
        { path = "nvim-treesitter", words = { "TSNode", "TS%w" } },
        { path = "overseer.nvim", words = { "overseer%." } },
        { path = "edgy.nvim", words = { "edgy%." } },
        -- { path = "luassert-types/library", words = { "assert" } },
        { path = "busted-types/library", words = { "describe" } },
      })
    end,
  },
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = {
      ensure_installed = {
        "selene",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    after = "folke/lazydev.nvim",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                library = {
                  -- Source files are in /Applications/Hammerspoon.app/Contents/Resources/extensions/hs/*.lua
                  string.format("%s/.hammerspoon/Spoons/EmmyLua.spoon/annotations", os.getenv("HOME")),
                },
              },
            },
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        lua = { "selene" },
      },
      linters = {
        selene = {
          -- prepend_args = { "--config", vim.fn.stdpath("config") .. "/selene.toml" },
          condition = function(ctx)
            -- Disable unless the file is in the root of the project
            -- local root = LazyVim.root.get({ normalize = true })
            -- if root ~= vim.uv.cwd() then return false end

            -- Disable unless editing nvim config
            local config = vim.fn.stdpath("config")
            if config ~= vim.uv.cwd() then return false end

            return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      },
    },
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "lua-5.4",
      },
    },
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   optional = true,
  --   opts = {
  --     servers = {
  --       lua_ls = {
  --         settings = {
  --           Lua = {
  --             hint = {
  --               setType = true,
  --             },
  --             codeLens = {
  --               enable = false,
  --             },
  --           },
  --         },
  --       },
  --     },
  --   },
  -- },
  --   opts = {
  --     servers = {
  --       lua_ls = {
  --         settings = {
  --           Lua = {
  --             runtime = {
  --               -- LuaFun needs LuaJIT 2.1 for tail recursion
  --               version = "LuaJIT",
  --               pathStrict = true,
  --               path = { "?.lua", "?/init.lua" },
  --             },
  --             telemetry = { enable = false },
  --             semantic = { enable = false }, -- Do not override treesitter lua highlighting with lua_ls's highlighting
  --             diagnostics = {
  --               globals = { "vim", "LazyVim" },
  --               undefined_global = false, -- remove this from diag!
  --               missing_parameters = false, -- missing fields :)
  --               disable = { "missing-parameters", "missing-fields" },
  --             },
  --           },
  --         },
  --       },
  --     },
  --     setup = {
  --       lua_ls = function(_, _)
  --         local lsp_utils = require("util.lsp")
  --         lsp_utils.on_attach(function(client, buffer)
  --               -- stylua: ignore
  --               if client.name == "lua_ls" then
  --                 vim.keymap.set("n", "<leader>dX", function() require("osv").run_this() end, { buffer = buffer, desc = "OSV Run" })
  --                 vim.keymap.set("n", "<leader>dL", function() require("osv").launch({ port = 8086 }) end, { buffer = buffer, desc = "OSV Launch" })
  --               end
  --         end)
  --       end,
  --     },
  --   },
}

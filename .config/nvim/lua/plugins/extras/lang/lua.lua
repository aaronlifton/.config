return {
  {
    "sam4llis/nvim-lua-gf",
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "folke/lazydev.nvim",
        opts = {
          library = { plugins = { "neotest", "nvim-dap-ui" } },
        },
      },
    },
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = {
                -- LuaFun needs LuaJIT 2.1 for tail recursion
                version = "LuaJIT",
                pathStrict = true,
                path = { "?.lua", "?/init.lua" },
              },
              telemetry = { enable = false },
              semantic = { enable = false }, -- Do not override treesitter lua highlighting with lua_ls's highlighting
              -- -- Already defined in .luarc.json
              -- workspace = {
              --   checkThirdParty = false,
              --   library = lsp_util.library(),
              --   maxPreload = 8000,
              --   preloadFileSize = 1000,
              --   ignoreDir = { ".*", "aaron", "config/nvim", "nvim/lua" },
              --   -- maxPreload = 100000,
              --   -- preloadFileSize = 10000,
              -- },
              -- completion = {
              --   callSnippet = "Replace",
              -- },
              -- Using LazyVim's config
              -- hint = {
              --   enable = true,
              --   setType = true,
              --   paramType = true, -- Show type hints at the parameter of the function.
              --   paramName = "Literal", -- Show hints of parameter name (literal types only) at the function call.
              --   arrayIndex = "Auto", -- Show hints only when the table is greater than 3 items, or the table is a mixed table.
              -- },
              diagnostics = {
                globals = { "vim", "LazyVim" },
                undefined_global = false, -- remove this from diag!
                missing_parameters = false, -- missing fields :)
                disable = { "missing-parameters", "missing-fields" },
              },
              -- format = {
              --   enable = true,
              --   defaultConfig = {
              --     indent_style = "space",
              --     indent_size = "2",
              --     continuation_indent_size = "2",
              --   },
              -- },
            },
          },
        },
      },
      setup = {
        lua_ls = function(_, _)
          local lsp_utils = require("util.lsp")
          lsp_utils.on_attach(function(client, buffer)
                -- stylua: ignore
                if client.name == "lua_ls" then
                  vim.keymap.set("n", "<leader>dX", function() require("osv").run_this() end, { buffer = buffer, desc = "OSV Run" })
                  vim.keymap.set("n", "<leader>dL", function() require("osv").launch({ port = 8086 }) end, { buffer = buffer, desc = "OSV Launch" })
                end
          end)
        end,
      },
    },
  },
}

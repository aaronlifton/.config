local nvim_0_10 = vim.fn.has("nvim-0.10")
local lsp_util = require("util.lsp")

return {
  { "folke/neodev.nvim", before = "neovim/nvim-lspconfig" },
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      keys[#keys + 1] = { "<leader>cl", false }
      keys[#keys + 1] = { "<leader>cil", "<cmd>LspInfo<cr>", desc = "Lsp" }
      keys[#keys + 1] = { "<leader>clr", "<cmd>LspRestart<cr>", desc = "Restart Lsp" }
      keys[#keys + 1] = { "<leader>cls", "<cmd>LspStart<cr>", desc = "Start Lsp" }
      keys[#keys + 1] = { "<leader>clS", "<cmd>LspStop<cr>", desc = "Stop Lsp" }

      -- stylua: ignore start
      keys[#keys + 1] = { "<leader>clr", function() vim.lsp.buf.remove_workspace_folder() end, desc = "Remove workspace" }
      keys[#keys + 1] = { "<leader>cla", function() vim.lsp.buf.add_workspace_folder() end, desc = "Add workspace" }
      keys[#keys + 1] = {
        "<leader>cll",
        function()
          local workspace_folders = vim.lsp.buf.list_workspace_folders()
          local printed = vim.inspect(workspace_folders)
          local with_newlines = printed:gsub(",", "\n")
          vim.api.nvim_echo(
            {
              { "Workspace folders:", "Normal" },
              { with_newlines, "Comment" },
            },
            true,
            {}
          )
        end,
        desc = "List workspaces"
      }
      -- stylua: ignore end
    end,
    opts = {
      diagnostics = {
        virtual_text = {
          float = {
            border = {
              { "┌", "FloatBorder" },
              { "─", "FloatBorder" },
              { "┐", "FloatBorder" },
              { "│", "FloatBorder" },
              { "┘", "FloatBorder" },
              { "─", "FloatBorder" },
              { "└", "FloatBorder" },
              { "│", "FloatBorder" },
            },
          },
        },
      },
      inlay_hints = {
        enabled = nvim_0_10,
      },
      codelens = {
        -- only enabled for go, ts, js and lua.
        -- seems to conflict with inlay hints for go.
        enabled = false,
      },
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
              -- Do not override treesitter lua highlighting with lua_ls's highlighting
              semantic = { enable = false },
              workspace = {
                checkThirdParty = false,
                library = lsp_util.library({
                  "lazy.nvim",
                  "telescope.nvim",
                  "edgy.nvim",
                }),
                -- library = {
                --   [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                --   [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
                --   -- CosmicNvim
                --   -- vim.env.VIMRUNTIME,
                --   -- --[[ "${3rd}/busted/library", ]]
                --   -- '${3rd}/luv/library',
                -- },
                -- maxPreload = 100000,
                -- preloadFileSize = 10000,
              },
              completion = {
                -- workspaceWord = true,
                -- callSnippet = "Both",
                callSnippet = "Replace",
              },
              hint = {
                enable = nvim_0_10,
                setType = nvim_0_10,
              },
              diagnostics = {
                globals = { "vim" },
              },
              format = {
                enable = true,
                defaultConfig = {
                  indent_style = "space",
                  indent_size = "2",
                  continuation_indent_size = "2",
                },
              },
            },
          },
        },
        texlab = { filetypes = { "tex", "pandoc", "bib" } },
        ltex = { filetypes = { "tex", "pandoc", "bib" } },
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>cl"] = { name = "lsp" },
      },
    },
  },
}

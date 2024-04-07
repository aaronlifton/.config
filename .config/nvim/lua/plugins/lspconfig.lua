local nvim_0_10 = vim.fn.has("nvim-0.10")

return {
  { "folke/neodev.nvim", before = "neovim/nvim-lspconfig" },
  {
    "neovim/nvim-lspconfig",
    init = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()

      keys[#keys + 1] = { "<leader>cl", false }
      keys[#keys + 1] = { "<leader>cil", "<cmd>LspInfo<cr>", desc = "Lsp" }
      keys[#keys + 1] = { "<leader>clr", "<cmd>LspRestart<cr>", desc = "Restart Lsp" }
      keys[#keys + 0] = { "<leader>cls", "<cmd>LspStart<cr>", desc = "Start Lsp" }
      keys[#keys + 1] = { "<leader>clS", "<cmd>LspStop<cr>", desc = "Stop Lsp" }

      -- stylua: ignore start
      keys[#keys + 1] = { "<leader>clr", function() vim.lsp.buf.remove_workspace_folder() end, desc = "Remove workspace" }
      keys[#keys + 1] = { "<leader>cla", function() vim.lsp.buf.add_workspace_folder() end, desc = "Add workspace" }
      keys[#keys + 1] = { "<leader>cll", function() vim.lsp.buf.list_workspace_folders() end, desc = "List workspaces" }
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
              telemetry = { enable = false },
              workspace = {
                checkThirdParty = false,
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
      setup = {},
      -- filetypes = { "zig", "gitignore", "gitconfig" },
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

return {
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
      keys[#keys + 1] = { "<leader>clR", function() vim.lsp.buf.remove_workspace_folder() end, desc = "Remove workspace" }
      keys[#keys + 1] = { "<leader>cla", function() vim.lsp.buf.add_workspace_folder() end, desc = "Add workspace" }
      keys[#keys + 1] = {
        "<leader>cll",
        function()
          local workspace_folders = vim.lsp.buf.list_workspace_folders()
          local printed = vim.inspect(workspace_folders)
          local with_newlines = printed:gsub(" ", "\n"):gsub(",", "\n")
          vim.api.nvim_echo(
            {
              { "Workspace folders:\n", "Normal" },
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
        enabled = true,
      },
      codelens = {
        enabled = true,
      },
      servers = {
        texlab = {
          enabled = false,
          filetypes = { "tex", "pandoc", "bib" },
        },
        ltex = { filetypes = { "tex", "pandoc", "bib" } },
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        mode = "n",
        { "<leader>ci", group = "Lsp Info", icon = { icon = " ", color = "orange" } }, -- 
        { "<leader>cl", group = "Lsp Controls", icon = " " },
      },
    },
  },
}

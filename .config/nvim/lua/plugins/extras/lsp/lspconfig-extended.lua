local prefix = "<leader>cl"
return {
  {
    "neovim/nvim-lspconfig",
    -- init = function()
    --   local keys = require("lazyvim.plugins.lsp.keymaps").get()
    --
    --   keys[#keys + 1] = { prefix, false }
    --   keys[#keys + 1] = { "<leader>cil", "<cmd>LspInfo<cr>", desc = "Lsp" }
    --   keys[#keys + 1] = { prefix .. "r", "<cmd>LspRestart<cr>", desc = "Restart Lsp" }
    --   keys[#keys + 1] = { prefix .. "s", "<cmd>LspStart<cr>", desc = "Start Lsp" }
    --   keys[#keys + 1] = { prefix .. "S", "<cmd>LspStop<cr>", desc = "Stop Lsp" }
    --   keys[#keys + 1] = { prefix .. "K", "<cmd>LspStop ++force<cr>", desc = "Stop Lsp (force)" }
    --
    --   -- stylua: ignore start
    --   keys[#keys + 1] = { prefix .. "R", function() vim.lsp.buf.remove_workspace_folder() end, desc = "Remove workspace" }
    --   keys[#keys + 1] = { prefix .. "a", function() vim.lsp.buf.add_workspace_folder() end, desc = "Add workspace" }
    --   keys[#keys + 1] = {
    --     prefix .. "l",
    --     function()
    --       local workspace_folders = vim.lsp.buf.list_workspace_folders()
    --       local printed = vim.inspect(workspace_folders)
    --       local with_newlines = printed:gsub(" ", "\n"):gsub(",", "\n")
    --       vim.api.nvim_echo(
    --         {
    --           { "Workspace folders:\n", "Normal" },
    --           { with_newlines, "Comment" },
    --         },
    --         true,
    --         {}
    --       )
    --     end,
    --     desc = "List workspaces"
    --   }
    --   -- stylua: ignore end
    -- end,
    opts = {
      diagnostics = {
        virtual_text = {
          -- prefix = "icons",
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
    "neovim/nvim-lspconfig",
    opts = function()
      local Keys = require("lazyvim.plugins.lsp.keymaps").get()

      -- stylua: ignore
      vim.list_extend(Keys, {
        { prefix, false },
        -- { "<leader>cil", "<cmd>LspInfo<cr>", desc = "Lsp" },
        { "<leader>cil", function() Snacks.picker.lsp_config() end, desc = "Lsp" },
        { prefix .. "r", "<cmd>LspRestart<cr>", desc = "Restart Lsp" },
        { prefix .. "s", "<cmd>LspStart<cr>", desc = "Start Lsp" },
        { prefix .. "S", "<cmd>LspStop<cr>", desc = "Stop Lsp" },
        { prefix .. "K", "<cmd>LspStop ++force<cr>", desc = "Stop Lsp (force)" },
        { prefix .. "R", function() vim.lsp.buf.remove_workspace_folder() end, desc = "Remove workspace" },
        { prefix .. "a", function() vim.lsp.buf.add_workspace_folder() end, desc = "Add workspace" },
        {
          prefix .. "l",
          function()
            local workspace_folders = vim.lsp.buf.list_workspace_folders()
            local printed = vim.inspect(workspace_folders)
            local with_newlines = printed:gsub(" ", "\n"):gsub(",", "\n")
            vim.api.nvim_echo({
              { "Workspace folders:\n", "Normal" },
              { with_newlines, "Comment" },
            }, true, {})
          end,
          desc = "List workspaces",
        },
      })
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        mode = "n",
        { "<leader>ci", group = "Lsp Info", icon = " " }, -- 
        { prefix, group = "Lsp Controls", icon = " " },
      },
    },
  },
}

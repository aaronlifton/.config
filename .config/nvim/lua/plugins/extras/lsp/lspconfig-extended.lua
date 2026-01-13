local prefix = "<leader>cl"

return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      diagnostics = {
        virtual_text = {
          -- prefix = "icons",
          float = {
            -- border = "rounded",
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
  -- TODO: don't really use this
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      vim.list_extend(opts.servers["*"].keys, {
        -- stylua: ignore start
        { "<leader>cil", function() Snacks.picker.lsp_config() end, desc = "Lsp" },
        { prefix .. "c", function() Snacks.picker.lsp_config() end, desc = "Lsp" },
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
        -- stylua: ignore end
      })
      return opts
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

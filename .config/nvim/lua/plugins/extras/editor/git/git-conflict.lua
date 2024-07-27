local toggled = false
---@param buf number
local set_git_conflict_keymap = function(buf)
  vim.api.nvim_buf_set_keymap(buf, "n", "co", "<Plug>(git-conflict-ours)", { desc = "Choose Their Changes" })
  vim.api.nvim_buf_set_keymap(buf, "n", "ct", "<Plug>(git-conflict-theirs)", { desc = "Choose Our Changes" })
  vim.api.nvim_buf_set_keymap(buf, "n", "cb", "<Plug>(git-conflict-both)", { desc = "Choose Both changes" })
  vim.api.nvim_buf_set_keymap(buf, "n", "c0", "<Plug>(git-conflict-none)", { desc = "Choose None" })
  vim.api.nvim_buf_set_keymap(buf, "n", "cx", "<Plug>(git-conflict-refresh)", { desc = "Git Conflict Refresh" })
  vim.api.nvim_buf_set_keymap(buf, "n", "[x", "<Plug>(git-conflict-prev-conflict)", { desc = "Prev Git Conflict" })
  vim.api.nvim_buf_set_keymap(buf, "n", "]x", "<Plug>(git-conflict-next-conflict)", { desc = "Next Git Conflict" })
  toggled = treu
end

return {

  {
    "akinsho/git-conflict.nvim",
    opts = {
      default_mappings = false,
      -- default_commands = true, -- disable commands created by this plugin
      -- disable_diagnostics = false, -- This will disable the diagnostics in a buffer whilst it is conflicted
      -- list_opener = "copen", -- command or function to open the conflicts list
      list_opener = function()
        require("trouble").open({ mode = "quickfix", focus = false })
      end,
      -- highlights = { -- They must have background color, otherwise the default color will be used
      --   incoming = "DiffAdd",
      --   current = "DiffText",
      -- },
    },
    version = "*",
    keys = {
      { "<leader>gCt", "<cmd>GitConflictChooseTheirs<cr>", desc = "Choose Their Changes" },
      { "<leader>gCo", "<cmd>GitConflictChooseOurs<cr>", desc = "Choose Our Changes" },
      { "<leader>gCb", "<cmd>GitConflictChooseBoth<cr>", desc = "Choose Both changes" },
      { "<leader>gCl", "<cmd>GitConflictListQf<cr>", desc = "Git Conflict Quicklist" },
      { "<leader>gCr", "<cmd>GitConflictRefresh<cr>", desc = "Git Conflict Refresh" },
      { "[x", "<cmd>GitConflictPrevConflict<cr>", desc = "Prev Git Conflict" },
      { "]x", "<cmd>GitConflictNextConflict<cr>", desc = "Next Git Conflict" },
      {
        "<leader>gCR",
        function()
          require("git-conflict").setup()
          vim.api.nvim_command("GitConflictRefresh")
        end,
        "Git Conflict Load",
      },
    },
    -- config = true,
    config = function(_, opts)
      require("git-conflict").setup(opts)

      vim.api.nvim_create_autocmd("User", {
        pattern = "GitConflictDetected",
        callback = function()
          vim.notify("Conflict detected in " .. vim.fn.expand("<afile>"))
          local buf = vim.api.nvim_get_current_buf()

          set_git_conflict_keymap(buf)

          vim.keymap.set("n", "<leader>uG", function()
            if toggled then
              vim.api.nvim_buf_del_keymap(buf, "n", "co")
              vim.api.nvim_buf_del_keymap(buf, "n", "ct")
              vim.api.nvim_buf_del_keymap(buf, "n", "cb")
              vim.api.nvim_buf_del_keymap(buf, "n", "c0")
              vim.api.nvim_buf_del_keymap(buf, "n", "cx")
              vim.api.nvim_buf_del_keymap(buf, "n", "[x")
              vim.api.nvim_buf_del_keymap(buf, "n", "]x")
              toggled = false
            else
              set_git_conflict_keymap(buf)
            end
          end, { desc = "Disable Git Conflict keymap", buffer = true })
        end,
      })
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        mode = "n",
        { "<leader>gC", group = "conflicts", icon = { icon = "", color = "red" } },
      },
    },
  },
}

return {
  {
    "mikavilpas/yazi.nvim",
    keys = {
      { "<leader>fy", "<cmd>Yazi<cr>", desc = "Yazi (Root Dir)" },
      { "<leader>fY", "<cmd>Yazi cwd<cr>", desc = "Yazi (Cwd)" },
      { "<a-e>", "<cmd>Yazi toggle<cr>", desc = "Resume Last Yazi Session" },
    },
    opts = {
      open_for_directories = true,
      floating_window_scaling_factor = 0.8,
      yazi_floating_window_border = "none",
      integrations = {
        grep_in_directory = "fzf-lua",
        grep_in_selected_files = "fzf-lua",
      },
    },
  },
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   opts = {
  --     filesystem = {
  --       hijack_netrw_behavior = "disabled",
  --     },
  --   },
  -- },
  -- {
  --   "nvim-neo-tree/neo-tree.nvim",
  --   enabled = false,
  -- },
}

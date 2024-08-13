return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "sindrets/diffview.nvim", optional = true },
    -- "nvim-telescope/telescope.nvim",
  },
  cmd = { "Neogit" },
  opts = {
    integrations = {
      diffview = true,
    },
  },
  keys = {
    { "<leader>gn", "<cmd>Neogit<cr>", desc = "Neogit" },
    { "<leader>g<cr>", "<cmd>Neogit commit<cr>", desc = "Neogit - Commit" },
  },
}

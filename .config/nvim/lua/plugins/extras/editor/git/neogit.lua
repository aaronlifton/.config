return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "sindrets/diffview.nvim", optional = true },
    "nvim-telescope/telescope.nvim",
  },
  cmd = { "Neogit" },
  opts = {},
  keys = {
    { "<leader>gN", "<cmd>Neogit<cr>", desc = "Neogit" },
  },
}

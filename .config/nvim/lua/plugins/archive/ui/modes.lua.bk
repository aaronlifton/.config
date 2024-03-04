return {
  {
    "mvllow/modes.nvim",
    event = "VeryLazy",
    opts = {},
  },
  {
    "mawkler/modicator.nvim",
    event = "LazyFile",
    init = function()
      -- These are required for Modicator to work
      vim.o.cursorline = true
      vim.o.number = true
      vim.o.termguicolors = true
    end,
    opts = {},
  },
  {
    "rasulomaroff/reactive.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      { "<leader>uM", "<cmd>ReactiveToggle<cr>", desc = "Mode Lines" },
    },
  },
  {
    "folke/which-key.nvim",
    optional = true,
    opts = {
      triggers_blacklist = {
        n = { "d", "y" },
      },
    },
  },
}

return {
  {
    "aserowy/tmux.nvim",
    event = "VeryLazy",
    enabled = not vim.g.vscode,
    config = function()
      require("tmux").setup()
    end,
  },
  {
    "alexghergh/nvim-tmux-navigation",
    event = "VeryLazy",
    enabled = not vim.g.vscode,
    keys = {
      { "<C-h>",  "<cmd>NvimTmuxNavigateLeft<cr>",       { noremap = true, desc = "Go to left window", silent = true } },
      { "<C-j>",  "<cmd>NvimTmuxNavigateDown<cr>",       { noremap = true, desc = "Go to lower window", silent = true } },
      { "<C-k>",  "<cmd>NvimTmuxNavigateUp<cr>",         { noremap = true, desc = "Go to upper window", silent = true } },
      { "<C-l>",  "<cmd>NvimTmuxNavigateRight<cr>",      { noremap = true, desc = "Go to right window", silent = true } },
      { "<C-\\>", "<cmd>NvimTmuxNavigateLastActive<cr>", { desc = "Go to the last active window", silent = true } },
      { "<C-h>",  "<cmd>NvimTmuxNavigateNext<cr>",       { desc = "Go to the next window", silent = true } },
    },
    config = function(user_config)
      require("nvim-tmux-navigation").setup(user_config)
    end,
  },
}

-- if vim.g.multiplexer == "tmux" then
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
      {
        "<C-h>",
        "<cmd>NvimTmuxNavigateLeft<cr>",
        { noremap = true, desc = "Go to left window", silent = true },
      },
      {
        "<C-j>",
        "<cmd>NvimTmuxNavigateDown<cr>",
        { noremap = true, desc = "Go to lower window", silent = true },
      },
      {
        "<C-k>",
        "<cmd>NvimTmuxNavigateUp<cr>",
        { noremap = true, desc = "Go to upper window", silent = true },
      },
      {
        "<C-l>",
        "<cmd>NvimTmuxNavigateRight<cr>",
        { noremap = true, desc = "Go to right window", silent = true },
      },
      -- { "<C-\\>", "<cmd>NvimTmuxNavigateLastActive<cr>", { desc = "Go to the last active window", silent = true } },
      -- { "<C-h>", "<cmd>NvimTmuxNavigateNext<cr>", { desc = "Go to the next window", silent = true } },
    },
    config = function(user_config)
      require("nvim-tmux-navigation").setup(user_config)
    end,
  },
  -- },
  -- elseif vim.g.multiplexer == "wez" then
  {
    "mrjones2014/smart-splits.nvim",
    lazy = false,
    build = "./kitty/install-kittens.bash",
  -- stylua: ignore
  keys = {
    { "<C-A-Left>",  function() require("smart-splits").resize_left() end,       desc = "Resize left" },
    { "<C-A-Down>",  function() require("smart-splits").resize_down() end,       desc = "Resize down" },
    { "<C-A-Up>",    function() require("smart-splits").resize_up() end,         desc = "Resize up" },
    { "<C-A-Right>", function() require("smart-splits").resize_right() end,      desc = "Resize right" },
    { "<C-h>",       function() require("smart-splits").move_cursor_left() end,  desc = "Move cursor left" },
    { "<C-j>",       function() require("smart-splits").move_cursor_down() end,  desc = "Move cursor down" },
    { "<C-k>",       function() require("smart-splits").move_cursor_up() end,    desc = "Move cursor up" },
    { "<C-l>",       function() require("smart-splits").move_cursor_right() end, desc = "Move cursor right" },
  },
  },
}
-- else
--   return {}
-- end

return {
  "mrjones2014/smart-splits.nvim",
  build = "./kitty/install-kittens.bash",
  event = "VeryLazy",
  -- stylua: ignore
  keys = {
    -- { "<M-C-Left>",  function() require("smart-splits").resize_left() end,       desc = "Resize left" },
    -- { "<M-C-Down>",  function() require("smart-splits").resize_down() end,       desc = "Resize down" },
    -- { "<M-C-Up>",    function() require("smart-splits").resize_up() end,         desc = "Resize up" },
    -- { "<M-C-Right>", function() require("smart-splits").resize_right() end,      desc = "Resize right" },
    { "<C-Left>",  function() require("smart-splits").resize_left() end,       desc = "Resize Left" },
    { "<C-Down>",  function() require("smart-splits").resize_down() end,       desc = "Resize Down" },
    { "<C-Up>",    function() require("smart-splits").resize_up() end,         desc = "Resize Up" },
    { "<C-Right>", function() require("smart-splits").resize_right() end,      desc = "Resize Right" },
    { "<C-h>",     function() require("smart-splits").move_cursor_left() end,  desc = "Move Cursor Left" },
    { "<C-j>",     function() require("smart-splits").move_cursor_down() end,  desc = "Move Cursor Down" },
    { "<C-k>",     function() require("smart-splits").move_cursor_up() end,    desc = "Move Cursor Up" },
    { "<C-l>",     function() require("smart-splits").move_cursor_right() end, desc = "Move Cursor Right" },
    { "<M-Left>",  function() require("smart-splits").swap_buf_left() end,     desc = "Swap Buffer Left" },
    { "<M-Down>",  function() require("smart-splits").swap_buf_down() end,     desc = "Swap Buffer Down" },
    { "<M-Up>",    function() require("smart-splits").swap_buf_up() end,       desc = "Swap Buffer Up" },
    { "<M-Right>", function() require("smart-splits").swap_buf_right() end,    desc = "Swap Buffer Right" },
  },
}

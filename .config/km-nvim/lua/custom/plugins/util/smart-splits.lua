return {
  "mrjones2014/smart-splits.nvim",
  build = "./kitty/install-kittens.bash",
  -- Kitty depends on IS_NVIM var, so can't lazy load
  event = "VeryLazy",

  -- stylua: ignore
  keys = {
    -- { "<M-h>", function() require("smart-splits").resize_left() end, desc = "Resize Left" },
    -- { "<M-j>", function() require("smart-splits").resize_down() end, desc = "Resize Down" },
    -- { "<M-k>", function() require("smart-splits").resize_up() end, desc = "Resize Up" },
    -- { "<M-l>", function() require("smart-splits").resize_right() end, desc = "Resize Right" },

    -- resize windows
    { "<C-Left>",  function() require("smart-splits").resize_left() end,       desc = "Resize Left" },
    { "<C-Down>",  function() require("smart-splits").resize_down() end,       desc = "Resize Down" },
    { "<C-Up>",    function() require("smart-splits").resize_up() end,         desc = "Resize Up" },
    { "<C-Right>", function() require("smart-splits").resize_right() end,      desc = "Resize Right" },

    -- moving between splits
    { "<C-h>",     function() require("smart-splits").move_cursor_left() end,  desc = "Move Cursor Left" },
    { "<C-j>",     function() require("smart-splits").move_cursor_down() end,  desc = "Move Cursor Down" },
    { "<C-k>",     function() require("smart-splits").move_cursor_up() end,    desc = "Move Cursor Up" },
    { "<C-l>",     function() require("smart-splits").move_cursor_right() end, desc = "Move Cursor Right" },
    { "<C-\\>",    function() require("smart-splits").move_cursor_previous() end, desc = "Move to Previous Split" },

    -- swapping buffers
    { "<M-Left>",  function() require("smart-splits").swap_buf_left() end,     desc = "Swap Buffer Left" },
    { "<M-Down>",  function() require("smart-splits").swap_buf_down() end,     desc = "Swap Buffer Down" },
    { "<M-Up>",    function() require("smart-splits").swap_buf_up() end,       desc = "Swap Buffer Up" },
    { "<M-Right>", function() require("smart-splits").swap_buf_right() end,    desc = "Swap Buffer Right" },
  },
}

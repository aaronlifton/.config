local prefix = "<leader>ay"

return {
  "wasabeef/yank-for-claude.nvim",
  config = function()
    require("yank-for-claude").setup()
  end,
  keys = {
    -- Reference only
    {
      prefix .. "v",
      function()
        require("yank-for-claude").yank_visual()
      end,
      mode = "v",
      desc = "Yank for Claude",
    },
    {
      prefix .. "l",
      function()
        require("yank-for-claude").yank_line()
      end,
      mode = "n",
      desc = "Yank line for Claude",
    },

    -- Reference + Code
    {
      prefix .. "V",
      function()
        require("yank-for-claude").yank_visual_with_content()
      end,
      mode = "v",
      desc = "Yank with content",
    },
    {
      prefix .. "L",
      function()
        require("yank-for-claude").yank_line_with_content()
      end,
      mode = "n",
      desc = "Yank line with content",
    },
  },
}

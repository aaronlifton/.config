return {
  "Wansmer/treesj",
  -- event = "VeryLazy",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    use_default_keymaps = false,
    max_join_length = 180,
  },
  keys = {
    {
      "gJ",
      function()
        require("treesj").toggle({ split = { recursive = false } })
      end,
      desc = "SplitJoin",
    },
    {
      "g<C-s>",
      function()
        require("treesj").split({ split = { recursive = false } })
      end,
      desc = "SplitJoin (Recursive)",
    },
  },
  config = function(_, opts)
    require("treesj").setup(opts)
  end,
}

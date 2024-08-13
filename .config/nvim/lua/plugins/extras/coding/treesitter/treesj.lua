return {
  "Wansmer/treesj",
  event = "VeryLazy",
  -- keys = { "<space>m", "<space>j", "<space>s" },
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  opts = {
    use_default_keymaps = false,
    max_join_length = 180,
  },
  config = function(_, opts)
    require("treesj").setup(opts)
  end,
}

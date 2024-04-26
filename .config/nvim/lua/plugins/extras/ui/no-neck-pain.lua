return {
  {
    "shortcuts/no-neck-pain.nvim",
    event = "VeryLazy",
    version = "*",
    config = function()
      require("no-neck-pain").setup()
    end,
  },
}

return {
  "nvim-mini/mini.align",
  opts = {},
  keys = {
    -- In normal mode, conflicts with leap.nvim treesitter select
    { "ga", mode = { "v" }, desc = "Align" },
    { "gA", mode = { "n", "v" }, desc = "Align Preview" },
  },
}

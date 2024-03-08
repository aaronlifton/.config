return {
  "sustech-data/wildfire.nvim",
  event = "BufEnter",
  opts = {},
  config = function(_, opts)
    require("wildfire").setup(opts)
  end,
}

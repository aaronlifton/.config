return {
  "HiPhish/rainbow-delimiters.nvim",
  enabled = false,
  event = "LazyFile",
  config = function()
    require("rainbow-delimiters.setup").setup({
      highlight = {
        "RainbowDelimiterBlue",
        "RainbowDelimiterYellow",
        "RainbowDelimiterViolet",
        "RainbowDelimiterOrange",
        "RainbowDelimiterCyan",
        "RainbowDelimiterRed",
        "RainbowDelimiterGreen",
      },
    })
  end,
}

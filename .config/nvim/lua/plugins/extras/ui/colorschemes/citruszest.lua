return {
  "zootedb0t/citruszest.nvim",
  lazy = false,
  priority = 1000,
  dependencies = {
    {
      "nvim-lualine/lualine.nvim",
      optional = true,
      opts = {
        theme = "citruszest",
      },
    },
  },
  config = function(_, opts)
    require("citruszest").setup({
      option = {
        transparent = false, -- Enable/Disable transparency
        bold = false,
        italic = true,
      },
      -- Override default highlight style in this table
      -- E.g If you want to override `Constant` highlight style
      style = {
        -- This will change Constant foreground color and make it bold.
        Constant = { fg = "#FFFFFF", bold = true },
      },
    })
  end,
}

return {
  {
    "nyoom-engineering/oxocarbon.nvim",
    event = "VeryLazy",
    name = "oxocarbon",
    config = function(_, opts)
      -- vim.opt.background = "dark" -- set this to dark or light
      -- vim.cmd.colorscheme("oxocarbon")
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    optional = true,
    opts = {
      theme = "oxocarbon",
    },
  },
}

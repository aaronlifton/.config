return {
  {
    "diegoulloao/neofusion.nvim",
    priority = 1000,
    opts = {
      terminal_colors = true, -- add neovim terminal colors
      undercurl = true,
      underline = true,
      bold = true,
      italic = {
        strings = true,
        emphasis = true,
        comments = true,
        operators = false,
        folds = true,
      },
      strikethrough = true,
      invert_selection = false,
      invert_signs = false,
      invert_tabline = false,
      invert_intend_guides = false,
      inverse = true, -- invert background for search, diffs, statuslines and errors
      palette_overrides = {},
      overrides = {},
      dim_inactive = true,
      transparent_mode = false,
    },
    config = function(_, opts)
      require("neofusion").setup(opts)
      -- vim.o.background = "dark"
      -- vim.cmd([[ colorscheme neofusion ]])
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      opts.options.theme = require("neofusion.lualine") -- default: auto
    end,
  },
}

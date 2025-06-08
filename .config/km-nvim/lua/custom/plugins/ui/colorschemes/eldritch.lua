return {
  "eldritch-theme/eldritch.nvim",
  lazy = false,
  priority = 1000,
  opts = {},
  dependencies = {
    {
      "nvim-lualine/lualine.nvim",
      optional = true,
      opts = {
        theme = "eldritch",
      },
    },
    {
      "ibhagwan/fzf-lua",
      optional = true,
      opts = function(_, opts)
        opts.fzf_colors = {
          true,
          bg = "-1",
          gutter = "-1",
        }
      end,
    },
  },
}

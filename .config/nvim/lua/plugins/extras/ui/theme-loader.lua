return {
  {
    "rafi/theme-loader.nvim",
    lazy = false,
    priority = 999,
    opts = {},
    config = function(_, otps)
      require("theme-loader").setup(otps)
      require("config.highlights").setup()
    end,
  },
  -- {
  --   "LazyVim/LazyVim",
  --   config = function(_, opts)
  --     opts = opts or {}
  --     -- disable the colorscheme
  --     opts.colorscheme = function() end
  --     require("lazyvim").setup(opts)
  --   end,
  -- },
}

return {
  "2giosangmitom/nightfall.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    -- color_overrides = {
    --   all = { foreground = "#ffffff" },
    --   nightfall = { background = "#ff0000" },
    -- },
    -- highlight_overrides = {
    --   all = {
    --     Normal = { bg = "#120809" },
    --   },
    --   nightfall = function(colors)
    --     return {
    --       Normal = { bg = colors.black },
    --     }
    --   end,
    --   maron = {
    --     Normal = { fg = "#ffffff" },
    --   },
    -- },
  }, -- Add custom configuration here
  config = function(_, opts)
    require("nightfall").setup(opts)
    vim.cmd("colorscheme nightfall") -- Choose from: nightfall, deeper-night, maron, nord
  end,
}

return {
  "nyoom-engineering/oxocarbon.nvim",
  name = "oxocarbon",
  dependencies = {
    {
      "nvim-lualine/lualine.nvim",
      optional = true,
      opts = {
        theme = "oxocarbon",
      },
    },
  },
  init = function()
    vim.opt.background = "dark" -- set this to dark or light
    vim.cmd.colorscheme("oxocarbon")
  end,
}

return {
  "Shatur/neovim-ayu",
  optional = false,
  setup = require("ayu").setup({}),
  dependencices = {
    require("lualine").setup({
      options = {
        theme = "ayu",
      },
    }),
  },
}

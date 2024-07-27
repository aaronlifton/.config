return {
  "echasnovski/mini.nvim",
  config = function()
    require("mini.move").setup()
    require("mini.extra").setup()
    require("mini.colors").setup()
  end,
}

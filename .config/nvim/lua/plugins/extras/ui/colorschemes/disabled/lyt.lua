-- https://github.com/github-main-user/lytmode.nvim
return {
  "github-main-user/lytmode.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("lytmode").setup()
  end,
}

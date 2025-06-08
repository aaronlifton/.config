return {
  "chrisgrieser/nvim-puppeteer",
  lazy = true,
  dependencies = {
    { "nvim-treesitter/nvim-treesitter", optional = true },
  },
  init = function()
    vim.g.puppeteer_disable_filetypes = { "lua" }
  end,
}

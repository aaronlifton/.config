return {
  "nvim-treesitter/nvim-treesitter",
  optional = true,
  dependencies = { "RRethy/nvim-treesitter-endwise", lazy = true },
  opts = {
    endwise = {
      enable = true,
    },
  },
}

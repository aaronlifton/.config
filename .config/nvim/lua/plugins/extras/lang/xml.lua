return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = {
        "xml",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        lemminx = {},
      },
    },
  },
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = {
      ensure_installed = {
        "lemminx",
      },
    },
  },
}

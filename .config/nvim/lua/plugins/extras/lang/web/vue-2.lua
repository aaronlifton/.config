return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = {
        "vue",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        vuels = {},
        volar = {
          enabled = false,
        },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    optional = true,
    opts = {
      ensure_installed = {
        "vetur-vls",
      },
    },
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "vue-2",
      },
    },
  },
}

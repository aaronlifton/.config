return {
  "embark-theme/vim",
  as = "embark",
  dependencies = {
    {
      "nvim-lualine/lualine.nvim",
      optional = true,
      opts = {
        theme = "embark",
      },
    },
  },
}

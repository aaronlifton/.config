return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = function(_, opts)
      vim.tbl_deep_extend("force", opts, {
        strict = true,
        override_by_extension = {
          astro = {
            icon = "",
            color = "#EF8547",
            name = "astro",
          },
        },
      })
    end,
  },
}

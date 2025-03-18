return {
  { import = "lazyvim.plugins.extras.lang.git" },
  { "petertriho/cmp-git", enabled = false },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "git",
      },
    },
  },
}

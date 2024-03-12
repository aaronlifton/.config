return {
  "miikanissi/modus-themes.nvim",
  name = "modus",
  opts = {},
  config = function(_, opts)
    require("modus-themes").setup(opts)
    -- require("modus-themes").load()
  end,
}

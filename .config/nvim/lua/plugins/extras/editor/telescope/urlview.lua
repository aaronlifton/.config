return {
  "axieax/urlview.nvim",
  -- dependencies = { { "nvim-telescope/telescope.nvim", optional = true } },
  cmd = { "UrlView" },
  keys = { { "<leader>sU", "<cmd>UrlView<cr>", desc = "Search Urls" } },
  opts = {
    default_picker = "native",
  },
}

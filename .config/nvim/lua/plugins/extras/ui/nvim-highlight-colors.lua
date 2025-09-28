return vim.g.highlight_provider == "mini.hipatterns" and {
  import = "lazyvim.extras.util.hipatterns",
} or {
  { "uga-rosa/ccc.nvim", enabled = false },
  { "nvim-mini/mini.hipatterns", enabled = false },
  {
    "brenoprata10/nvim-highlight-colors",
    event = "VeryLazy",
    opts = {},
    -- stylua: ignore
    keys = {
      { "<leader>uH", function() require("nvim-highlight-colors").toggle() end, desc = "Toggle Highlight Colors" },
    },
  },
}

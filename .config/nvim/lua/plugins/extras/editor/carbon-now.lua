return {
  {
    "kristijanhusak/vim-carbon-now-sh",
    cmd = { "CarbonNowSh" },
    keys = {
      { "<leader>cUc", ":CarbonNowSh<cr>", mode = { "n", "v" }, desc = "Screenshot Code", silent = true },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>cU"] = { name = "Utilities" },
      },
    },
  },
}

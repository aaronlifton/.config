return {
  "benfowler/telescope-luasnip.nvim",
  dependencies = {
    "L3MON4D3/LuaSnip",
  },
  config = function()
    require("lazyvim.util").on_load("telescope.nvim", function()
      require("telescope").load_extension("luasnip")
    end)
  end,
  keys = {
    { "<leader>ns", "<cmd>Telescope luasnip<CR>", desc = "Luasnip (Snippets)" },
  },
}

return {
  {
    "shortcuts/no-neck-pain.nvim",
    event = "VeryLazy",
    version = "*",
    keys = {
      {
        "<leader>uZ",
        function()
          require("neo-tree.command").execute({ toggle = true })
          vim.api.nvim_command("NoNeckPain")
        end,
        desc = "No Neck Pain",
      },
    },
    config = function()
      require("no-neck-pain").setup()
    end,
  },
}

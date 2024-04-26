return {
  { -- refactoring
    "ThePrimeagen/refactoring.nvim",
    lazy = true,
    dependencies = {
      { "nvim-lua/plenary.nvim" },
      { "nvim-treesitter/nvim-treesitter" },
    },
    keys = {
      {
        "<leader>cR",
        function()
          require("refactoring").select_refactor()
        end,
        mode = { "n", "x", "v" },
        desc = "Refactor",
      },
      {
        "<leader>dv",
        function()
          require("refactoring").debug.print_var()
        end,
        mode = { "n", "x", "v" },
        desc = "Print Variable",
      },
      {
        "<leader>dR",
        function()
          require("refactoring").debug.cleanup()
        end,
        desc = "Remove Printed Variables",
      },
      {
        "<leader>rr",
        "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
        desc = "Select refactor...",
        mode = "v",
      },
      -- {
      --   "<leader>cE",
      --   "<cmd>lua require('refactoring').select_refactor()<cr>",
      --   desc = "Select refactor...",
      --   mode = "v",
      -- },
      -- vim.keymap.set("x", "<leader>re", ":Refactor extract ")
      -- vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")
      --
      -- vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")
      --
      -- vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")
      --
      -- vim.keymap.set( "n", "<leader>rI", ":Refactor inline_func")
      --
      -- vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
      -- vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")
    },
    opts = {},
    config = function(_, opts)
      require("refactoring").setup(opts)
      require("telescope").load_extension("refactoring")
    end,
  },
}

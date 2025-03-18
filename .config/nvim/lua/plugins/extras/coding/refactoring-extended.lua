return {
  "ThePrimeagen/refactoring.nvim",
  optional = true,
  dependencies = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-treesitter/nvim-treesitter" },
  },
  opts = {
    show_success_message = true,
    print_var_statements = {
      js = "console.log({'%s': %s})",
      ts = "console.log({'%s': %s})",
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>cR", function() require("refactoring").select_refactor() end, mode = { "n", "x", "v" }, desc = "Refactor" },
    { "<leader>dv", function() require("refactoring").debug.print_var() end, mode = { "n", "x", "v" }, desc = "Print Variable" },
    { "<leader>dR", function() require("refactoring").debug.cleanup() end, desc = "Remove Printed Variables" },
  },
}

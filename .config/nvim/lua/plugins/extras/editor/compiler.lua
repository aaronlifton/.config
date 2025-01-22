return {
  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = {
      "nvim-telescope/telescope.nvim",
      { "stevearc/overseer.nvim", optional = true },
    },
    opts = {},
    -- stylua: ignore
    keys = {
      { "<F3>", "<cmd>CompilerOpen<cr>", desc = "Open Compiler" },
      { "<C-S-D-3>", function() vim.cmd("CompilerStop") vim.cmd("CompilerRedo") end, desc = "Redo Compiler" },
      { "<F4>", "<cmd>CompilerToggleResults<cr>", desc = "Toggle Compiler Results" },
    },
  },
}

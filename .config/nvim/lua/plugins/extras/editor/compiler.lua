return {
  {
    "Zeioth/compiler.nvim",
    cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
    dependencies = { "stevearc/overseer.nvim" },
    opts = {},
    -- stylua: ignore
    keys = {
      { "<F3>", "<cmd>CompilerOpen<cr>", desc = "Open Compiler" },
      { "<S-F3>", function() vim.cmd("CompilerStop") vim.cmd("CompilerRedo") end, desc = "Redo Compiler" },
      { "<F4>", "<cmd>CompilerToggleResults<cr>", desc = "Toggle Compiler Results" },
    },
  },
  {
    "stevearc/overseer.nvim",
    -- commit = "68a2d344cea4a2e11acfb5690dc8ecd1a1ec0ce0",
    cmd = {
      "OverseerOpen",
      "OverseerClose",
      "OverseerToggle",
      "OverseerSaveBundle",
      "OverseerLoadBundle",
      "OverseerDeleteBundle",
      "OverseerRunCmd",
      "OverseerRun",
      "OverseerInfo",
      "OverseerBuild",
      "OverseerQuickAction",
      "OverseerTaskAction ",
      "OverseerClearCache",
    },
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 15,
        max_height = 15,
        default_detail = 1,
      },
    },
    config = function()
      require("overseer").setup({
        templates = { "builtin", "user.astro_check" },
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, { "overseer" })
    end,
  },
}

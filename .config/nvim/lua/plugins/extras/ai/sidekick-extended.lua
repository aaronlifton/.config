return {
  { import = "lazyvim.plugins.extras.ai.sidekick" },
  {
    "folke/sidekick.nvim",
    keys = {
      {
        "<leader>aN",
        function()
          require("sidekick.nes").toggle()
        end,
        mode = { "n" },
        desc = "Toggle NES",
      },
      {
        "<leader>ac",
        function()
          require("sidekick.cli").toggle({ name = "codex", focus = true })
        end,
        desc = "Sidekick Codex Toggle",
      },
      {
        "<leader>aC",
        function()
          require("sidekick.cli").toggle({ name = "claude", focus = true })
        end,
        desc = "Sidekick Claude Toggle",
      },
    },
  },
}

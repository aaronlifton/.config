return {
  "chrisgrieser/nvim-tinygit",
  ft = { "git_rebase", "gitcommit" },
  event = "VeryLazy",
  dependencies = {
    "stevearc/dressing.nvim",
    -- "nvim-telescope/telescope.nvim", -- optional, but recommended
    "rcarriga/nvim-notify", -- optional, but recommended
  },
  keys = {
    -- stylua: ignore start
    {"<Leader>gxn", function() require("tinygit").smartCommit() end, desc = "New commit" },
    {"<Leader>gxP", function() require("tinygit").push { forceWithLease = true } end, desc = "Push" },
    {"<Leader>gxs", function() require("tinygit").interactiveStaging() end, desc = "Interactive Staging" },
    -- stylua: ignore end
  },
}

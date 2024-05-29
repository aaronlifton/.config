return {
  "kawre/leetcode.nvim",
  build = ":TSUpdate html",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim", -- required by telescope
    "MunifTanjim/nui.nvim",

    -- optional
    "nvim-treesitter/nvim-treesitter",
    "rcarriga/nvim-notify",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    -- configuration goes here
    lang = "ruby",
    -- lang = "typescript",
    -- keys = {
    --   toggle = { "<leader>lq" }, ---@type string|string[]
    --   confirm = { "<leader>l<CR>" }, ---@type string|string[]
    --
    --   reset_testcases = "<leader>lr", ---@type string
    --   use_testcase = "<leader>lU", ---@type string
    --   focus_testcases = "<leader>lH", ---@type string
    --   focus_result = "<leader>lL", ---@type string
    -- },
  },
}

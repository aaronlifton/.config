-- requires libgit2
return {
  "SuperBo/fugit2.nvim",
  event = "VeryLazy",
  cmd = { "Fugit2", "Fugit2Diff", "Fugit2Graph" },
  rocks = {
    hererocks = true,
  },
  opts = {
    libgit2_path = "/opt/homebrew/lib/libgit2.dylib",
    -- external_diffview = true,
    width = 100,
  },
  -- specs = {
  --   { import = "astrocommunity.git.diffview-nvim" }, -- optional dependency
  --   { import = "astrocommunity.git.nvim-tinygit" }, -- optional dependency
  -- },
  keys = {
    { "<Leader>g<C-n>", "<Cmd>Fugit2<CR>", desc = "Fugit2" },
  },
  dependencies = {
    "MunifTanjim/nui.nvim",
    -- "nvim-tree/nvim-web-devicons", -- Mocked by mini.icons
    "nvim-lua/plenary.nvim",
  },
}

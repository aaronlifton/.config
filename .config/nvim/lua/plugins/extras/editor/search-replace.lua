return {
  {
    "roobert/search-replace.nvim",
    opts = {
      default_replace_single_buffer_options = "gcI",
      default_replace_multi_buffer_options = "egcI",
    },
    -- stylua: ignore
    keys = {
      { "<leader>srb", "<CMD>SearchReplaceSingleBufferVisualSelection<CR>", desc = "Buffer", mode = "v" },
      { "<leader>srv", "<CMD>SearchReplaceWithinVisualSelection<CR>", desc = "Visual Selection", mode = "v" },
      { "<leader>srw", "<CMD>SearchReplaceWithinVisualSelectionCWord<CR>", desc = "Word on Buffer", mode = "v" },

      {  "<leader>srb", "<CMD>SearchReplaceSingleBufferOpen<CR>", desc = "Buffer", mode = "n" },
      {  "<leader>srw", "<CMD>SearchReplaceSingleBufferCWord<CR>", desc = "Word on Buffer", mode = "n" },
      {  "<leader>srW", "<CMD>SearchReplaceSingleBufferCWORD<CR>", desc = "WORD on Buffer", mode = "n" },
      {  "<leader>sre", "<CMD>SearchReplaceSingleBufferCExpr<CR>", desc = "Expression on Buffer", mode = "n" },
      {  "<leader>srf", "<CMD>SearchReplaceSingleBufferCFile<CR>", desc = "File on Buffer", mode = "n" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        { "<leader>sr", group = "replace", icon = " " },
      },
    },
  },
  -- {
  --   "MagicDuck/grug-far.nvim",
  --   enabled = false,
  -- },
}

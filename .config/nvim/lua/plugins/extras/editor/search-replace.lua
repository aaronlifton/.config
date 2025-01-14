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
      -- {  "<leader>srf", "<CMD>SearchReplaceSingleBufferCFile<CR>", desc = "File on Buffer", mode = "n" },

    -- { "n", "<leader>rbs", "<CMD>SearchReplaceMultiBufferSelections<CR>", desc = "Search and Replace in Multi Buffer Selections" },
    -- { "n", "<leader>rbo", "<CMD>SearchReplaceMultiBufferOpen<CR>", desc = "Search and Replace in Multi Buffer, Open" },
    -- { "n", "<leader>rbw", "<CMD>SearchReplaceMultiBufferCWord<CR>", desc = "Search and Replace in Multi Buffer (Current Word)" },
    -- { "n", "<leader>rbW", "<CMD>SearchReplaceMultiBufferCWORD<CR>", desc = "Search and Replace in Multi Buffer (Current WORD)" },
    -- { "n", "<leader>rbe", "<CMD>SearchReplaceMultiBufferCExpr<CR>", desc = "Search and Replace in Multi Buffer (Current Expression)" },
    -- { "n", "<leader>rbf", "<CMD>SearchReplaceMultiBufferCFile<CR>", desc = "Search and Replace in Multi Buffer (Current File)" },
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
  {
    "MagicDuck/grug-far.nvim",
    optional = true,
    keys = {
      {
        "<leader>srp",
        function()
          local grug = require("grug-far")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Project",
      },
      {
        "<leader>srF",
        function()
          local grug = require("grug-far")
          local current_file_relpath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")
          grug.open({
            -- extraRgArgs = { "--", current_file_relpath },
            transient = true,
            prefills = {
              filesFilter = current_file_relpath,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Current File",
      },
      {
        "<leader>src",
        function()
          local grug = require("grug-far")
          local cwd = vim.fn.fnamemodify(vim.fn.expand("%"), ":h")
          local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
          grug.open({
            transient = true,
            prefills = {
              paths = cwd,
              filesFilter = ext and ext ~= "" and "*." .. ext or nil,
            },
          })
        end,
        mode = { "n", "v" },
        desc = "Cwd",
      },
    },
  },
}

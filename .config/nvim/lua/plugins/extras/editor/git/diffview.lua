local prefix = "<leader>gC"
local prefix2 = "<leader>gH"
local prefix3 = "<leader>gD"

return {
  {
    "sindrets/diffview.nvim",
    keys = {
      { prefix2 .. "h", "<cmd>DiffviewFileHistory<CR>", desc = "Diff File History" },
      { prefix2 .. "m", "<cmd>DiffviewFileHistory master<CR>", desc = "Diff File History (master)" },
      { prefix2 .. "M", "<cmd>DiffviewFileHistory main<CR>", desc = "Diff File History (main)" },
      { prefix2 .. "h", ":'<,'>DiffviewFileHistory", desc = "Diff View (Selection)", mode = "v" },
      { prefix3 .. "h", "<cmd>DiffviewOpen<CR>", desc = "Diff View" },
      { prefix3 .. "H", "<cmd>DiffviewOpen HEAD~1<CR>", desc = "Diff View (HEAD~1)" },
      { prefix3 .. "m", "<cmd>DiffviewOpen master<CR>", desc = "Diff View (master)" },
      { prefix3 .. "M", "<cmd>DiffviewOpen main<CR>", desc = "Diff View (main)" },
      { prefix3 .. "d", "<cmd>DiffviewOpen development<CR>", desc = "Diff View (development)" },
      {
        prefix3 .. "x",
        function()
          local input = vim.fn.input("compare: ")
          vim.api.nvim_command("DiffviewOpen " .. input)
        end,
        desc = "Diff View (pick)",
      },
      {
        prefix3 .. "f",
        function()
          local input = vim.fn.input("compare: ")
          local path = vim.fn.expand("%p")
          vim.api.nvim_command("DiffviewOpen " .. input .. " -- " .. path)
        end,
        desc = "Diff View (pick - current file)",
      },
      -- Alternative mappings
      -- { "<leader>gd", "<cmd>DiffviewFileHistory<CR>", desc = "Diff File History" },
      -- { "<leader>gF", "<cmd>DiffviewFileHistory master<CR>", desc = "Diff File History (master)" },
      -- { "<leader>gF", ":'<,'>DiffviewFileHistory", desc = "Diff View (Selection)", mode = "v" },
      -- { prefix3, "<cmd>DiffviewOpen<CR>", desc = "Diff View Open" },
      -- { "<leader>gM", "<cmd>DiffviewOpen master<CR>", desc = "Diff View (master)" },
      -- { "<leader>gm", "<cmd>DiffviewOpen master -- " .. vim.fn.expand("%") .. "<CR>", desc = "Diff View (master)" },
      -- { prefix2, "<cmd>DiffviewOpen HEAD~1<CR>", desc = "Diff View (HEAD~1)" },
    },
    opts = function(_, opts)
      local actions = require("diffview.actions")

      opts.enhanced_diff_hl = true
      opts.view = {
        default = { winbar_info = true },
        file_history = { winbar_info = true },
      }
      opts.hooks = {
        diff_buf_read = function(bufnr)
          vim.b[bufnr].view_activated = false
          require("git-conflict").setup()
          vim.api.nvim_command("GitConflictRefresh")
        end,
      }

      opts.keymaps = {
        --stylua: ignore
        view = {
          { "n", prefix .. "o",  actions.conflict_choose("ours"),        { desc = "Choose the OURS version of a conflict" } },
          { "n", prefix .. "t",  actions.conflict_choose("theirs"),      { desc = "Choose the THEIRS version of a conflict" } },
          { "n", prefix .. "b",  actions.conflict_choose("base"),        { desc = "Choose the BASE version of a conflict" } },
          { "n", prefix .. "a",  actions.conflict_choose("all"),         { desc = "Choose all the versions of a conflict" } },
          { "n", prefix .. "x",  actions.conflict_choose("none"),        { desc = "Delete the conflict region" } },
          { "n", prefix .. "O",  actions.conflict_choose_all("ours"),    { desc = "Choose the OURS version of a conflict for the whole file" } },
          { "n", prefix .. "T",  actions.conflict_choose_all("theirs"),  { desc = "Choose the THEIRS version of a conflict for the whole file" } },
          { "n", prefix .. "B",  actions.conflict_choose_all("base"),    { desc = "Choose the BASE version of a conflict for the whole file" } },
          { "n", prefix .. "A",  actions.conflict_choose_all("all"),     { desc = "Choose all the versions of a conflict for the whole file" } },
          { "n", prefix .. "X",  actions.conflict_choose_all("none"),    { desc = "Delete the conflict region for the whole file" } },
        },
        --stylua: ignore
        file_panel = {
          { "n", prefix .. "O",     actions.conflict_choose_all("ours"),    { desc = "Choose the OURS version of a conflict for the whole file" } },
          { "n", prefix .. "T",     actions.conflict_choose_all("theirs"),  { desc = "Choose the THEIRS version of a conflict for the whole file" } },
          { "n", prefix .. "B",     actions.conflict_choose_all("base"),    { desc = "Choose the BASE version of a conflict for the whole file" } },
          { "n", prefix .. "A",     actions.conflict_choose_all("all"),     { desc = "Choose all the versions of a conflict for the whole file" } },
          { "n", prefix .. "X",     actions.conflict_choose_all("none"),    { desc = "Delete the conflict region for the whole file" } },
        },
      }
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        mode = "n",
        -- { prefix, group = "conflicts", icon = { icon = " ", color = "red" } },
        { prefix3, group = "Diff View Open" },
        { prefix2, group = "Diff File History" },
      },
    },
  },
}

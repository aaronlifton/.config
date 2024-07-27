return {
  {
    "sindrets/diffview.nvim",
    keys = {
      { "<leader>gHh", "<cmd>DiffviewFileHistory<CR>", desc = "Diff File History" },
      { "<leader>gHm", "<cmd>DiffviewFileHistory master<CR>", desc = "Diff File History (master)" },
      { "<leader>gHM", "<cmd>DiffviewFileHistory main<CR>", desc = "Diff File History (main)" },
      { "<leader>gHh", ":'<,'>DiffviewFileHistory", desc = "Diff View (Selection)", mode = "v" },
      { "<leader>gDh", "<cmd>DiffviewOpen<CR>", desc = "Diff View" },
      { "<leader>gDH", "<cmd>DiffviewOpen HEAD~1<CR>", desc = "Diff View (HEAD~1)" },
      { "<leader>gDm", "<cmd>DiffviewOpen master<CR>", desc = "Diff View (master)" },
      { "<leader>gDM", "<cmd>DiffviewOpen main<CR>", desc = "Diff View (main)" },
      { "<leader>gDd", "<cmd>DiffviewOpen development<CR>", desc = "Diff View (development)" },
      {
        "<leader>gDx",
        function()
          local input = vim.fn.input("compare: ")
          vim.api.nvim_command("DiffviewOpen " .. input)
        end,
        desc = "Diff View (pick)",
      },
      {
        "<leader>gDf",
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
      -- { "<leader>gD", "<cmd>DiffviewOpen<CR>", desc = "Diff View Open" },
      -- { "<leader>gM", "<cmd>DiffviewOpen master<CR>", desc = "Diff View (master)" },
      -- { "<leader>gm", "<cmd>DiffviewOpen master -- " .. vim.fn.expand("%") .. "<CR>", desc = "Diff View (master)" },
      -- { "<leader>gH", "<cmd>DiffviewOpen HEAD~1<CR>", desc = "Diff View (HEAD~1)" },
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
          { "n", "<leader>gCo",  actions.conflict_choose("ours"),        { desc = "Choose the OURS version of a conflict" } },
          { "n", "<leader>gCt",  actions.conflict_choose("theirs"),      { desc = "Choose the THEIRS version of a conflict" } },
          { "n", "<leader>gCb",  actions.conflict_choose("base"),        { desc = "Choose the BASE version of a conflict" } },
          { "n", "<leader>gCa",  actions.conflict_choose("all"),         { desc = "Choose all the versions of a conflict" } },
          { "n", "<leader>gCx",  actions.conflict_choose("none"),        { desc = "Delete the conflict region" } },
          { "n", "<leader>gCO",  actions.conflict_choose_all("ours"),    { desc = "Choose the OURS version of a conflict for the whole file" } },
          { "n", "<leader>gCT",  actions.conflict_choose_all("theirs"),  { desc = "Choose the THEIRS version of a conflict for the whole file" } },
          { "n", "<leader>gCB",  actions.conflict_choose_all("base"),    { desc = "Choose the BASE version of a conflict for the whole file" } },
          { "n", "<leader>gCA",  actions.conflict_choose_all("all"),     { desc = "Choose all the versions of a conflict for the whole file" } },
          { "n", "<leader>gCX",  actions.conflict_choose_all("none"),    { desc = "Delete the conflict region for the whole file" } },
        },
        --stylua: ignore
        file_panel = {
          { "n", "<leader>gCO",     actions.conflict_choose_all("ours"),    { desc = "Choose the OURS version of a conflict for the whole file" } },
          { "n", "<leader>gCT",     actions.conflict_choose_all("theirs"),  { desc = "Choose the THEIRS version of a conflict for the whole file" } },
          { "n", "<leader>gCB",     actions.conflict_choose_all("base"),    { desc = "Choose the BASE version of a conflict for the whole file" } },
          { "n", "<leader>gCA",     actions.conflict_choose_all("all"),     { desc = "Choose all the versions of a conflict for the whole file" } },
          { "n", "<leader>gCX",     actions.conflict_choose_all("none"),    { desc = "Delete the conflict region for the whole file" } },
        },
      }
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        mode = "n",
        { "<leader>gD", group = "Diff View Open" },
        { "<leader>gH", group = "Diff File History" },
      },
    },
  },
}

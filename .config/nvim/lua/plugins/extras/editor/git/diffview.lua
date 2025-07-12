local conflict_prefix = "<leader>gC"
local file_history_prefix = "<leader>gH"
local diffview_prefix = "<leader>gD"

local function toggle_diffview(cmd)
  if next(require("diffview.lib").views) == nil then
    vim.cmd(cmd)
  else
    vim.cmd("DiffviewClose")
  end
end

local function toggle_diffview_func(func)
  if next(require("diffview.lib").views) == nil then
    func()
  else
    vim.cmd("DiffviewClose")
  end
end

return {
  {
    "sindrets/diffview.nvim",
    keys = {
      -- { file_history_prefix .. "h", "<cmd>DiffviewFileHistory<CR>", desc = "Diff File History" },
      {
        file_history_prefix .. "h",
        function()
          toggle_diffview("DiffviewFileHistory")
        end,
        desc = "Diff File History",
      },
      -- stylua: ignore start
      { file_history_prefix .. "f", function() toggle_diffview("DiffviewFileHistory %") end, desc = "Diff Current File" },
      -- { file_history_prefix .. "M", "<cmd>DiffviewFileHistory master<CR>", desc = "Diff File History (master)" },
      { file_history_prefix .. "M", function() toggle_diffview("DiffviewFileHistory master") end, desc = "Diff File History (master)" },
      -- { file_history_prefix .. "M", "<cmd>DiffviewFileHistory main<CR>", desc = "Diff File History (main)" },
      { file_history_prefix .. "m", function() toggle_diffview("DiffviewFileHistory main") end, desc = "Diff File History (main)" },
      -- TODO: can this be wrapped?
      { file_history_prefix .. "h", ":'<,'>DiffviewFileHistory", desc = "Diff View (Selection)", mode = "v" },
      -- { diffview_prefix .. "h", "<cmd>DiffviewOpen<CR>", desc = "Diff View" },
      { diffview_prefix .. "h", function() toggle_diffview("DiffviewOpen") end, desc = "Diff View" },
      -- { diffview_prefix .. "H", "<cmd>DiffviewOpen HEAD~1<CR>", desc = "Diff View (HEAD~1)" },
      { diffview_prefix .. "H", function() toggle_diffview("DiffviewOpen HEAD~1") end, desc = "Diff View (HEAD~1)" },
      -- { diffview_prefix .. "m", "<cmd>DiffviewOpen master<CR>", desc = "Diff View (master)" },
      { diffview_prefix .. "M", function() toggle_diffview("DiffviewOpen master") end, desc = "Diff View (master)" },
      -- { diffview_prefix .. "M", "<cmd>DiffviewOpen main<CR>", desc = "Diff View (main)" },
      { diffview_prefix .. "m", function() toggle_diffview("DiffviewOpen main") end, desc = "Diff View (main)" },
      -- { diffview_prefix .. "d", "<cmd>DiffviewOpen development<CR>", desc = "Diff View (development)" },
      { diffview_prefix .. "d", function() toggle_diffview("DiffviewOpen development") end, desc = "Diff View (development)" },
      {
        diffview_prefix .. "x",
        function()
          return toggle_diffview_func(
            function()
              Snacks.input({ prompt = "Compare: ", icon = "" }, function (branch)
                vim.api.nvim_command("DiffviewOpen " .. branch)
              end)
            end
          )
        end,
        desc = "Diff View (pick)",
      },
      {
        diffview_prefix .. "X",
        function()
          return toggle_diffview_func(
            function()
              Snacks.input({ prompt = "From: ", icon = "" }, function(from)
                if from == "" then return end
                Snacks.input({ prompt = "To: ", icon = "" }, function(to)
                  if to == "" then return end
                  vim.api.nvim_command("DiffviewOpen " .. from .. ".." .. to)
                end)
              end)
            end
          )
        end,
        desc = "Diff View (pick to..from)",
      },
      {
        diffview_prefix .. "f",
        function()
          return toggle_diffview_func(
            function()
              Snacks.input({ prompt = "Compare: ", icon = "" }, function(input)
                local path = vim.fn.expand("%p")
                vim.api.nvim_command("DiffviewOpen " .. input .. " -- " .. path)
              end)
            end
          )
        end,
        desc = "Diff View (pick - current file)",
      },
      -- stylua: ignore end
    },
    opts = function(_, opts)
      local actions = require("diffview.actions")

      opts.enhanced_diff_hl = true
      opts.view = {
        default = { winbar_info = true },
        file_history = { winbar_info = true },
      }
      opts.hooks = {
        -- diff_buf_win_enter
        diff_buf_read = function(bufnr)
          -- vim.notify("here")
          vim.b[bufnr].view_activated = false
          require("git-conflict").setup(LazyVim.opts("diffview.nvim"))
          vim.api.nvim_command("GitConflictRefresh")
        end,
        -- view_opened = function(view)
        --   print(("A new %s was opened on tab page %d!"):format(view.class:name(), view.tabpage))
        -- end,
      }

      opts.keymaps = {
        --stylua: ignore
        view = {
          { "n", conflict_prefix .. "o",  actions.conflict_choose("ours"),        { desc = "Choose the OURS version of a conflict" } },
          { "n", conflict_prefix .. "t",  actions.conflict_choose("theirs"),      { desc = "Choose the THEIRS version of a conflict" } },
          { "n", conflict_prefix .. "b",  actions.conflict_choose("base"),        { desc = "Choose the BASE version of a conflict" } },
          { "n", conflict_prefix .. "a",  actions.conflict_choose("all"),         { desc = "Choose all the versions of a conflict" } },
          { "n", conflict_prefix .. "x",  actions.conflict_choose("none"),        { desc = "Delete the conflict region" } },
          { "n", conflict_prefix .. "O",  actions.conflict_choose_all("ours"),    { desc = "Choose the OURS version of a conflict for the whole file" } },
          { "n", conflict_prefix .. "T",  actions.conflict_choose_all("theirs"),  { desc = "Choose the THEIRS version of a conflict for the whole file" } },
          { "n", conflict_prefix .. "B",  actions.conflict_choose_all("base"),    { desc = "Choose the BASE version of a conflict for the whole file" } },
          { "n", conflict_prefix .. "A",  actions.conflict_choose_all("all"),     { desc = "Choose all the versions of a conflict for the whole file" } },
          { "n", conflict_prefix .. "X",  actions.conflict_choose_all("none"),    { desc = "Delete the conflict region for the whole file" } },
        },
        --stylua: ignore
        file_panel = {
          { "n", conflict_prefix .. "O",     actions.conflict_choose_all("ours"),    { desc = "Choose the OURS version of a conflict for the whole file" } },
          { "n", conflict_prefix .. "T",     actions.conflict_choose_all("theirs"),  { desc = "Choose the THEIRS version of a conflict for the whole file" } },
          { "n", conflict_prefix .. "B",     actions.conflict_choose_all("base"),    { desc = "Choose the BASE version of a conflict for the whole file" } },
          { "n", conflict_prefix .. "A",     actions.conflict_choose_all("all"),     { desc = "Choose all the versions of a conflict for the whole file" } },
          { "n", conflict_prefix .. "X",     actions.conflict_choose_all("none"),    { desc = "Delete the conflict region for the whole file" } },
        },
      }
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        mode = "n",
        { diffview_prefix, group = "Diff View Open" },
        { file_history_prefix, group = "Diff File History" },
      },
    },
  },
}

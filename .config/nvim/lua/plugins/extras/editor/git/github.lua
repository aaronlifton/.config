local prefix = "<leader>G"

return {
  { import = "lazyvim.plugins.extras.util.octo" },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "gh" })
    end,
  },
  {
    "almo7aya/openingh.nvim",
    cmd = { "OpenInGHRepo", "OpenInGHFile", "OpenInGHFileLines" },
    keys = {
      { prefix .. "ro", "<cmd>OpenInGHRepo<CR>", desc = "Open git repo in web", mode = { "n" } },
      { prefix .. "rf", "<cmd>OpenInGHFile<CR>", desc = "Open git file in web", mode = { "n" } },
      { prefix .. "rc", "<cmd>OpenInGHFileLines<CR>", desc = "Open current line in web", mode = { "n", "x", "v" } },
    },
  },
  -- {
  --   "folke/which-key.nvim",
  --   opts = {
  --     defaults = {
  --       ["<leader>G"] = { name = " github" },
  --       ["<leader>Gc"] = { name = "comments" },
  --       ["<leader>Gt"] = { name = "threads" },
  --       ["<leader>Gi"] = { name = "issues" },
  --       ["<leader>Gp"] = { name = "pull requests" },
  --       ["<leader>Gpm"] = { name = "merge current PR" },
  --       ["<leader>Gr"] = { name = "repo" },
  --       ["<leader>Ga"] = { name = "assignee/reviewer" },
  --       ["<leader>Gl"] = { name = "label" },
  --       ["<leader>Ge"] = { name = "reaction" },
  --       ["<leader>GR"] = { name = "review" },
  --     },
  --   },
  -- },
  -- {
  --   "pwntester/octo.nvim",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "nvim-telescope/telescope.nvim",
  --     "nvim-tree/nvim-web-devicons",
  --   },
  --   cmd = { "Octo" },
  --   opts = {
  --     use_diagnostic_signs = true,
  --     mappings = {},
  --   },
  --   keys = {
  --     { prefix .. "ca", "<cmd>Octo comment add<CR>", desc = "Add a new comment" },
  --     { prefix .. "cd", "<cmd>Octo comment delete<CR>", desc = "Delete a comment" },
  --
  --     { prefix .. "ta", "<cmd>Octo thread resolve<CR>", desc = "Mark thread as resolved" },
  --     { prefix .. "td", "<cmd>Octo thread unresolve<CR>", desc = "Mark thread as unresolved" },
  --
  --     { prefix .. "ic", "<cmd>Octo issue close<CR>", desc = "Close current issue" },
  --     { prefix .. "ir", "<cmd>Octo issue reopen<CR>", desc = "Reopen current issue" },
  --     { prefix .. "il", "<cmd>Octo issue list<CR>", desc = "List open issues" },
  --     { prefix .. "iu", "<cmd>Octo issue url<CR>", desc = "Copies URL of current issue" },
  --     { prefix .. "io", "<cmd>Octo issue browser<CR>", desc = "Open current issue in browser" },
  --
  --     { prefix .. "pp", "<cmd>Octo pr checkout<CR>", desc = "Checkout PR" },
  --     { prefix .. "pmm", "<cmd>Octo pr merge commit<CR>", desc = "Merge commit PR" },
  --     { prefix .. "pms", "<cmd>Octo pr merge squash<CR>", desc = "Squash merge PR" },
  --     { prefix .. "pmd", "<cmd>Octo pr merge delete<CR>", desc = "Delete merge PR" },
  --     { prefix .. "pmr", "<cmd>Octo pr merge rebase<CR>", desc = "Rebase merge PR" },
  --     { prefix .. "pc", "<cmd>Octo pr close<CR>", desc = "Close current PR" },
  --     { prefix .. "pn", "<cmd>Octo pr create<CR>", desc = "Create PR for current branch" },
  --     { prefix .. "pd", "<cmd>Octo pr diff<CR>", desc = "Show PR diff" },
  --     { prefix .. "ps", "<cmd>Octo pr list<CR>", desc = "List open PRs" },
  --     { prefix .. "pr", "<cmd>Octo pr ready<CR>", desc = "Mark draft as ready for review" },
  --     { prefix .. "po", "<cmd>Octo pr browser<CR>", desc = "Open current PR in browser" },
  --     { prefix .. "pu", "<cmd>Octo pr url<CR>", desc = "Copies URL of current PR" },
  --     { prefix .. "pt", "<cmd>Octo pr commits<CR>", desc = "List PR commits" },
  --     { prefix .. "pl", "<cmd>Octo pr commits<CR>", desc = "List changed files in PR" },
  --
  --     { prefix .. "rl", "<cmd>Octo repo list<CR>", desc = "List repo user stats" },
  --     { prefix .. "rF", "<cmd>Octo repo fork<CR>", desc = "Fork repo" },
  --     { prefix .. "ru", "<cmd>Octo repo url<CR>", desc = "Copies URL of current repo" },
  --
  --     { prefix .. "aa", "<cmd> Octo assignee add<CR>", desc = "Assign a user" },
  --     { prefix .. "ar", "<cmd> Octo assignee remove<CR>", desc = "Remove a user" },
  --     { prefix .. "ap", "<cmd> Octo reviewer add<CR>", desc = "Assign a PR reviewer" },
  --
  --     { prefix .. "la", "<cmd> Octo label add<CR>", desc = "Assign a label" },
  --     { prefix .. "lr", "<cmd> Octo label remove<CR>", desc = "Remove a label" },
  --     { prefix .. "lc", "<cmd> Octo label create<CR>", desc = "Create a label" },
  --
  --     { prefix .. "e1", "<cmd>Octo reaction thumbs_up<CR>", desc = "Add 👍 reaction" },
  --     { prefix .. "e2", "<cmd>Octo reaction thumbs_down<CR>", desc = "Add 👎 reaction" },
  --     { prefix .. "e3", "<cmd>Octo reaction eyes<CR>", desc = "Add 👀 reaction" },
  --     { prefix .. "e4", "<cmd>Octo reaction laugh<CR>", desc = "Add 😄 reaction" },
  --     { prefix .. "e5", "<cmd>Octo reaction confused<CR>", desc = "Add 😕 reaction" },
  --     { prefix .. "e6", "<cmd>Octo reaction rocket<CR>", desc = "Add 🚀 reaction" },
  --     { prefix .. "e7", "<cmd>Octo reaction heart<CR>", desc = "Add ❤️ reaction" },
  --     { prefix .. "e8", "<cmd>Octo reaction party<CR>", desc = "Add 🎉 reaction" },
  --
  --     { prefix .. "x", "<cmd>Octo actions<CR>", desc = "Run an action" },
  --
  --     { prefix .. "ss", "<cmd> Octo review start<CR>", desc = "Start review" },
  --     { prefix .. "sf", "<cmd> Octo review submit<CR>", desc = "Submit review" },
  --     { prefix .. "sr", "<cmd> Octo review resume<CR>", desc = "Submit resume" },
  --     { prefix .. "sd", "<cmd> Octo review discard<CR>", desc = "Delete pending review" },
  --     { prefix .. "sc", "<cmd> Octo review comments<CR>", desc = "View pending comments" },
  --     { prefix .. "sp", "<cmd> Octo review commit<CR>", desc = "Select commit to review" },
  --     { prefix .. "sc", "<cmd> Octo review close<CR>", desc = "Return to PR" },
  --   },
  -- },
}

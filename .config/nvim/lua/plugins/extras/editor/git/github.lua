local prefix = "<leader>G"

local function copy_github_url(opts)
  local openingh = require("openingh")
  -- local root = LazyVim.root.realpath()
  local branch = #opts.args > 0 and opts.args or vim.fn.system({ "git", "rev-parse", "--abbrev-ref", "HEAD" })
  local url
  if opts.range == 0 then -- Nothing was selected
    url = openingh.get_file_url(openingh.priority.BRANCH, branch, opts.line1)
  else -- Current line or block was selected
    url = openingh.get_file_url(openingh.priority.BRANCH, branch, opts.line1, opts.line2)
  end

  vim.fn.setreg("+", url)
end

return {
  { import = "lazyvim.plugins.extras.util.octo" },
  -- { import = "plugins.extras.lang.git-extended" },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "gh" },
    },
  },
  {
    "almo7aya/openingh.nvim",
    cmd = { "OpenInGHRepo", "OpenInGHFile", "OpenInGHFileLines" },
    keys = {
      { prefix .. "ro", "<cmd>OpenInGHRepo<CR>", desc = "Open git repo in web", mode = { "n" } },
      { prefix .. "rf", "<cmd>OpenInGHFile<CR>", desc = "Open git file in web", mode = { "n" } },
      { prefix .. "rc", "<cmd>OpenInGHFileLines<CR>", desc = "Open current line in web", mode = { "n", "x", "v" } },
      -- stylua: ignore start
      { prefix .. "ry", "<cmd>OpenInGHCopyFileLines<CR>", desc = "Copy github current line", mode = { "n", "x", "v" } },
      { prefix .. "rY", "<cmd>OpenInGHCopyFileLines main<CR>", desc = "Copy github current line (main)", mode = { "n", "x", "v" } },
      { prefix .. "rp", function()
        vim.ui.select(require("util.git").mru_branches(), { prompt = "Branch: " }, copy_github_url)
      end, desc = "Copy github current line (master)", mode = "n" },
      -- stylua: ignore end
    },
    init = function()
      vim.api.nvim_create_user_command(
        "OpenInGHCopyFileLines",
        copy_github_url,
        { range = true, bang = true, nargs = "*" }
      )
    end,
  },
  -- {
  --   "Rawnly/gist.nvim",
  --   cmd = { "GistCreate", "GistCreateFromFile", "GistsList" },
  --   dependencies = {
  --     "samjwill/nvim-unception",
  --     init = function()
  --       vim.g.unception_block_while_host_edits = true
  --     end,
  --   },
  --   opts = {},
  --   keys = {
  --     { prefix .. "gc", "<cmd>GistCreate<CR>", desc = "Create a Gist" },
  --     { prefix .. "gf", "<cmd>GistCreateFromFile<CR>", desc = "Create a Gist from File" },
  --     { prefix .. "gl", "<cmd>GistsList<CR>", desc = "List Gists" },
  --   },
  -- },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        mode = "n",
        { prefix, group = "github", icon = " " },
        { prefix .. "c", group = "comments" },
        { prefix .. "t", group = "threads" },
        { prefix .. "i", group = "issues" },
        { prefix .. "p", group = "pull requests" },
        { prefix .. "pm", group = "merge current PR" },
        { prefix .. "r", group = "repo" },
        { prefix .. "a", group = "assignee/reviewer" },
        { prefix .. "l", group = "label" },
        { prefix .. "e", group = "reaction" },
        { prefix .. "R", group = "review" },
        -- { prefix .. "g", group = "gist" },
      },
    },
  },
  {
    "pwntester/octo.nvim",
    cmd = { "Octo" },
    opts = {
      use_diagnostic_signs = true,
      suppress_missing_scope = { projects_v2 = true },
      mappings = {},
    },
    keys = {
      { prefix .. "ca", "<cmd>Octo comment add<CR>", desc = "Add a new comment" },
      { prefix .. "cd", "<cmd>Octo comment delete<CR>", desc = "Delete a comment" },

      { prefix .. "ta", "<cmd>Octo thread resolve<CR>", desc = "Mark thread as resolved" },
      { prefix .. "td", "<cmd>Octo thread unresolve<CR>", desc = "Mark thread as unresolved" },

      { prefix .. "ic", "<cmd>Octo issue close<CR>", desc = "Close current issue" },
      { prefix .. "ir", "<cmd>Octo issue reopen<CR>", desc = "Reopen current issue" },
      { prefix .. "il", "<cmd>Octo issue list<CR>", desc = "List open issues" },
      { prefix .. "iu", "<cmd>Octo issue url<CR>", desc = "Copies URL of current issue" },
      { prefix .. "io", "<cmd>Octo issue browser<CR>", desc = "Open current issue in browser" },

      { prefix .. "pp", "<cmd>Octo pr checkout<CR>", desc = "Checkout PR" },
      { prefix .. "pmm", "<cmd>Octo pr merge commit<CR>", desc = "Merge commit PR" },
      { prefix .. "pms", "<cmd>Octo pr merge squash<CR>", desc = "Squash merge PR" },
      { prefix .. "pmd", "<cmd>Octo pr merge delete<CR>", desc = "Delete merge PR" },
      { prefix .. "pmr", "<cmd>Octo pr merge rebase<CR>", desc = "Rebase merge PR" },
      { prefix .. "pc", "<cmd>Octo pr close<CR>", desc = "Close current PR" },
      { prefix .. "pn", "<cmd>Octo pr create<CR>", desc = "Create PR for current branch" },
      { prefix .. "pd", "<cmd>Octo pr diff<CR>", desc = "Show PR diff" },
      { prefix .. "ps", "<cmd>Octo pr list<CR>", desc = "List open PRs" },
      { prefix .. "pr", "<cmd>Octo pr ready<CR>", desc = "Mark draft as ready for review" },
      { prefix .. "po", "<cmd>Octo pr browser<CR>", desc = "Open current PR in browser" },
      { prefix .. "pu", "<cmd>Octo pr url<CR>", desc = "Copies URL of current PR" },
      { prefix .. "pt", "<cmd>Octo pr commits<CR>", desc = "List PR commits" },
      { prefix .. "pl", "<cmd>Octo pr commits<CR>", desc = "List changed files in PR" },

      { prefix .. "rl", "<cmd>Octo repo list<CR>", desc = "List repo user stats" },
      { prefix .. "rF", "<cmd>Octo repo fork<CR>", desc = "Fork repo" },
      { prefix .. "ru", "<cmd>Octo repo url<CR>", desc = "Copies URL of current repo" },

      { prefix .. "aa", "<cmd> Octo assignee add<CR>", desc = "Assign a user" },
      { prefix .. "ar", "<cmd> Octo assignee remove<CR>", desc = "Remove a user" },
      { prefix .. "ap", "<cmd> Octo reviewer add<CR>", desc = "Assign a PR reviewer" },

      { prefix .. "la", "<cmd> Octo label add<CR>", desc = "Assign a label" },
      { prefix .. "lr", "<cmd> Octo label remove<CR>", desc = "Remove a label" },
      { prefix .. "lc", "<cmd> Octo label create<CR>", desc = "Create a label" },

      { prefix .. "e1", "<cmd>Octo reaction thumbs_up<CR>", desc = "Add 👍 reaction" },
      { prefix .. "e2", "<cmd>Octo reaction thumbs_down<CR>", desc = "Add 👎 reaction" },
      { prefix .. "e3", "<cmd>Octo reaction eyes<CR>", desc = "Add 👀 reaction" },
      { prefix .. "e4", "<cmd>Octo reaction laugh<CR>", desc = "Add 😄 reaction" },
      { prefix .. "e5", "<cmd>Octo reaction confused<CR>", desc = "Add 😕 reaction" },
      { prefix .. "e6", "<cmd>Octo reaction rocket<CR>", desc = "Add 🚀 reaction" },
      { prefix .. "e7", "<cmd>Octo reaction heart<CR>", desc = "Add ❤️ reaction" },
      { prefix .. "e8", "<cmd>Octo reaction party<CR>", desc = "Add 🎉 reaction" },

      { prefix .. "x", "<cmd>Octo actions<CR>", desc = "Run an action" },

      { prefix .. "ss", "<cmd> Octo review start<CR>", desc = "Start review" },
      { prefix .. "sf", "<cmd> Octo review submit<CR>", desc = "Submit review" },
      { prefix .. "sr", "<cmd> Octo review resume<CR>", desc = "Submit resume" },
      { prefix .. "sd", "<cmd> Octo review discard<CR>", desc = "Delete pending review" },
      { prefix .. "sc", "<cmd> Octo review comments<CR>", desc = "View pending comments" },
      { prefix .. "sp", "<cmd> Octo review commit<CR>", desc = "Select commit to review" },
      { prefix .. "sc", "<cmd> Octo review close<CR>", desc = "Return to PR" },
    },
  },
}

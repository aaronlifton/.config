local prefix = "<leader>B"
return {
  {
    "LintaoAmons/bookmarks.nvim",
    -- pin the plugin at specific version for stability
    -- backup your bookmark sqlite db when there are breaking changes (major version change)
    tag = "3.2.0",
    dependencies = {
      { "kkharji/sqlite.lua" },
      { "nvim-telescope/telescope.nvim" }, -- currently has only telescopes supported, but PRs for other pickers are welcome
      { "stevearc/dressing.nvim" }, -- optional: better UI
      -- { "GeorgesAlkhouri/nvim-aider" }, -- optional: for Aider integration
    },
    config = function()
      local opts = {} -- check the "./lua/bookmarks/default-config.lua" file for all the options
      local bookmarks = require("bookmarks")
      bookmarks.setup(opts) -- you must call setup to init sqlite db

      local Service = require("bookmarks.domain.service")
      local Sign = require("bookmarks.sign")
      local Tree = require("bookmarks.tree")

      -- Quick Mark
      ---@param input string
      local function toggle_mark(input)
        Service.toggle_mark(input)
        Sign.safe_refresh_signs()
        pcall(Tree.refresh)
      end

      M.toggle_quick_mark = function()
        toggle_mark("")
      end

      vim.api.nvim_create_user_command("BookmarksQuickMark", bookmarks.toggle_quick_mark, {
        desc = "Toggle bookmark for the current line into active BookmarkList (no name).",
      })
      -- /Quick Mark

      -- Automatically switching Active List based on repository
      require("util.bookmarks.repo").config()
    end,
    keys = {
      -- stylua: ignore start
      { prefix .. "m", "<cmd>BookmarksMark<cr>", desc = "Mark current line into active BookmarkList.", mode = { "n", "v" } },
      { prefix .. "a", "<cmd>BookmarksQuickMark<cr>", desc = "Quick Mark current line", mode = { "n", "v" } },
      { prefix .. "o", "<cmd>BookmarksGoto<cr>", desc = "Go to bookmark at current active BookmarkList", mode = { "n", "v" } },
      { prefix .. "c", "<cmd>BookmarksCommands<cr>", desc = "Find and trigger a bookmark command.", mode = { "n", "v" } },
      { prefix .. "t", "<cmd>BookmarksTree<cr>", desc = "Bookmarks Tree", mode = { "n" } },
      -- stylua: ignore end
    },
  },
}

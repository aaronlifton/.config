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
    opts = function(_, opts)
      -- require("tokyonight.colors").setup({ style = "moon" })
      local C = require("neomodern.palette").get("iceclimber", "dark")
      local util = require("neomodern.util")
      return vim.tbl_deep_extend("force", opts, {
        treeview = {
          highlights = {
            active_list = {
              bg = C.bg,
              fg = C.fg,
              bold = true,
            },
          },
        },
        signs = {
          mark = {
            color = util.blend(C.diag_yellow, 0.8, C.bg),
          },
        },
      })
    end,
    config = function(_, opts)
      local opts = vim.tbl_deep_extend("force", opts, {}) -- check the "./lua/bookmarks/default-config.lua" file for all the options
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
      -- Additional useful keymaps
      { prefix .. "l", "<cmd>BookmarksList<cr>", desc = "Show all BookmarkLists", mode = { "n" } },
      { prefix .. "n", "<cmd>BookmarksNewList<cr>", desc = "Create a new BookmarkList", mode = { "n" } },
      { prefix .. "d", "<cmd>BookmarksDeleteList<cr>", desc = "Delete a BookmarkList", mode = { "n" } },
      { prefix .. "r", "<cmd>BookmarksRename<cr>", desc = "Rename current BookmarkList", mode = { "n" } },
      { prefix .. "s", "<cmd>BookmarksSetActiveList<cr>", desc = "Set active BookmarkList", mode = { "n" } },
      { prefix .. "g", "<cmd>BookmarksGotoRecent<cr>", desc = "Go to recent bookmarks", mode = { "n" } },
      { prefix .. "e", "<cmd>BookmarksEditJsonFile<cr>", desc = "Edit bookmarks JSON file", mode = { "n" } },
      { prefix .. "x", "<cmd>BookmarksDeleteMark<cr>", desc = "Delete bookmark at current line", mode = { "n" } },
      -- stylua: ignore end
    },
  },
}

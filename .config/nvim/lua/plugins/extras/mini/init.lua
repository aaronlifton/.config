return {
  -- {
  --   "echasnovski/mini.nvim",
  --   vscode = true,
  --   config = function()
  --     require("mini.extra").setup()
  --     -- require("mini.move").setup()
  --     -- require("mini.colors").setup()
  --   end,
  -- },
  -- Somehow this file adds 3.6 ms to loading time
  { import = "plugins.extras.mini.mini-files-extended" },
  { import = "plugins.extras.mini.mini-ai-extended" },
  { import = "plugins.extras.mini.mini-diff-extended" },
  -- { import = "plugins.extras.mini.mini-starter" },
  { import = "plugins.extras.mini.mini-align" },
  { import = "plugins.extras.mini.mini-pairs-extended" },
  -- { import = "plugins.extras.mini.mini-animate" },
  { import = "plugins.extras.mini.mini-hipatterns-extended" },
  -- { import = "plugins.extras.mini.mini-icons" },
}

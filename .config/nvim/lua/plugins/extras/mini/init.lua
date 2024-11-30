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
  { import = "plugins.extras.mini.mini-files" },
  { import = "plugins.extras.mini.mini-ai" },
  { import = "plugins.extras.mini.mini-diff" },
  -- { import = "plugins.extras.mini.mini-starter" },
  { import = "plugins.extras.mini.mini-align" },
  { import = "plugins.extras.mini.mini-pairs" },
  -- { import = "plugins.extras.mini.mini-animate" },
  -- { import = "plugins.extras.mini.mini-hipatterns" },
  -- { import = "plugins.extras.mini.mini-icons" },
}

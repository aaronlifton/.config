return {
  { import = "lazyvim.plugins.extras.editor.mini-files" },
  {
    "echasnovski/mini.files",
    optional = true,
    opts = {
      windows = {
        preview = true,
        width_nofocus = 30,
        width_preview = 60,
      },
      options = {
        use_as_default_explorer = false,
      },
    },
    keys = {
      { "<leader>fm", false },
      { "<leader>fM", false },
      {
        "<leader>fj",
        function()
          require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
        end,
        -- desc = "Explorer (Current File)",
        desc = "Open mini.files (Directory of Current File)",
      },
      {
        "<leader>fJ",
        function()
          require("mini.files").open(vim.uv.cwd(), true)
        end,
        -- desc = "Explorer (Current Directory)",
        desc = "Open mini.files (cwd)",
      },
    },
  },
}

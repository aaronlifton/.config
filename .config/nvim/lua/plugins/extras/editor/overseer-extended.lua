return {
  { import = "lazyvim.plugins.extras.editor.overseer" },
  {
    "stevearc/overseer.nvim",
    optional = true,
    opts = {
      task_list = {
        direction = "bottom",
        min_height = 15,
        max_height = 15,
        default_detail = 1,
      },
    },
    config = function(_, opts)
      require("overseer").setup(vim.tbl_extend("force", opts, {
        templates = {
          "builtin",
          "user.astro_check",
          "user.rdbg",
          "user.rubocop_autocorrect",
          "user.jest_debug",
          "user.jest_debug_rtl",
        },
      }))
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, { "overseer" })
    end,
  },
}

return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        sqlfluff = {
          args = {
            "lint",
            "--format=json",
            "--dialect=postgres",
          },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    -- opts = {
    --   formatters = {
    --     sqlfluff = {
    --       args = { "format", "--dialect=ansi", "-" },
    --     },
    --   },
    -- },
    opts = function(_, opts)
      opts.formatters.sqlfluff = {
        args = { "format", "--dialect=postgres", "-" },
      }
    end,
  },
}

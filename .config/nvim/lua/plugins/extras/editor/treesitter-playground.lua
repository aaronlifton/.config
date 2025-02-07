return {
  {
    "nvim-treesitter/nvim-treesitter",
    lazy = true,
    optional = true,
    dependencies = {
      {
        "nvim-treesitter/playground",
        -- Lazy load
        keys = {
          { "<leader>ciT", "<Cmd>TSHighlightCapturesUnderCursor<CR>", desc = "Treesitter Highlight Groups" },
          { "<leader>cit", "<Cmd>TSPlaygroundToggle<CR>", desc = "Treesitter Playground" },
        },
      },
    },
    build = ":TSInstall query",
    opts = {
      playground = {
        enable = true,
      },
      query_linter = {
        enable = true,
        use_virtual_text = true,
        lint_events = { "BufWrite", "CursorHold" },
      },
    },
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        title = "TS Playground",
        ft = "tsplayground",
        pinned = true,
        open = "TSPlaygroundToggle",
        size = { width = 0.3 },
      })
    end,
  },
}

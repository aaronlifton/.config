-- nvim-treesitter/playground is deprecated since the functionality is included in Neovim
-- use these in place of :TSPlaygroundToggle
-- - `:Inspect` to show the highlight groups under the cursor
-- - `:InspectTree` to show the parsed syntax tree ("TSPlayground")
-- - `:EditQuery` to open the Live Query Editor (Nvim 0.10+)
return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    dependencies = {
      {
        "nvim-treesitter/playground",
        lazy = true,
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

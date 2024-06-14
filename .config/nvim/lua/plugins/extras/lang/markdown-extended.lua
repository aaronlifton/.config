return {
  { import = "lazyvim.plugins.extras.lang.markdown" },
  {
    "gaoDean/autolist.nvim",
    ft = {
      "markdown",
      "text",
      "tex",
      "plaintex",
      "norg",
    },
    opts = {},
    keys = {
      { "<tab>", "<cmd>AutolistTab<cr>", mode = { "i" } },
      { "<s-tab>", "<cmd>AutolistShiftTab<cr>", mode = { "i" } },
      { "<CR>", "<CR><cmd>AutolistNewBullet<cr>", mode = { "i" } },
      { "o", "o<cmd>AutolistNewBullet<cr>", mode = { "n" } },
      { "O", "O<cmd>AutolistNewBulletBefore<cr>", mode = { "n" } },
      { "<CR>", "<cmd>AutolistToggleCheckbox<cr><CR>", mode = { "n" } },
      -- { "<C-r>", "<cmd>AutolistRecalculate<cr>", mode = { "n" } },

      { "].", "<cmd>AutolistCycleNext<cr>", mode = { "n" }, desc = "Next List Type" },
      { "[.", "<cmd>AutolistCyclePrev<cr>", mode = { "n" }, desc = "Prev List Type" },

      { ">>", ">><cmd>AutolistRecalculate<cr>", mode = { "n" } },
      { "<<", "<<<cmd>AutolistRecalculate<cr>", mode = { "n" } },
      { "dd", "dd<cmd>AutolistRecalculate<cr>", mode = { "n" } },
      { "d", "d<cmd>AutolistRecalculate<cr>", mode = { "v" } },
    },
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    ensure_installed = {
      "markdown",
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      -- opts.formatters_by_ft["markdown"] = { { "prettierd", "prettier" } }
      -- opts.formatters_by_ft["markdown.mdx"] = { { "prettierd", "prettier" } }
      opts.formatters_by_ft["markdown"] = { "dprint" }
      opts.formatters_by_ft["markdown.mdx"] = { "dprint" }
      opts.formatters_by_ft["mdx"] = vim.list_slice(opts.formatters_by_ft["markdown.mdx"])
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {},
      },
    },
  },
}

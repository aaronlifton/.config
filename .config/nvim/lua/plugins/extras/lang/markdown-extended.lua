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
      opts.formatters_by_ft["markdown"] = { { "prettierd", "prettier" } }
      opts.formatters_by_ft["markdown.mdx"] = { { "prettierd", "prettier" } }
      opts.formatters_by_ft["mdx"] = vim.list_slice(opts.formatters_by_ft["markdown.mdx"])
    end,
    -- opts = {
    --   formatters_by_ft = {
    --     -- ["markdown"] = { "prettier" },
    --     ["markdown.mdx"] = { "prettier_d" },
    --     ["mdx"] = { "prettier_d" },
    --   },
    -- },
    -- NOTE: Had edited the wrong file and thought this was the workaround
    -- TODO: Remove after testing above
    --
    -- opts = function(_, opts)
    --   opts.formatters_by_ft["markdown.mdx"] = opts.formatters_by_ft["markdown.mdx"] or {}
    --
    --   local prettier_idx = nil
    --   for i, v in ipairs(opts.formatters_by_ft["markdown.mdx"]) do
    --     if v == "prettier" then
    --       prettier_idx = i
    --       break
    --     end
    --   end
    --
    --   if prettier_idx then
    --     table.remove(opts.formatters_by_ft["markdown.mdx"], prettier_idx)
    --   else
    --     prettier_idx = 1
    --   end
    --   table.insert(opts.formatters_by_ft["markdown.mdx"], prettier_idx, "prettier_d")
    --   -- Set same settings for duplicate filetype, create shallow copy via vim.list_slice
    --   opts.formatters_by_ft["mdx"] = vim.list_slice(opts.formatters_by_ft["markdown.mdx"])
    -- end,
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = {
  --     servers = {
  --       marksman = {
  --         condition = function(self, ctx)
  --           return ctx.filename ~= "README.md"
  --         end,
  --       },
  --       vale = {
  --         condition = function(self, ctx)
  --           return ctx.filename ~= "README.md"
  --         end,
  --       },
  --     },
  --   },
  -- },
}

-- LazyVim.on_very_lazy(function()
--   vim.treesitter.language.register("markdown", "mdx")
-- end)

local fts = {
  "markdown",
  "norg",
  -- "text",
  -- "tex",
  -- "plaintex",
}

return {
  { import = "lazyvim.plugins.extras.lang.markdown" },
  {
    "gaoDean/autolist.nvim",
    ft = fts,
    opts = {},
    keys = {
      -- freezing when hitting the tab key (https://github.com/gaoDean/autolist.nvim/issues/79)
      -- { "<tab>", "<cmd>AutolistTab<cr>", mode = { "i" }, ft = fts },
      -- { "<s-tab>", "<cmd>AutolistShiftTab<cr>", mode = { "i" }, ft = fts },
      { "<CR>", "<CR><cmd>AutolistNewBullet<cr>", mode = { "i" }, ft = fts },
      { "o", "o<cmd>AutolistNewBullet<cr>", mode = { "n" }, ft = fts },
      { "O", "O<cmd>AutolistNewBulletBefore<cr>", mode = { "n" }, ft = fts },
      { "<CR>", "<cmd>AutolistToggleCheckbox<cr><CR>", mode = { "n" }, ft = fts },
      -- { "<S-CR>", "<cmd>AutolistToggleCheckbox<cr><CR>", mode = { "n" }, ft = fts },
      { "<C-r>", "<cmd>AutolistRecalculate<cr>", mode = { "n" }, ft = fts },

      { "],", "<cmd>AutolistCycleNext<cr>", mode = { "n" }, ft = fts, desc = "Next List Type" },
      { "[.", "<cmd>AutolistCyclePrev<cr>", mode = { "n" }, ft = fts, desc = "Prev List Type" },

      { ">>", ">><cmd>AutolistRecalculate<cr>", mode = { "n" }, ft = fts },
      { "<<", "<<<cmd>AutolistRecalculate<cr>", mode = { "n" }, ft = fts },
      { "dd", "dd<cmd>AutolistRecalculate<cr>", mode = { "n" }, ft = fts },
      { "d", "d<cmd>AutolistRecalculate<cr>", mode = { "v" }, ft = fts },
    },
  },
  {
    "antonk52/markdowny.nvim",
    ft = { "markdown", "txt" },
    opts = {
      filetypes = { "markdown", "txt" },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    opts = {
      file_types = { "markdown", "norg", "rmd", "org", "mchat", "Avante" },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          prepend_args = { "--config", os.getenv("HOME") .. "/.config/nvim/rules/.markdownlint-cli2.yaml", "--" },
        },
      },
    },
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    opts = {
      file_types = { "markdown", "norg", "rmd", "org", "mchat", "Avante" },
    },
  },
  {
    -- Install markdown preview, use npx if available.
    "iamcco/markdown-preview.nvim",
    enabled = false,
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function(plugin)
      if vim.fn.executable("npx") then
        vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
      else
        vim.cmd([[Lazy load markdown-preview.nvim]])
        vim.fn["mkdp#util#install"]()
      end
    end,
    init = function()
      if vim.fn.executable("npx") then vim.g.mkdp_filetypes = { "markdown" } end
    end,
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "markdown",
      },
    },
  },
}

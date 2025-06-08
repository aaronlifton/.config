-- Util.lazy.on_very_lazy(function()
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
  -- { import = "lazyvim.plugins.extras.lang.markdown" },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        ["markdown-toc"] = {
          condition = function(_, ctx)
            for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
              if line:find("<!%-%- toc %-%->") then return true end
            end
          end,
        },
        ["markdownlint-cli2"] = {
          condition = function(_, ctx)
            local diag = vim.tbl_filter(function(d)
              return d.source == "markdownlint"
            end, vim.diagnostic.get(ctx.buf))
            return #diag > 0
          end,
        },
      },
      formatters_by_ft = {
        ["markdown"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
        ["markdown.mdx"] = { "prettier", "markdownlint-cli2", "markdown-toc" },
      },
    },
  },
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "markdownlint-cli2", "markdown-toc" } },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = { "markdownlint-cli2" },
        ["markdownlint-cli2"] = {
          prepend_args = { "--config", os.getenv("HOME") .. "/.config/nvim/rules/.markdownlint-cli2.yaml", "--" },
        },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {},
      },
    },
  },

  -- Markdown preview
  {
    "iamcco/markdown-preview.nvim",
    enabled = false,
    ft = { "markdown" },
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      if vim.fn.executable("npx") then
        vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
      else
        vim.cmd([[Lazy load markdown-preview.nvim]])
        vim.fn["mkdp#util#install"]()
      end
    end,
    keys = {
      {
        "<leader>cp",
        ft = "markdown",
        "<cmd>MarkdownPreviewToggle<cr>",
        desc = "Markdown Preview",
      },
    },
    config = function()
      vim.cmd([[do FileType]])

      if vim.fn.executable("npx") then vim.g.mkdp_filetypes = { "markdown" } end
    end,
  },
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    opts = {
      file_types = { "markdown", "norg", "rmd", "org", "mchat", "Avante" },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = false,
        icons = {},
      },
      checkbox = {
        enabled = false,
      },
    },
    ft = { "markdown", "norg", "rmd", "org", "codecompanion" },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      Snacks.toggle({
        name = "Render Markdown",
        get = function()
          return require("render-markdown.state").enabled
        end,
        set = function(enabled)
          local m = require("render-markdown")
          if enabled then
            m.enable()
          else
            m.disable()
          end
        end,
      }):map("<leader>um")
    end,
  },

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
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "markdown",
      },
    },
  },
}

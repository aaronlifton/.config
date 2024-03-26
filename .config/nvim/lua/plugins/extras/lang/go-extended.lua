local lsp_util = require("util.lsp")
-- TODO: https://github.com/ngalaiko/tree-sitter-go-template

return {
  { import = "lazyvim.plugins.extras.lang.go" },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "golangci-lint" })
    end,
  },
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    ft = { "go", "gomod" },
    build = function()
      require("go.install").update_all_sync()
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- local settings = {
      --   ["go"] = { "golangcilint" },
      --   ["gomod"] = { "golangcilint" },
      --   ["gowork"] = { "golangcilint" },
      -- }
      -- for ft, linters in pairs(settings) do
      --   opts.linters_by_ft[ft] = linters
      -- end

      -- Don't overwrite version
      -- lsp_util.add_linters(opts, {
      --   ["go"] = { "golangcilint" },
      --   ["gomod"] = { "golangcilint" },
      --   ["gowork"] = { "golangcilint" },
      -- })

      local function add_linters(tbl)
        for ft, linters in pairs(tbl) do
          if opts.linters_by_ft[ft] == nil then
            opts.linters_by_ft[ft] = linters
          else
            vim.list_extend(opts.linters_by_ft[ft], linters)
          end
        end
      end

      add_linters({
        ["go"] = { "golangcilint" },
        ["gomod"] = { "golangcilint" },
        ["gowork"] = { "golangcilint" },
      })

      return opts
    end,
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    ensure_installed = {
      "go",
    },
  },
  -- what is the latest testing library?
  {
    "yanskun/gotests.nvim",
    ft = "go",
    config = function()
      require("gotests").setup()
    end,
  },
}

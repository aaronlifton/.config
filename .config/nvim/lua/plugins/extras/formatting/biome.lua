local lsp_util = require("util.lsp")

return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "biome" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        biome = {},
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      local util = require("conform.util")
      lsp_util.add_formatters(opts, {
        ["jsonc"] = { "biome" },
        ["json"] = { "biome" },
        ["javascript"] = { "biome" },
        ["typescript"] = { "biome" },
        ["typescriptreact"] = { "biome" },
        ["javascriptreact"] = { "biome" },
        ["astro"] = { "biome" },
        ["svelte"] = { "biome" },
        ["vue"] = { "biome" },
      })

      local prettier_settings = {
        condition = function(self, ctx)
          -- check if the filename ends in mdx
          if vim.fn.fnamemodify(ctx.filename, ":e") == "mdx" then
            return true
          else
            local dprint_filenames = { "dprint.json", "dprint.jsonc", ".dprint.json", ".dprint.jsonc" }
            local has_higher_precedence_formatter =
              vim.fs.find({ "biome.json", table.unpack(dprint_filenames) }, { path = ctx.filename, upward = true })[1]
            return not has_higher_precedence_formatter
          end
        end,
        cwd = util.root_file({
          -- https://prettier.io/docs/en/configuration.html
          ".prettierrc",
          ".prettierrc.json",
          ".prettierrc.yml",
          ".prettierrc.yaml",
          ".prettierrc.json5",
          ".prettierrc.js",
          ".prettierrc.cjs",
          ".prettierrc.toml",
          "prettier.config.js",
          "prettier.config.cjs",
          "prettier.config.mjs",
          "package.json",
        }),
      }

      lsp_util.add_formatter_settings(opts, {
        biome = {
          condition = function(self, ctx)
            return vim.fs.find({ "biome.json" }, { path = ctx.filename, upward = true })[1]
          end,
        },
        prettier = prettier_settings,
        prettierd = prettier_settings,
      })

      -- return opts
    end,
  },
}

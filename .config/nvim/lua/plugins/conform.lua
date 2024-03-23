return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        -- These use biome
        ["javascript"] = { { "prettier" } },
        ["javascriptreact"] = { { "prettier" } },
        ["json"] = { { "prettier" } },
        ["jsonc"] = { { "prettier" } },
        ["typescript"] = { { "prettier" } },
        ["typescriptreact"] = { { "prettier" } },
        -- ["javascript"] = { "biome" },
        -- ["javascriptreact"] = { "biome" },
        -- ["json"] = { "biome" },
        -- ["jsonc"] = { "biome" },
        -- ["typescript"] = { "biome" },
        -- ["typescriptreact"] = { "biome" },
        ["astro"] = { { "prettier" } },
        ["bash"] = { { "shfmt" } },
        ["css"] = { { "prettier" } },
        ["fish"] = { { "fish_indent" } },
        ["go"] = { { "gofmt", "goimports", "gofumpt" } },
        ["gohtml"] = { { "prettier" } },
        ["goimports"] = { { "goimports" } },
        ["graphql"] = { { "prettier" } },
        ["handlebars"] = { { "prettier" } },
        ["html"] = { { "prettier" } },
        ["less"] = { { "prettier" } },
        ["lua"] = { { "stylua", "luaformatter" } },
        ["markdown"] = { { "markdownlint-cli2", "cbfmt" } },
        ["markdown.mdx"] = { { "markdownlint-cli2", "cbmft" } }, -- TODO: mdformat, prettier
        ["mdx"] = { { "markdownlint-cli2", "cbmft" } }, -- TODO: mdformat, prettier
        ["python"] = { { "black" } },
        ["rust"] = { "rustfmt" },
        ["scss"] = { { "prettier" } },
        ["sh"] = { { "shfmt" } },
        ["svelte"] = { { "prettier" } },
        ["tsx"] = { { "prettier" } },
        ["vim"] = { { "prettier" } },
        ["vue"] = { { "prettier" } },
        ["yaml"] = { { "prettier" } },
        ["zig"] = { { "zigfmt" } },
        ["zsh"] = { { "shfmt" } },
        fennel = { "fnlfmt" },
        clojure = { "joker" },
        clojurescript = { "joker" },
      },
      -- formatters_after_save = {{}}
      formatters = {
        ["markdownlint-cli2"] = {
          prepend_args = {
            "--config",
            vim.env.HOME .. "/.config/nvim/rules/.markdownlint-cli2.jsonc",
          },
        },
        cbfmt = {
          -- command = "/Users/aaron/.cargo/bin/cbfmt",
          prepend_args = {
            "--config",
            vim.env.HOME .. "/.config/nvim/rules/cbfmt.toml",
          },
        },
      },
    },
  },
}
-- local util = require("conform.util")
--     local markdownlintcli2 = require("conform.formatters.markdownlint-cli2")
--     util.add_formatter_args(markdownlintcli2, {
--           "--config",
--           vim.env.HOME .. "/.config/nvim/rules/markdownlint-cli2.jsonc",
--         })

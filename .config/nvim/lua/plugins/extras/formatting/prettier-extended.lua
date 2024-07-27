return {
  { import = "lazyvim.plugins.extras.formatting.prettier" },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    ensure_installed = {
      "prettier",
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        ["javascript"] = { { "eslint_d" } },
        -- ["javascriptreact"] = { { "prettierd", "prettier" } },
        -- ["typescript"] = { { "prettierd", "prettier" } },
        -- ["typescriptreact"] = { { "prettierd", "prettier" } },
        -- ["vue"] = { { "prettierd", "prettier" } },
        -- ["css"] = { { "prettierd", "prettier" } },
        -- ["scss"] = { { "prettierd", "prettier" } },
        -- ["less"] = { { "prettierd", "prettier" } },
        -- ["html"] = { { "prettierd", "prettier" } },
        -- ["json"] = { { "prettierd", "prettier" } },
        -- ["jsonc"] = { { "prettierd", "prettier" } },
        -- ["yaml"] = { { "prettierd", "prettier" } },
        -- ["markdown"] = { { "prettierd", "prettier" } },
        -- ["markdown.mdx"] = { { "prettierd", "prettier" } },
        -- ["graphql"] = { { "prettierd", "prettier" } },
        -- ["handlebars"] = { { "prettierd", "prettier" } },
      },
    },
  },
}

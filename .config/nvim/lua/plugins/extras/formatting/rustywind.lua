local lsp_util = require("util.lsp")

return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "rustywind" },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ["javascript"] = { "rustywind" },
        ["javascriptreact"] = { "rustywind" },
        ["typescript"] = { "rustywind" },
        ["typescriptreact"] = { "rustywind" },
        ["vue"] = { "rustywind" },
        ["html"] = { "rustywind" },
        ["astro"] = { "rustywind" },
      },
      formatters = {
        rustywind = {
          condition = function(_, ctx)
            return vim.fs.find({ "tailwind.config.js" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      },
    },
  },
}

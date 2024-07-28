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
    opts = function(_, opts)
      lsp_util.add_formatters(opts, {
        ["javascript"] = { "rustywind" },
        ["javascriptreact"] = { "rustywind" },
        ["typescript"] = { "rustywind" },
        ["typescriptreact"] = { "rustywind" },
        ["vue"] = { "rustywind" },
        ["html"] = { "rustywind" },
        ["astro"] = { "rustywind" },
      })

      lsp_util.add_formatter_settings(opts, {
        rustywind = {
          condition = function(_, ctx)
            return vim.fs.find({ "tailwind.config.js" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      })
    end,
  },
}

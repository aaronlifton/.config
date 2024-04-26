local lsp_util = require("util.lsp")

return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "rustywind" })
    end,
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
    end,
  },
}

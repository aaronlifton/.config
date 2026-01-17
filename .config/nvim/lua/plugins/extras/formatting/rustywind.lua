local lsp_util = require("util.lsp")

return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "rustywind" },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      local formatters = { "rustywind" }
      require("util.conform").add_formatters(opts, {
        javascript = formatters,
        javascriptreact = formatters,
        typescript = formatters,
        typescriptreact = formatters,
        vue = formatters,
        html = formatters,
        eruby = formatters,
        astro = formatters,
      })
      opts.formatters = vim.tbl_extend("force", opts.formatters, {
        rustywind = {
          condition = function(_, ctx)
            return vim.fs.find({ "tailwind.config.js" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      })
    end,
  },
}

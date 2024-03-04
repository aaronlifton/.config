local lsp_util = require("util.lsp")
local stylelint = "stylelint"

return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { stylelint })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      lsp_util.add_linters(opts, {
        ["html"] = { "stylelint" },
        ["css"] = { "stylelint" },
        ["scss"] = { "stylelint" },
        ["sass"] = { "stylelint" },
        ["less"] = { "stylelint" },
      })

      return opts
    end,
  },
}

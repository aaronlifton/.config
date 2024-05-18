local lsp_util = require("util.lsp")
return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "vale" })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      lsp_util.add_linters(opts, {
        ["markdown"] = { "vale" },
        ["mdx"] = { "vale" },
        ["tex"] = { "vale" },
      })

      opts.linters.vale = opts.linters.vale or {}
      opts.linters.vale.condition = function(ctx)
        return vim.fs.find({ ".vale" }, { type = "directory", path = ctx.filename, upward = true })[1]
      end
    end,
  },
}

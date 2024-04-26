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
      })

      -- opts.linters_by_ft.markdown = opts.linters_by_ft.markdown or {}
      -- table.insert(opts.linters_by_ft.markdown, "vale")
      table.insert(require("lint").linters.vale.args, " --glob='*.{mdx}'")
    end,
  },
}

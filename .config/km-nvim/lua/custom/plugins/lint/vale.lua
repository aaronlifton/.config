return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = { "vale" },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = { "vale" },
        ["markdown.mdx"] = { "vale" },
        tex = { "vale" },
      },
      linters = {
        vale = {
          condition = function(ctx)
            return vim.fs.find({ ".vale" }, { type = "directory", path = ctx.filename, upward = true })[1]
          end,
        },
      },
    },
  },
}

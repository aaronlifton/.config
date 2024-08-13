return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "typos" },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = { "typos" },
        ["markdown.mdx"] = { "typos" },
      },
    },
  },
}

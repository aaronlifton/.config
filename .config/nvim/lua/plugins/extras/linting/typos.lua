return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "typos" })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- opts.linters_by_ft["*"] = opts.linters_by_ft["*"] or {}
      -- table.insert(opts.linters_by_ft["*"], "typos")
      local fts = { "markdown", "mdx", "markdown.mdx", "text", "txt" }
      for _, ft in ipairs(fts) do
        opts.linters_by_ft[ft] = opts.linters_by_ft[ft] or {}
        table.insert(opts.linters_by_ft[ft], "typos")
      end
    end,
  },
}

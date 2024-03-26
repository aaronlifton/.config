return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "cspell" })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      -- opts.linters_by_ft["*"] = opts.linters_by_ft["*"] or {}
      -- table.insert(opts.linters_by_ft["*"], "cspell")
      local fts = { "markdown", "mdx", "markdown.mdx", "text", "txt" }
      for _, ft in ipairs(fts) do
        opts.linters_by_ft[ft] = opts.linters_by_ft[ft] or {}
        table.insert(opts.linters_by_ft[ft], "cspell")
      end

      opts.linters.cspell = {
        condition = function(ctx)
          if vim.fs.find({ "cspell.json" }, { path = ctx.filename, upward = true })[1] then
              -- stylua: ignore
              vim.keymap.set("n", "<leader>!", function() require("util.cspell").addWordToDictionary() end, { desc = "Add Word to Dictionary", silent = true })
            return true
          else
            return false
          end
        end,
      }

      return opts
    end,
  },
}

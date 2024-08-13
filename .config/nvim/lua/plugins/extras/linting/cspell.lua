return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "cspell" },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        markdown = { "cspell" },
        ["markdown.mdx"] = { "cspell" },
      },
      linters = {
        cspell = {
          condition = function(ctx)
            if vim.fs.find({ "cspell.json" }, { path = ctx.filename, upward = true })[1] then
              vim.keymap.set("n", "<leader>!", function()
                require("util.cspell").addWordToDictionary()
              end, { desc = "Add Word to Dictionary", silent = true })
              return true
            else
              return false
            end
          end,
        },
      },
    },
  },
}

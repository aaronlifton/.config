return {
  {
    "linrongbin16/lsp-progress.nvim",
    lazy = true,
    config = function()
      require("lsp-progress").setup()
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_c, #opts.sections.lualine_c + 1, {
        function()
          return require("lsp-progress").progress()
        end,
      })
    end,
  },
}

return {
  "neovim/nvim-lspconfig",
  opts = function()
    vim.lsp.enable("cookbook")
    vim.lsp.config("cookbook", {
      root_markers = { "cookbook.toml" },
      filetypes = { "ruby", "fish" },
    })
  end,
}

vim.api.nvim_create_autocmd({ "BufNewFile", "BufEnter", "BufWritePre" }, {
  pattern = "*.erb",
  callback = function()
    vim.treesitter.stop()
  end,
})

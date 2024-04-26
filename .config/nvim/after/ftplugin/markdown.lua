vim.keymap.set({ "n", "x" }, "]#", [[/^#\+ .*<CR>]], { desc = "Next Heading", buffer = true })
vim.keymap.set({ "n", "x" }, "[#", [[?^#\+ .*<CR>]], { desc = "Prev Heading", buffer = true })

local filename = vim.fn.expand("%:t")
if filename == "README.md" or filename == "CHANGELOG.md" then
  -- LazyVim.toggle.diagnostics()
  vim.diagnostic.disable()
  -- vim.cmd("echo 'Markdown settings disabled'")

  -- LazyVim.lsp.disable("marksman")
  -- LazyVim.lsp.disable("vale")
end

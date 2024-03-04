if not vim.g.vscode then
  return {}
end

vim.api.nvim_set_option("spell", true)
vim.api.nvim_set_option("commentstring", "")

-- https://github.com/vscode-neovim/vscode-neovim#-tips-and-features
-- https://github.com/LazyVim/LazyVim/blob/68ff818a5bb7549f90b05e412b76fe448f605ffb/lua/lazyvim/plugins/extras/vscode.lua
-- https://github.com/xiyaowong/fast-cursor-move.nvim
-- https://gist.github.com/laznp/4e07cda6f700241f977b11088209c397
-- xnoremap = <Cmd>lua require('vscode-neovim').call('editor.action.formatSelection')<CR>
-- nnoremap = <Cmd>lua require('vscode-neovim').call('editor.action.formatSelection')<CR><Esc>
-- nnoremap == <Cmd>lua require('vscode-neovim').call('editor.action.formatSelection')<CR>
-- nnoremap ? <Cmd>lua require('vscode-neovim').action('workbench.action.findInFiles', { args = { { query = vim.fn.expand('<cword>') } } })<CR>
-- nnoremap <C-w>gd <Cmd>lua require('vscode-neovim').action('editor.action.revealDefinitionAside')<CR>
-- workbench.action.navigateBack
-- workbench.action.navigateForward
-- vim.keymap.set("n", "<leader><space>", "<cmd>Find<cr>")
-- vim.keymap.set("n", "<leader>/", [[<cmd>call VSCodeNotify('workbench.action.findInFiles')<cr>]])
-- vim.keymap.set("n", "<leader>ss", [[<cmd>call VSCodeNotify('workbench.action.gotoSymbol')<cr>]])
-- vim.keymap.set("n", "<C-BS>", "<C-W>")
-- vim.keymap.set("i", "<C-BS>", "<C-W>")
-- vim.keymap.set("n", "<C-Space>", "<C-@>")
-- vim.keymap.set("i", "<C-Space>", "<C-@>")
-- vim.keymap.set("n", "<C-\\>", "<C-\\><C-N>")
-- vim.keymap.set("i", "<C-\\>", "<C-\\><C-N>")
-- vim.keymap.set("n", "<C-\\><C-\\>", "<C-\\><C-\\><C-N>")
-- vim.keymap.set("i", "<C-\\><C-\\>", "<C-\\><C-\\><C-N>")
-- vim.keymap.set("n", "<C-\\><C-\\><C-\\>", "<C-\\><C-\\><C-\\><C-N>")
-- vim.keymap.set("i", "<C-\\><C-\\><C-\\>", "<C-\\><C-\\><C-\\><C-N>")
-- vim.keymap.set("n", "<C-\\><C-\\><C-\\><C-\\>", "<C-\\><C-\\><C-\\><C-\\><C-N>")
-- vim.keymap.set("i", "<C-\\><C-\\><C-\\><C-\\>", "<C-\\><C-\\><C-\\><C-\\><C-N>")
-- local enabled = {
--   "flit.nvim",
--   "lazy.nvim",
--   "leap.nvim",
--   "mini.ai",
--   "mini.comment",
--   "mini.pairs",
--   "mini.surround",
--   "nvim-treesitter",
--   "nvim-treesitter-textobjects",
--   "nvim-ts-context-commentstring",
--   "vim-repeat",
--   "LazyVim",
-- }
--
-- https://github.com/LazyVim/LazyVim/blob/68ff818a5bb7549f90b05e412b76fe448f605ffb/lua/lazyvim/plugins/extras/vscode.lua
return {
  {
    "ggandor/leap.nvim",
    enabled = true,
    keys = {
      { "p", mode = { "n", "x", "o" }, desc = "Leap forward to" },
      { "p", mode = { "n", "x", "o" }, desc = "Leap backward to" },
      { "gp", mode = { "n", "x", "o" }, desc = "Leap from windows" },
    },
  },
}

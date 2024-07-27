vim.opt_local.iskeyword:append("_,@-@,?,!")
-- Handle treesitter not indenting properly following a period.
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/3363
vim.cmd("autocmd FileType ruby setlocal indentkeys-=.")

-- vim.api.nvim_exec2(
--   [[
--   autocmd FileType ruby setlocal shiftwidth=2
-- ]],
--   { output = false }
-- )

-- Handle treesitter not indenting properly following a period.
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/3363
vim.cmd("autocmd FileType ruby setlocal indentkeys-=.")

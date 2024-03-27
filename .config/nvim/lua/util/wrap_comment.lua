local wrap_comment = function(bufnr)
local win = 1265
local pos = vim.api.nvim_win_get_cursor(win)
print(pos)
local row, col = pos
local node = parser:named_node_for_range({ row, prev_col, row, prev_col })local node = parser:named_node_for_range({ row, prev_col, row, prev_col })
local bufnr = vim.api.nvim_get_current_buf()
local parser = vim.treesitter.get_parser(bufnr)
print(parser)
end

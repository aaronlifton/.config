local windows = vim.api.nvim_tabpage_list_wins(0)
local res = vim.iter(windows)
	:map(function(win)
		return vim.api.nvim_win_get_buf(win)
	end)
	:map(function(buf)
		return {
			buf = buf,
			buflisted = vim.bo[buf].buflisted,
			buftype = vim.api.nvim_get_option_value("buftype", { buf = buf }),
			filename = vim.api.nvim_buf_get_name(buf),
		}
	end)
	:totable()

print(res)

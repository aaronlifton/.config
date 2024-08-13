---@class  util.devdocs
---@field get_filepath fun(alias:string):string
local M = {}

local open = function(entry, bufnr, float)
	vim.api.nvim_buf_set_option(bufnr, "modifiable", false) if not float then vim.api.nvim_set_current_buf(bufnr) else local win = nil local last_win = state.get("last_win") local float_opts = { row = 20, col = 40,
			zindex = 10,
		}

		if last_win and vim.api.nvim_win_is_valid(last_win) then
			win = last_win
			vim.api.nvim_win_set_buf(win, bufnr)
		else
			win = vim.api.nvim_open_win(bufnr, true, float_opts)
			state.set("last_win", win)
		end

		vim.wo[win].wrap = config.options.wrap
		vim.wo[win].linebreak = config.options.wrap
		vim.wo[win].nu = false
		vim.wo[win].relativenumber = false
		vim.wo[win].conceallevel = 3
    print(vim.vo[win])
	end

	local ignore = vim.tbl_contains(config.options.cmd_ignore, entry.alias)

	if config.options.previewer_cmd and not ignore then
		M.render_cmd(bufnr)
	else
		vim.bo[bufnr].ft = "markdown"
	end

	vim.bo[bufnr].keywordprg = ":DevdocsKeywordprg"

	state.set("last_buf", bufnr)
	keymaps.set_keymaps(bufnr, entry)
	config.options.after_open(bufnr)
end
---@param alias string
function M.get_filepath(alias)
  local entries = require("nvim-devdocs.list").get_doc_entries({ "lua-5.4" })
  local operations = require("nvim-devdocs.operations")
  local entry = entries[1]
  local splited_path = vim.split(entry.path, ",")
  local file = splited_path[1]
  local file_path = DOCS_DIR:joinpath(entry.alias, file .. ".md")
  local callback = function(lines)

  end

  file_path:_read_async(vim.schedule_wrap(function(content)
    local pattern = splited_path[2]
    -- __AUTO_GENERATED_PRINT_VAR_START__
    print([==[ pattern:]==], vim.inspect(pattern)) -- __AUTO_GENERATED_PRINT_VAR_END__
    local next_pattern = nil

    if entry.next_path ~= nil then
      next_pattern = vim.split(entry.next_path, ",")[2]
    end
    -- __AUTO_GENERATED_PRINT_VAR_START__
    print([==[ next_pattern:]==], vim.inspect(next_pattern)) -- __AUTO_GENERATED_PRINT_VAR_END__

    lines = vim.split(content, "\n")
    callback(lines)
  end))
end

return M

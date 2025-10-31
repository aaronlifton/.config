---@class buf
local M = {}

--- Get current buffer name
M.bufname = function()
  return vim.api.nvim_buf_get_name(vim.fn.bufnr())
end

M.buftype = function()
  return vim.api.nvim_get_option_value("buftype", { buf = 0 })
end

function M.first_buf_with_file()
  local wins = vim.api.nvim_list_wins()
  local wins_with_files = vim.iter(wins):filter(function(win)
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(buf)
    return name ~= "" and not name:find("^/private")
  end)
  local bufnames = vim
    .iter(wins_with_files)
    :map(function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      return vim.api.nvim_buf_get_name(buf)
    end)
    :filter(function(name)
      return not name:find("^/private") and not name:find("^/tmp")
    end)
    :totable()
  return Util.path.bufpath(bufnames[1])
end
return M

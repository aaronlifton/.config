---@class util.tab
local M = {}

M.find_buf_tab = function(bufname)
  local path = require("plenary.path")
  local tabpages = vim.api.nvim_list_tabpages()
  for _, i in ipairs(tabpages) do
    local buflist = vim.fn.tabpagebuflist(i)
    if buflist ~= 0 then
      for _, b in ipairs(buflist) do
        local name = path:new(vim.api.nvim_buf_get_name(b)):make_relative()
        if name == bufname then
          local wins = vim.fn.win_findbuf(b)
          if #wins > 0 then
            local win = wins[1]
            local buf = b
            local tab = i
            return { buf = buf, win = win, tab = tab }
          end
        end
      end
    end
  end
end

M.goto_buf_tab = function(bufname)
  local result = M.find_buf_tab(bufname)
  if not result then return false end

  local tab = result.tab
  local win = result.win
  if tab then
    vim.api.nvim_set_current_tabpage(tab)
    vim.api.nvim_set_current_win(win)
    return true
  end
end

return M

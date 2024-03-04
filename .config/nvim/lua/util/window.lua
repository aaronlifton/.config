local M = {}

function M.win_get_winbot(win)
  local wininfo = vim.fn.getwininfo(win)
  local winbot = wininfo.topline + wininfo.height
end

return M

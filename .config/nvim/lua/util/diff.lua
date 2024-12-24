--- @class util.diff
local M = {
  enabled = false,
}

M.toggle_compare_windows = function()
  if M.enabled then
    vim.cmd("diffoff!")
    M.enabled = false
  else
    M.compare_windows()
    M.enabled = true
  end
end

M.compare_windows = function()
  local windows = vim.api.nvim_tabpage_list_wins(0)
  local compare_windows = {}

  local win1, win2 = table.unpack(windows, 1, 2)
  for _, win in ipairs({ win1, win2 }) do
    local win_buf = vim.api.nvim_win_get_buf(win)
    local buf_name = vim.api.nvim_buf_get_name(win_buf)
    local buf_type = vim.api.nvim_get_option_value("buftype", { buf = win_buf })
    if buf_type ~= "nofile" then table.insert(compare_windows, win) end
  end

  if #compare_windows ~= 2 then
    print("Error: Found " .. #compare_windows .. " non-NeoTree windows. Expected 2.")
    return
  end

  local filetype = vim.api.nvim_get_option_value("filetype", { buf = vim.api.nvim_win_get_buf(compare_windows[1]) })
  for idx, win in ipairs(compare_windows) do
    vim.api.nvim_set_current_win(win)
    vim.cmd("diffthis")
    if idx == 2 then vim.api.nvim_set_option_value("filetype", filetype, { buf = vim.api.nvim_win_get_buf(win) }) end
  end
end

return M

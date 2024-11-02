---@class util.ui
local M = {}

M.list_win_configs = function()
  local wins = vim.api.nvim_list_wins()
  local win_configs = {}
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].ft ~= "nofile" then win_configs[win] = vim.api.nvim_win_get_config(win) end
  end
  return win_configs
end

M.left_most_editor = function()
  local win_configs = M.list_win_configs()
  local widest_windows = {}
  for win, config in pairs(win_configs) do
    table.insert(widest_windows, { win, { width = config.width, id = win } })
  end
  table.sort(widest_windows, function(a, b)
    return a[2].width > b[2].width and a[2].id < b[2].id
  end)
  return widest_windows[1][1]
end

M.earliest_id_win = function()
  local wins = vim.api.nvim_list_wins()
  table.sort(wins, function(a, b)
    return a < b
  end)
  return wins[1]
end

M.earliest_id_buf = function()
  local wins = vim.api.nvim_list_wins()
  table.sort(wins, function(a, b)
    return a < b
  end)
  local buf = vim.api.nvim_win_get_buf(wins[1])
  return buf
end

M.leftmost_editor = function()
  local leftmost_win_id = vim.fn.win_id2win(1)
  return leftmost_win_id
end

function M.is_leftmost_window()
  local winnr = vim.fn.winnr()
  local winnr_left = vim.fn.winnr("l")

  local is_leftmost = winnr == winnr_left
  return is_leftmost
end
function M.leftmost_wins()
  local editor_bufs = vim.tbl_filter(function(buf)
    return vim.api.nvim_buf_is_valid(buf) and vim.fn.buflisted(buf) == 1
  end, vim.api.nvim_list_bufs())
  local editor_wins = vim.tbl_map(function(buf)
    return vim.fn.bufwinid(buf)
  end, editor_bufs)
  local leftwins = {}
  for _, win in ipairs(editor_wins) do
    if M.is_leftmost_window(win) and win ~= -1 then table.insert(leftwins, win) end
  end
  return leftwins
end

function M.goto_leftmost_win()
  local leftwins = M.leftmost_wins()
  if #leftwins == 0 then return end
  vim.api.nvim_set_current_win(leftwins[1])
end

function M.switch_to_highest_window()
  local windows = vim.api.nvim_list_wins()
  local highest_win = windows[1]
  local highest_zindex = vim.api.nvim_win_get_config(highest_win).zindex
  for _, win in ipairs(windows) do
    if vim.api.nvim_win_get_config(win).relative ~= "" then
      highest_win = win
      highest_zindex = vim.api.nvim_win_get_config(highest_win).zindex
      break
    end
  end

  vim.api.nvim_echo({
    { "Highest window\n", "Title" },
    { "Window: " .. highest_win .. "\n", "Normal" },
    { "Zindex: " .. highest_zindex, "Normal" },
  }, false, {})
  vim.api.nvim_set_current_win(highest_win)
end

---@param hl string
function M.square_border(hl)
  return {
    { "┌", hl },
    { "─", hl },
    { "┐", hl },
    { "│", hl },
    { "┘", hl },
    { "─", hl },
    { "└", hl },
    { "│", hl },
  }
end

return M

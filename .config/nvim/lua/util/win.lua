---@class win
local M = {}

local window_sizes = {}
function M.remember_window_sizes()
  local current_tab = vim.api.nvim_get_current_tabpage()
  local windows = vim.api.nvim_tabpage_list_wins(current_tab)

  -- Return early if there's only 1 window
  if #windows <= 1 then return end

  local current_windows = {}

  for _, win in ipairs(windows) do
    local buf_type = vim.api.nvim_get_option_value("buftype", { buf = vim.api.nvim_win_get_buf(win) })
    if buf_type ~= "nofile" then
      local width = vim.api.nvim_win_get_width(win)
      local height = vim.api.nvim_win_get_height(win)
      current_windows[win] = { width = width, height = height }
    end
  end

  -- Initialize tab-specific storage if it doesn't exist
  window_sizes[current_tab] = window_sizes[current_tab] or {}

  if vim.tbl_isempty(window_sizes[current_tab]) then
    -- Store sizes on the first call
    for win, size in pairs(current_windows) do
      window_sizes[current_tab][win] = size
    end
  else
    -- Resize windows on the second call
    for win, size in pairs(window_sizes[current_tab]) do
      if vim.api.nvim_win_is_valid(win) then
        vim.api.nvim_win_set_width(win, size.width)
        vim.api.nvim_win_set_height(win, size.height)
      end
    end
    -- Clear stored sizes for current tab after restoring
    window_sizes[current_tab] = {}
  end
end

-- Add function to clear all stored window sizes
function M.clear_window_sizes()
  window_sizes = {}
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

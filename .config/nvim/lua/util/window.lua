local M = {}

-- Window functions

local window_picker = require("window-picker")

function M.win_get_winbot(win)
  local wininfo = vim.fn.getwininfo(win)
  local winbot = wininfo.topline + wininfo.height
end

function M.pick_window()
  local picked_window_id = window_picker.pick_window({
    include_current_win = true,
  }) or vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(picked_window_id)
end

-- Swap two windows using the awesome window picker
function M.swap_windows()
  local window = window_picker.pick_window({
    include_current_win = false,
  })
  if not window then return end
  local target_buffer = vim.fn.winbufnr(window.id)
  -- Set the target window to contain current buffer
  vim.api.nvim_win_set_buf(window, 0)
  -- Set current window to contain target buffer
  vim.api.nvim_win_set_buf(0, target_buffer)
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

  vim.cmd("echo 'highest window is " .. highest_win .. " with zindex " .. highest_zindex .. "'")
  vim.api.nvim_set_current_win(highest_win)
end

function M.close_all_floating_windows()
  local windows = vim.api.nvim_list_wins()
  for _, win in ipairs(windows) do
    if vim.api.nvim_win_get_config(win).relative ~= "" then vim.api.nvim_win_close(win, true) end
  end
end

function M.render_markdown()
  local content
  local markdown_source = vim.fn.bufnr()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    -- get the element from  the ipairs
    local name = vim.api.nvim_buf_get_name(bufnr)
    if string.match(name, "^termexec") then
      local term_buf = bufnr
      content = vim.api.nvim_buf_get_lines(bufnr, 0, -1, true)
      -- make the bufnr buffer modifiable
      -- TODO: search github for this
      vim.api.nvim_set_option_value("modifiable", true, { buf = term_buf })
      vim.api.nvim_buf_delete(term_buf, { force = true })
      break
    end
  end
  -- write that content to the main buffer
  vim.api.nvim_buf_set_lines(0, 0, -1, true, content)
  vim.api.nvim_buf_set_lines(markdown_source, 0, -1, true, content)
end

return M

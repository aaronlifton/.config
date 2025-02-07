---@class util.win
local M = {}

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

  vim.schedule(function()
    vim.api.nvim_echo({
      { "Highest window\n", "Title" },
      { "Window: " .. highest_win .. "\n", "Normal" },
      { "Zindex: " .. highest_zindex, "Normal" },
    }, false, {})
  end)
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

local skip_buftypes = { "nofile", "quickfix", "terminal", "help" }

--- Returns only editor windows, excluding edgy windows and non-editor buftypes
---@return number[]
function M.editor_windows()
  local windows = vim.api.nvim_tabpage_list_wins(0)
  local edgy_wins = require("edgy.editor").list_wins().edgy
  return vim
    .iter(windows)
    :filter(function(win)
      local buf = vim.api.nvim_win_get_buf(win)
      local buf_type = vim.api.nvim_get_option_value("buftype", { buf = buf })
      return not vim.tbl_contains(skip_buftypes, buf_type)
        and vim.bo[buf].buflisted
        and not vim.tbl_contains(edgy_wins, win)
    end)
    :totable()
end

--- Returns only editor bufs, excluding edgy windows and non-editor buftypes
---@return number[]
function M.editor_bufs()
  local windows = vim.api.nvim_tabpage_list_wins(0)
  local edgy_wins = require("edgy.editor").list_wins().edgy
  return vim
    .iter(windows)
    :filter(function(win)
      return not vim.tbl_contains(edgy_wins, win)
    end)
    :map(function(win)
      return vim.api.nvim_win_get_buf(win)
    end)
    :filter(function(buf)
      local buf_type = vim.api.nvim_get_option_value("buftype", { buf = buf })
      return not vim.tbl_contains(skip_buftypes, buf_type) and vim.bo[buf].buflisted
    end)
    :totable()
end
return M

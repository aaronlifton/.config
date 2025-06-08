---@class util.win
local M = {}

local NOTIFY_TITLE = "  util.win"

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

  if not highest_win then
    vim.notify("No windows found ", vim.log.levels.WARN, { title = NOTIFY_TITLE })
    return
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

--- Returns the window ID of the window with the highest ID with a buffer of
--- filetype `ft`
---@param ft string filetype
---@return number|nil
function M.last_window_with_ft(ft)
  local wins = vim.api.nvim_list_wins()
  local max_id = -1
  local target_win = nil

  -- Find highest ID window with minifiles buffer
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_ft = vim.bo[buf].filetype
    if buf_ft == ft and win > max_id then
      max_id = win
      target_win = win
    end
  end

  return target_win
end

--- Returns the window ID of the window with the lowest ID with a buffer of filetype `ft`
---@param ft string
---@return number|nil
function M.window_with_ft(ft)
  local wins = vim.api.nvim_list_wins()
  for _, win in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(win)
    local buf_ft = vim.bo[buf].filetype
    if buf_ft == ft then return win end
  end
  return nil
end

--- Scrolls a window by `delta` lines
---@param win number
---@param delta number
function M.scroll(win, delta)
  local buf = vim.api.nvim_win_get_buf(win)
  local info = vim.fn.getwininfo(win)[1] or {}
  local top = info.topline or 1
  local content_height = #vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  vim.api.nvim_echo({ { vim.inspect(content_height), "Normal" } }, true, {})
  top = top + delta
  top = math.max(top, 1)
  top = math.min(top, content_height - info.height + 1)

  vim.defer_fn(function()
    vim.api.nvim_buf_call(buf, function()
      vim.api.nvim_command("normal! " .. top .. "zt")
    end)
  end, 0)
end

return M

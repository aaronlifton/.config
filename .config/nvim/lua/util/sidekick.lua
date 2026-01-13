---@class util.sidekick
---@field focus_tui_window fun(ai_name: string)
local M = {}

--- Get the window ID of an AI TUI window
---@param ai_name string
---@return integer | nil
function M.get_tui_window(ai_name)
  local state = require("sidekick.cli.state")

  -- Get all states for "codex".
  -- This returns a list sorted by priority (e.g., matching current working directory first).
  local candidates = state.get({ name = "codex" })

  local win_id = nil
  for _, s in ipairs(candidates) do
    -- Check if there is a terminal backend, and if it has a valid window
    if s.terminal and s.terminal.win and vim.api.nvim_win_is_valid(s.terminal.win) then
      win_id = s.terminal.win
      break -- Found the highest priority (latest/current) window
    end
  end

  -- win_id now contains the window ID or nil
  return win_id
end

--- Get the window ID of an AI TUI window (faster version)
---@param ai_name string
---@return integer | nil
function M.get_tui_window2(ai_name)
  local wins = vim.api.nvim_list_wins()
  for _, w in ipairs(wins) do
    local buf = vim.api.nvim_win_get_buf(w)
    local buf_name = vim.fn.bufname(buf)
      -- stylua: ignore
    if buf_name:sub(0, 4) == "term" and buf_name:sub(buf_name:len() - 4, buf_name:len()) == ai_name then
      return w
    end
  end

  require("sidekick.cli").toggle({ name = ai_name })
end

function M.leap_to_tui_window(ai_name)
  local window_id = M.get_tui_window(ai_name)
  if not window_id then return end

  local function do_leap()
    require("leap").leap({
      windows = { window_id },
    })
  end
  do_leap()
  vim.api.nvim_win_call(window_id, function()
    vim.cmd("stopinsert")
  end)
  do_leap()
  -- vim.api.nvim_win_call(window_id, function()
  --   local esc = vim.api.nvim_replace_termcodes("<C-\\><C-n>", true, false, true)
  --   vim.api.nvim_feedkeys(esc, "n", false)
  -- end)
end

function M.focus_tui_window(ai_name)
  local window_id = M.get_tui_window2(ai_name)
  if not window_id then return end

  vim.api.nvim_set_current_win(window_id)
  -- vim.api.nvim_win_call(window_id, function()
  --   vim.cmd("stopinsert")
  -- end)
end

return M

---@class util.ai.avante
local M = {
  debug = false,
}

-- ## Example Scenarios
--
-- **All windows present (60 + 10 + 10 + 20 = 100):**
-- - Avante: 60%
-- - AvanteSelectedCode: 10%
-- - AvanteSelectedFiles: 10%
-- - AvanteInput: 20%
--
-- **Only core windows present (60 + 20 = 80):**
-- - Avante: 75% (60/80 * 100)
-- - AvanteInput: 25% (20/80 * 100)
--
-- **Missing AvanteSelectedCode (60 + 10 + 20 = 90):**
-- - Avante: 67% (60/90 * 100)
-- - AvanteSelectedFiles: 11% (10/90 * 100)
-- - AvanteInput: 22% (20/90 * 100)
--
-- This approach ensures the window sizing always works correctly regardless of which Avante windows are currently open, making the function much more robust and flexible.

-- Window size configuration (relative weights)
local FILETYPES = {
  Avante = 60,
  AvanteSelectedCode = 10,
  AvanteSelectedFiles = 10,
  AvanteInput = 20,
}

--- Reset the sizes of each Avante sidebar panel
function M.reset_window_sizes()
  local current_lines = vim.o.lines
  local avante_wins = {}

  -- Single pass through windows to find Avante windows
  for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
    if FILETYPES[ft] then avante_wins[ft] = win end
  end

  -- Early return if no Avante windows found
  if vim.tbl_isempty(avante_wins) then
    vim.notify("No Avante windows found", vim.log.levels.WARN)
    return
  end

  -- Calculate dynamic total based on present windows
  local total_size = 0
  for ft, _ in pairs(avante_wins) do
    total_size = total_size + FILETYPES[ft]
  end

  -- Resize windows with dynamic calculations
  for ft, win in pairs(avante_wins) do
    local size = FILETYPES[ft]
    local percentage = math.floor((size / total_size) * 100)
    local message = ("Resetting %s window size to %d%%"):format(ft, percentage)

    -- Use simpler echo without vim.inspect for better performance
    if M.debug then vim.api.nvim_echo({ { message, "Normal" } }, true, {}) end

    -- Calculate height based on dynamic total and set
    local height = math.floor((size / total_size) * current_lines)
    vim.api.nvim_win_set_height(win, height)
  end
end

return M

local M = {}

local mf = require("mini.files")

function M.map_split(buf_id, lhs, direction)
  local rhs = function()
    local fsentry = mf.get_fs_entry()
    if fsentry.fs_type ~= "file" then return end
    -- Make new window and set it as target
    local new_target_window
    vim.api.nvim_win_call(mf.get_explorer_state().target_window, function()
      vim.cmd(direction .. " split")
      new_target_window = vim.api.nvim_get_current_win()
    end)

    mf.set_target_window(new_target_window)
    mf.go_in()
    mf.close()
  end

  -- Adding `desc` will result into `show_help` entries
  local desc = "Split " .. direction
  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

return M

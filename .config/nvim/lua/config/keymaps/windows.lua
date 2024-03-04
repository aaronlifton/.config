local keymap = require("util").keymap
local map = keymap.map

-- Window functions

map("n", ",W", keymap.swap_windows, { desc = "Swap windows", silent = true })
map("n", "<leader>wh", keymap.switch_to_highest_window, { desc = "Switch to highest window", silent = true })
map("n", ",w", function()
  require("window-picker").pick_window()
end, { desc = "Pick a window", silent = true })

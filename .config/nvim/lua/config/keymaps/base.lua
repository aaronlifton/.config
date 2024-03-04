local util = require("util")
local map = util.keymap.map

-- Window functions

map("v", "<S-s>", "<cmd>:norm ^v$<cr>", { desc = "Select line contents", silent = true })

local keymap = require("util").keymap
local map = keymap.map

-- Window functions

map("n", ",W", keymap.swap_windows, { desc = "Swap windows", silent = true })
map("n", "<leader>wh", keymap.switch_to_highest_window, { desc = "Switch to highest window", silent = true })
map("n", ",w", function()
  require("window-picker").pick_window()
end, { desc = "Pick a window", silent = true })

-- keymap for re-opening last closed indow in same position

-- echo all buffer names
map("n", "<leader>wa", function()
  local datalist = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if not vim.api.nvim_buf_is_loaded(buf) then
      goto continue
    end
    if vim.api.nvim_buf_get_name(buf) == "" then
      goto continue
    end
    local name = vim.api.nvim_buf_get_name(buf)

    -- print(name)
    -- get the filetype with the lua api

    local data = { name = name, ft = vim.bo[buf].ft }
    -- print(require("inspect")(data))
    table.insert(datalist, data)
    ::continue::
  end
  vim.api.nvim_echo({ { require("inspect")(datalist), "Question" } }, false, {})
end, { noremap = true })

-- local bufs = vim.iter(vim.api.nvim_list_bufs()):filter(vim.api.nvim_buf_is_loaded)
-- local y = #bufs
-- for _, buf in ipairs(bufs) do
--   vim.api.nvim_echo({ { buf.name, "none" } }, false, {})
-- end

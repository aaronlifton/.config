local keys = {}
local enable_groups = false

-- stylua: ignore start
for i = 1, 9 do
  table.insert(keys, { "<leader>b" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", desc = "Buffer " .. i })
end

table.insert(keys, { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" })
table.insert(keys, { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" })
table.insert(keys, { "<space><", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" })
table.insert(keys, { "<space>>", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" })
-- Consider removing this in favor of snacks scratch buffer
table.insert(keys, { "<leader>.", "<Cmd>BufferLinePick<CR>", desc = "Pick Buffer" })
table.insert(keys, { "<leader>b<C-,>", function() require("bufferline").move_to(1) end, desc = "Move buffer to start" })
table.insert(keys, { "<leader>b<C-.>", function() require("bufferline").move_to(-1) end, desc = "Move buffer to end" })

table.insert(keys, { "<leader>bS", "<Cmd>BufferLineSortByDirectory<CR>", desc = "Sort By Directory" })
table.insert(keys, { "<leader>bs", "<Cmd>BufferLineSortByExtension<CR>", desc = "Sort By Extensions" })
table.insert(keys, { "<leader>b<C-s>", "<Cmd>BufferLineSortByTabs<CR>", desc = "Sort By Tabs" })
table.insert(keys, { "<leader>b<M-s>", function() require('bufferline').sort_by(Util.bufferline.sort.category_sort) end, desc = "Custom Sort"})

table.insert(keys, { "<leader><Tab>r", function()
  Snacks.input({
    prompt = "Rename Tab: ",
    completion = "customlist,v:lua.Util.bufferline.complete.tab",
  }, function(name)
    if not name or name == "" then return end

    vim.cmd("BufferLineTabRename " .. name)
  end)
end, desc = "Rename Tab"})
-- stylua: ignore end

return keys

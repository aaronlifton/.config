local keys = {}

-- stylua: ignore start
for i = 1, 9 do
  table.insert(keys, { "<leader>b" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", desc = "Buffer " .. i })
end

table.insert(keys, { "[B", "<cmd>BufferLineMovePrev<cr>", desc = "Move buffer prev" })
table.insert(keys, { "]B", "<cmd>BufferLineMoveNext<cr>", desc = "Move buffer next" })
table.insert(keys, { "<leader>.", "<Cmd>BufferLinePick<CR>", desc = "Pick Buffer" })

table.insert(keys, { "<leader>bS", "<Cmd>BufferLineSortByDirectory<CR>", desc = "Sort By Directory" })
table.insert(keys, { "<leader>bs", "<Cmd>BufferLineSortByExtension<CR>", desc = "Sort By Extensions" })
-- stylua: ignore end

return {
  "akinsho/bufferline.nvim",
  keys = keys,
  opts = {
    -- modified_icon = "",
    -- color_icons = true,
    -- separator_style = "slope",
    highlights = {
      fill = {
        fg = "#ffffff",
        bg = "#000000",
      },
      -- background = {
      --   fg = "<colour-value-here>",
      --   bg = "<colour-value-here>",
      -- },
      -- tab = {
      --   fg = "<colour-value-here>",
      --   bg = "<colour-value-here>",
      -- },
      -- tab_selected = {
      --   fg = "<colour-value-here>",
      --   bg = "<colour-value-here>",
      -- },
    },
  },
}

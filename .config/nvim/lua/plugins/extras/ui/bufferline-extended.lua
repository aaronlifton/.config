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

return {
  "akinsho/bufferline.nvim",
  keys = keys,
  opts = function(_, opts)
    opts.options = opts.options or {}
    if enable_groups then
      local moon = require("tokyonight.colors.moon")
      opts.options.groups = {
        options = {
          toggle_hidden_on_enter = true, -- when you re-enter a hidden group this options re-opens that group so the buffer is visible
        },
        items = {
          require("bufferline.groups").builtin.pinned:with({ icon = "󰐃 " }),
          -- {
          --   name = "Tests", -- Mandatory
          --   -- -- @type bufferline.HLGroup
          --   -- -- highlight = { underline = true }, -- Optional
          --   priority = 2, -- determines where it will appear relative to other groups (Optional)
          --   icon = " ", -- Optional
          --   ---@param buf {buftype: string, id: number, modified: boolean, name: string, path: string}
          --   matcher = function(buf) -- Mandatory
          --     if not buf.path then return false end
          --
          --     return buf.path:match("%_test") or buf.path:match("%_spec")
          --   end,
          -- },
          {
            name = "Docs",
            ---@type bufferline.HLGroup
            highlight = { sp = moon.dark3, fg = moon.fg, bg = moon.bg_dark },
            auto_close = false, -- whether or not close this group if it doesn't contain the current buffer
            matcher = function(buf)
              if not buf.path then return false end

              return buf.path:match("%.md") or buf.path:match("%.txt")
            end,
            separator = { -- Optional
              style = require("bufferline.groups").separator.tab,
            },
          },
        },
      }
    end
  end,
  -- opts = {
  -- options = {
  --   modified_icon = "",
  --   color_icons = true,
  --   separator_style = "slope",
  -- },
  -- highlights = {
  --   fill = {
  --     fg = "#ffffff",
  --     bg = "#000000",
  --   },
  --   background = {
  --     fg = "<colour-value-here>",
  --     bg = "<colour-value-here>",
  --   },
  --   tab = {
  --     fg = "<colour-value-here>",
  --     bg = "<colour-value-here>",
  --   },
  --   tab_selected = {
  --     fg = "<colour-value-here>",
  --     bg = "<colour-value-here>",
  --   },
  -- },
  -- },
}

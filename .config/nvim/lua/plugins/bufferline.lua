local keys = {}

-- stylua: ignore start
for i = 1, 9 do
  table.insert(keys, { "<leader>b" .. i, "<cmd>BufferLineGoToBuffer " .. i .. "<cr>", desc = "Buffer " .. i })
end

-- [b and ]b in lazyvim 
table.insert(keys, { "<leader>.", "<Cmd>BufferLinePick<CR>", desc = "Pick Buffer" })

table.insert(keys, { "<leader>bS", "<Cmd>BufferLineSortByDirectory<CR>", desc = "Sort By Directory" })
table.insert(keys, { "<leader>bs", "<Cmd>BufferLineSortByExtension<CR>", desc = "Sort By Extensions" })
-- stylua: ignore end
return {
  "akinsho/bufferline.nvim",
  optional = true,
  dependencies = {
    "backdround/tabscope.nvim",
    opts = {},
  },
  keys = keys,
  opts = function()
    local Offset = require("bufferline.offset")
    if not Offset.edgy then
      local get = Offset.get
      Offset.get = function()
        if package.loaded.edgy then
          local layout = require("edgy.config").layout
          local ret = { left = "", left_size = 0, right = "", right_size = 0 }
          for _, pos in ipairs({ "left", "right" }) do
            local sb = layout[pos]
            if sb and #sb.wins > 0 then
              local title = " Sidebar" .. string.rep(" ", sb.bounds.width - 8)
              ret[pos] = "%#EdgyTitle#" .. title .. "%*" .. "%#WinSeparator#│%*"
              ret[pos .. "_size"] = sb.bounds.width
            end
          end
          ret.total_size = ret.left_size + ret.right_size
          if ret.total_size > 0 then
            return ret
          end
        end
        return get()
      end
      Offset.edgy = true
    end
  end,
}

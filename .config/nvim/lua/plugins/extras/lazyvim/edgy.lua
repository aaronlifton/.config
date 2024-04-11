--- Removes 1 window at a time, since this relies on table.remove and the table length
--- may change during an iteration.
---@param edgebar (Edgy.Window|{title: string})[]
local remove_from_edgebar = function(edgebar, title)
  for idx, win in ipairs(edgebar) do
    if win.title == title then
      table.remove(edgebar, idx)
      break
    end
  end
end

return {
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    optional = true,
    opts = function(_, opts)
      opts.left = opts.left or {} ---@type (Edgy.Window|{title: string})[]
      local sections_to_remove = { "Neo-Tree Git", "Neo-Tree Buffers" }
      for _, title in ipairs(sections_to_remove) do
        remove_from_edgebar(opts.left, title)
      end
    end,
  },
}

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
      opts.animate = { enabled = false }
      -- Remove Neo-tree git and buffer sections from left edgebar
      -- opts.left = opts.left or {} ---@type (Edgy.Window|{title: string})[]
      -- local sections_to_remove = { "Neo-Tree Git status", "Neo-Tree Buffers" }
      -- for _, title in ipairs(sections_to_remove) do
      --   remove_from_edgebar(opts.left, title)
      -- end

      -- Move DBUI to bottom of right edgebar
      local dbui_idx = nil
      for idx, win in ipairs(opts.right) do
        if win.title == "Database" then
          dbui_idx = idx
          break
        end
      end
      opts.right[#opts.right + 1] = table.remove(opts.right, dbui_idx)



      return opts
    end,
  },
}

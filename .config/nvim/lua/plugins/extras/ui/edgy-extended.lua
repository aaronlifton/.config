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

---@param win Edgy.Window
local function toggle_auto_expand_width(win)
  -- to load the filetypes
  -- require("edgy")

  local neotree_toggle_auto_expand_width = require("neo-tree.sources.common.commands").toggle_auto_expand_width
  local win_width = vim.api.nvim_win_get_width(0)
  local state = require("neo-tree.sources.manager").get_state("filesystem")
  if state.window.auto_expand_width then
    neotree_toggle_auto_expand_width(state)
    win.view.edgebar:equalize()
    return
  end

  neotree_toggle_auto_expand_width(state)
  while win_width < state.win_width + 1 do
    win:resize("width", 1)
    win_width = win_width + 1
  end
end

return {
  { import = "lazyvim.plugins.extras.ui.edgy" },
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
      -- local dbui_idx = nil
      -- for idx, win in ipairs(opts.right) do
      --   if win.title == "Database" then
      --     dbui_idx = idx
      --     break
      --   end
      -- end
      -- if dbui_idx then opts.right[#opts.right + 1] = table.remove(opts.right, dbui_idx) end

      opts.keys["e"] = toggle_auto_expand_width
      opts.right = {
        {
          title = "Outline",
          ft = "grapple",
          open = "AerialToggle",
          size = {
            width = 0.13,
          },
        },
      }

      return opts
    end,
  },
}

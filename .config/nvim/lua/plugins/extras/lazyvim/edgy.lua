return {
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      -- local left_keys = {}
      -- opts.bottom[1] = {}
      -- for idx, _ in pairs(opts.bottom) do
      --   if idx > 1 then opts.bottom[idx - 1] = opts[idx] end
      -- end
      -- local tmp = opts.left[#left_keys - 1]
      -- opts.left[#left_keys - 1] = { ft = "hydra_hint", title = "Hydra", size = { height = 0.5 }, pinned = true }
      -- table.insert(opts.left, tmp)

      -- table.insert(opts.bottom, {})
      -- table.insert(opts.left,
      --   { ft = "hydra_hint", title = "Hydra", size = { height = 0.5 }, pinned = true },
      -- )
      -- opts.left = opts.left or {}
      -- opts.left = {
      --   -- {
      --   --   title = "Neo-Tree",
      --   --   ft = "neo-tree",
      --   --   filter = function(buf)
      --   --     return vim.b[buf].neo_tree_source == "filesystem"
      --   --   end,
      --   --   pinned = true,
      --   --   open = function()
      --   --     vim.api.nvim_input("<esc><space>e")
      --   --   end,
      --   --   size = { height = 0.5 },
      --   -- },
      --   {
      --     title = "MiniFiles",
      --     ft = "minifiles",
      --     filter = function(buf)
      --       return vim.b[buf].neo_tree_source == "filesystem"
      --     end,
      --     pinned = true,
      --     open = function()
      --       vim.api.nvim_input("<esc><space>e")
      --     end,
      --     size = { height = 0.5 },
      --   },
      -- { ft = "hydra_hint", title = "Hydra", size = { height = 0.5 }, pinned = true },
      --   { title = "Neotest Summary", ft = "neotest-summary" },
      -- }
      -- return opts
    end,
  },
}

return {
  {
    import = "lazyvim.plugins.extras.coding.yanky",
  },
  {
    "gbprod/yanky.nvim",
    opts = function(_, opts)
      opts.highlight = { timer = 250 }

      if LazyVim.has("telescope.nvim") then
        local utils = require("yanky.utils")
        local mapping = require("yanky.telescope.mapping")

        opts.picker = {
          telescope = {
            use_default_mappings = false,
            mappings = {
              default = mapping.put("p"),
              i = {
                ["<c-g>"] = mapping.put("p"),
                ["<c-h>"] = mapping.put("P"),
                ["<c-x>"] = mapping.delete(),
                ["<c-r>"] = mapping.set_register(utils.get_default_register()),
              },
              n = {
                p = mapping.put("p"),
                P = mapping.put("P"),
                d = mapping.delete(),
                r = mapping.set_register(utils.get_default_register()),
              },
            },
          },
        }
      end
    end,
    keys = {
      -- {
      --   -- interferes with leap
      --   "<leader>sy",
      --   function()
      --     if LazyVim.pick.picker.name == "telescope" then
      --       require("telescope").extensions.yank_history.yank_history({})
      --     else
      --       vim.cmd([[YankyRingHistory]])
      --     end
      --   end,
      --   mode = { "n", "v" },
      --   desc = "Yank History",
      -- },
    },
  },
}

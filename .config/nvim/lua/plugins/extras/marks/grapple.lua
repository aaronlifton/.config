local keys = {}

-- stylua: ignore start
for i = 1, 9 do
  table.insert(keys, { "<leader>m" .. i, "<cmd>Grapple select index=" .. i .. "<CR>", desc = "File " .. i })
end

-- local chars = { "q", "w", "e", "r" }
-- for idx, char in ipairs(chars) do 
--   table.insert(keys, { "<leader>m" .. char, "<cmd>Grapple select index=" .. idx .. "<CR>", desc = "File " .. string.upper(char) })
-- end
table.insert(keys, { "<leader>ma", "<cmd>Grapple toggle<CR>", desc = "Toggle Mark" })

table.insert(keys, { "<leader>M", "<cmd>Grapple toggle_tags<CR>", desc = "Marks" })
-- table.insert(keys, { "<leader>mt", "<cmd>Telescope grapple tags<CR>", desc = "Marks (Telescope)" })
table.insert(keys, { "<leader>mx", "<cmd>Grapple reset<CR>", desc = "Clear all Marks" })
table.insert(keys, { "<leader>ms", "<cmd>Grapple toggle_scopes<CR>", desc = "Scopes" })
table.insert(keys, { "<leader>mS", "<cmd>Grapple toggle_loaded<CR>", desc = "Loaded Scopes" })

-- Harpoon style
table.insert(keys, { "<D-H>", "<cmd>Grapple select index=1<cr>", desc = "File 1" })
table.insert(keys, { "<D-J>", "<cmd>Grapple select index=2<cr>", desc = "File 2" })
table.insert(keys, { "<D-K>", "<cmd>Grapple select index=3<cr>", desc = "File 3" })
table.insert(keys, { "<D-L>", "<cmd>Grapple select index=4<cr>", desc = "File 4" })
table.insert(keys, { "<C-S-L>", "<cmd>Grapple cycle forward<CR>", desc = "Next Mark" })
table.insert(keys, { "<C-S-H>", "<cmd>Grapple cycle backward<CR>", desc = "Prev Mark" })
-- table.insert(keys, { "]k", "<cmd>Grapple cycle forward<CR>", desc = "Next Mark" })
-- table.insert(keys, { "[k", "<cmd>Grapple cycle backward<CR>", desc = "Prev Mark" })
-- table.insert(keys, { "<c-s-n>", "<cmd>Grapple cycle_tags next<cr>", desc = "Next Mark" })
-- table.insert(keys, { "<c-s-p>", "<cmd>Grapple cycle_tags prev<cr>", desc = "Prev Mark" })
-- stylua: ignore end

return {
  {
    "cbochs/grapple.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      optional = true,
    },
    cmd = { "Grapple" },
    keys = keys,
    config = function()
      require("grapple").setup()
      if vim.g.lazyvim_picker == "telescope" then
        LazyVim.on_load("telescope.nvim", function()
          require("telescope").load_extension("grapple")
        end)
      end
    end,
  },
  -- {
  --   "goolord/alpha-nvim",
  --   optional = true,
  --   opts = function(_, dashboard)
  --     local button = dashboard.button("m", "󰛢 " .. " Marks", "<cmd>Grapple toggle_tags<CR>")
  --     button.opts.hl = "AlphaButtons"
  --     button.opts.hl_shortcut = "AlphaShortcut"
  --     table.insert(dashboard.section.buttons.val, 5, button)
  --   end,
  -- },
  {
    "nvimdev/dashboard-nvim",
    optional = true,
    opts = function(_, opts)
      local grapple = {
        action = "Grapple toggle_tags",
        desc = " Marks",
        icon = "󰛢 ",
        key = "m",
      }

      grapple.desc = grapple.desc .. string.rep(" ", 43 - #grapple.desc)
      grapple.key_format = "  %s"

      table.insert(opts.config.center, 5, grapple)
    end,
  },
  {
    "echasnovski/mini.starter",
    optional = true,
    opts = function(_, opts)
      local util = require("util.dashboard")
      opts.items = vim.list_extend(opts.items, {
        util.new_section("Marks 󰛢", "Grapple toggle_tags", "Telescope"),
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      table.insert(opts.sections.lualine_c, { require("grapple").statusline, cond = require("grapple").exists })
    end,
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        mode = "n",
        { "<leader>m", group = "marks", icon = { icon = "󰛢", color = "white" } },
        { "<leader>M", icon = { icon = "󰛢", color = "white" } },
      },
    },
  },
}

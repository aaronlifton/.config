local prefix = "<leader>m"
local keys = {}

for i = 1, 9 do
  table.insert(keys, { prefix .. i, "<cmd>Grapple select index=" .. i .. "<CR>", desc = "File " .. i })
end

table.insert(keys, {
  prefix .. "a",
  function()
    local cursor = vim.api.nvim_win_get_cursor(0)
    require("grapple").toggle({ cursor = cursor })
  end,
  desc = "Toggle Mark",
})

-- stylua: ignore start
table.insert(keys, { "<leader>M", "<cmd>Grapple toggle_tags<CR>", desc = "Marks" })
-- table.insert(keys, { prefix .. "t", "<cmd>Telescope grapple tags<CR>", desc = "Marks (Telescope)" })
table.insert(keys, { prefix .. "x", "<cmd>Grapple reset<CR>", desc = "Clear all Marks" })
table.insert(keys, { prefix .. "s", "<cmd>Grapple toggle_scopes<CR>", desc = "Scopes" })
table.insert(keys, { prefix .. "S", "<cmd>Grapple toggle_loaded<CR>", desc = "Loaded Scopes" })
table.insert(keys, { prefix .. "p", function() require("grapple").prune({ limit = "1d"}) end, desc = "Prune (1d)" })
table.insert(keys, {
  prefix .. "P",
  function()
    vim.ui.select({ "120s", "15m", "6h", "1d", "7d", "30d", "All" }, { prompt = "Prune" }, function(choice)
      if choice == "All" then choice = nil end
      require("grapple").prune({ limit = choice })
    end)
  end,
  desc = "Prune (select)",
})

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

-- local chars = { "q", "w", "e", "r" }
-- for idx, char in ipairs(chars) do
--   table.insert(keys, { prefix .. char, "<cmd>Grapple select index=" .. idx .. "<CR>", desc = "File " .. string.upper(char) })
-- end
-- table.insert(keys, { prefix .. "a", "<cmd>Grapple toggle<CR>", desc = "Toggle Mark" })
-- stylua: ignore end

return {
  {
    "cbochs/grapple.nvim",
    dependencies = {
      -- This loads nvim-web-devicons, when it is actually mocked via mini.icons by LazyVim
      -- { "nvim-tree/nvim-web-devicons", optional = true },
      {
        "nvim-lualine/lualine.nvim",
        optional = true,
        opts = function(_, opts)
          -- Lazy-load lualine section
          table.insert(opts.sections.lualine_c, {
            function()
              return "󰛢 " .. require("grapple").name_or_index()
              -- return require("grapple").statusline()
            end,
            cond = function()
              return package.loaded["grapple"] and require("grapple").exists()
            end,
          })
        end,
      },
    },
    cmd = { "Grapple" },
    keys = keys,
    opts = {
      scope = "git_branch",
      win_opts = {
        border = "rounded",
        footer = "", -- disable footer
      },
      scopes = {
        {
          name = "help",
          desc = "Helpfiles",
          fallback = "global",
          resolver = function()
            local data = vim.fn.stdpath("data") --[[@as string]]
            -- local cellar = "/opt/homebrew/Cellar/neovim/%d+.%d+.%d+_%d+/"
            -- local cellar = ".*opt/homebrew/Cellar/"
            local cellar = ".*opt/homebrew/Cellar/neovim/%d+.%d+.%d+/"
            local current_file = vim.api.nvim_buf_get_name(0)
            local _helpfile, found = current_file:gsub(data, "")
            if found == 1 then return "help", data end
            _helpfile, found = current_file:gsub(cellar, "")
            if found == 1 then return "help", cellar end
          end,
        },
      },
    },
    config = function(_, opts)
      require("grapple").setup(opts)
      if vim.g.lazyvim_picker == "telescope" then
        LazyVim.on_load("telescope.nvim", function()
          require("telescope").load_extension("grapple")
        end)
      end
    end,
  },
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
    "folke/which-key.nvim",
    opts = {
      spec = {
        mode = "n",
        { prefix, group = "marks", icon = { icon = "󰛢", color = "white" } },
        { "<leader>M", icon = { icon = "󰛢", color = "white" } },
      },
    },
  },
}

-- Inspo
-- https://github.com/Subjective/dotfiles/blob/ef31a6214b063582ee99bd639c9bc945481965fd/.config/nvim/lua/plugins/motion.lua#L108

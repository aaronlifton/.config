return {
  { "akinsho/bufferline.nvim", enabled = false },
  { "nvim-lualine/lualine.nvim", enabled = false },
  -- { "rebelot/heirline.nvim", enabled = false },
  {
    "NvChad/base46",
    build = function()
      require("base46").load_all_highlights()
    end,
  },
  "nvzone/volt",
  {
    "nvzone/menu",
    cmd = "NvzoneMenuOpen",
    config = function(_, _opts)
      vim.api.nvim_create_user_command("NvzoneMenuOpen", function()
        require("menu").open("default")
      end, {})

      -- Keyboard uers
      vim.keymap.et("n", "<C-t>", function()
        require("menu").open("default")
      end, {})

      -- mouse users + nvimtree users!
      vim.keymap.set({ "n", "v" }, "<RightMouse>", function()
        require("menu.utils").delete_old_menus()

        vim.cmd.exec('"normal! \\<RightMouse>"')

        -- clicked buf
        local buf = vim.api.nvim_win_get_buf(vim.fn.getmousepos().winid)
        local options = vim.bo[buf].ft == "NvimTree" and "nvimtree" or "default"

        require("menu").open(options, { mouse = true })
      end, {})
    end,
  },
  { "nvzone/minty", cmd = { "Huefy", "Shades" } },
  {
    "nvchad/ui",
    event = "UIEnter",
    opts = {
      base46 = {
        -- theme = "onedark",
        -- theme = "material-deep-ocean",
        theme = "chadracula-evondev",
        theme_toggle = { "chadracula-evondev", "chadracula-evondev" },
      },
      --       nvdash = {
      --         header = [[
      --                                              
      --       ████ ██████           █████      ██
      --      ███████████             █████ 
      --      █████████ ███████████████████ ███   ███████████
      --     █████████  ███    █████████████ █████ ██████████████
      --    █████████ ██████████ █████████ █████ █████ ████ █████
      --  ███████████ ███    ███ █████████ █████ █████ ████ █████
      -- ██████  █████████████████████ ████ █████ █████ ████ ██████
      --       ]],
      --         buttons = {
      --           { txt = "  Find File", keys = "Spc f f", cmd = "FzfLua files" },
      --           { txt = "  Recent Files", keys = "Spc f o", cmd = "FzfLua oldfiles" },
      --           { txt = "󰈭  Find Word", keys = "Spc f w", cmd = "FzfLua live_grep" },
      --           { txt = "󱥚  Themes", keys = "Spc f t", cmd = ":lua require('nvchad.themes').open()" },
      --           { txt = "  Last Session", keys = "Spc S l", cmd = "NvCheatsheet" },
      --
      --           { txt = "─", hl = "NvDashLazy", no_gap = true, rep = true },
      --
      --           {
      --             txt = function()
      --               local stats = require("lazy").stats()
      --               local ms = math.floor(stats.startuptime) .. " ms"
      --               return "  Loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms
      --             end,
      --             hl = "NvDashLazy",
      --             no_gap = true,
      --           },
      --
      --           { txt = "─", hl = "NvDashLazy", no_gap = true, rep = true },
      --         },
      --       },
      ui = {
        statusline = {
          enabled = true,
        },
        -- https://github.com/search?q=path%3A**%2Fplugins%2F**%2F*.lua+tabufline&type=code&query=path%3A**%2Fnvim%2F**%2Fextras%2F**nvchad+
        tabufline = {
          enabled = true,
        },
        cmp = {
          icons_left = true, -- only for non-atom styles!
          style = "default", -- default/flat_light/flat_dark/atom/atom_colored
          abbr_maxwidth = 60,
          format_colors = {
            tailwind = true, -- will work for css lsp too
            icon = "󱓻",
          },
        },
      },
    },
    init = function()
      -- load the lazy opts on module load
      package.preload["chadrc"] = function()
        local plugin = require("lazy.core.config").spec.plugins["ui"]
        return require("lazy.core.plugin").values(plugin, "opts", false)
      end
    end,
    config = function()
      for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
        dofile(vim.g.base46_cache .. v)
      end

      local map = vim.keymap.set
      map("n", "<leader>ch", "<CMD>NvCheatsheet<CR>", { desc = "Toggle nvcheatsheet" })
      map({ "n", "t" }, "<M-t>", function()
        require("nvchad.term").toggle({ pos = "float", id = "floatTerm" })
      end, { desc = "Terminal Toggle floating term" })
      map("n", "<tab>", function()
        require("nvchad.tabufline").next()
      end, { desc = "Buffer goto next" })

      map("n", "<S-tab>", function()
        require("nvchad.tabufline").prev()
      end, { desc = "Buffer goto prev" })

      map({ "n", "i" }, "<A-q>", function()
        require("nvchad.tabufline").close_buffer()
      end, { desc = "Buffer Close" })

      map("n", "<leader>th", function()
        require("nvchad.themes").open()
      end, { desc = "nvchad themes" })

      map("n", "<leader>cp", function()
        require("minty.huefy").open()
      end)

      require("nvchad")
    end,
    keys = {
      {
        "<leader>bn",
        function()
          require("nvchad.tabufline").next()()
        end,
        "Next buffer",
      },
      {
        "<leader>bp",
        function()
          require("nvchad.tabufline").prev()()
        end,
        "Previous buffer",
      },
      { "<leader>bd", "<cmd>bd<cr>", "Close current buffer" },
      { "<leader>bD", "<cmd>%bd|e#<cr>", "Close other buffers" },
      {
        "<leader>uC",
        function()
          require("nvchad.themes").open()
        end,
        "Colorscheme with preview",
      },
    },
    specs = {
      {
        "saghen/blink.cmp",
        optional = true,
        opts = function(_, opts)
          return vim.tbl_deep_extend("force", opts, require("nvchad.blink").config)
        end,
      },
    },
  },
}

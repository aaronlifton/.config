return {
  {
    "AstroNvim/astrotheme",
    opts = {
      palette = "astrodark", -- String of the default palette to use when calling `:colorscheme astrotheme`
      background = { -- :h background, palettes to use when using the core vim background colors
        light = "astrolight",
        dark = "astrodark",
      },

      style = {
        transparent = false, -- Bool value, toggles transparency.
        inactive = true, -- Bool value, toggles inactive window color.
        float = true, -- Bool value, toggles floating windows background colors.
        neotree = true, -- Bool value, toggles neo-trees background color.
        border = true, -- Bool value, toggles borders.
        title_invert = true, -- Bool value, swaps text and background colors.
        italic_comments = true, -- Bool value, toggles italic comments.
        simple_syntax_colors = true, -- Bool value, simplifies the amounts of colors used for syntax highlighting.
      },

      termguicolors = true, -- Bool value, toggles if termguicolors are set by AstroTheme.

      terminal_color = true, -- Bool value, toggles if terminal_colors are set by AstroTheme.

      plugin_default = "auto", -- Sets how all plugins will be loaded
      -- "auto": Uses lazy / packer enabled plugins to load highlights.
      -- true: Enables all plugins highlights.
      -- false: Disables all plugins.

      plugins = { -- Allows for individual plugin overrides using plugin name and value from above.
        ["avante.nvim"] = "avante",
        ["blink.cmp"] = package.loaded["blink.cmp"],
        ["bufferline.nvim"] = package.loaded["bufferline"],
        ["fzf-lua"] = true,
        ["lazy.nvim"] = true,
        ["mason.nvim"] = true,
        ["mini.nvim"] = true,
        ["mini.icons"] = true,
        ["neo-tree.nvim"] = true,
        ["neogit"] = true,
        ["noice.nvim"] = true,
        ["nvim-cmp"] = true,
        ["nvim-notify"] = true,
        ["nvim-web-devicons"] = true,
        ["render-markdown.nvim"] = true,
        ["snacks.nvim"] = true,
        ["todo-comments.nvim"] = true,
        ["which-key.nvim"] = true,
        -- Disabled
        ["window-picker"] = false,
        ["aerial.nvim"] = false,
        ["beacon.nvim"] = false,
        ["dashboard-nvim"] = false,
        ["flash.nvim"] = false,
        ["gitsigns.nvim"] = false,
        ["hop.nvim"] = false,
        ["indent-blankline.nvim"] = false,
        ["lightspeed.nvim"] = false,
        ["mini.starter"] = false,
        ["nvcheatsheet.nvim"] = false,
        ["nvim-dap-ui"] = false,
        ["nvim-tree.lua"] = false,
        ["nvim-ts-rainbow"] = false,
        ["nvim-ts-rainbow2"] = false,
        ["nvim-window-picker"] = false,
        ["rainbow-delimiters.nvim"] = false,
        ["spotlight.nvim"] = false,
        ["symbols-outline.nvim"] = false,
        ["telescope.nvim"] = false,
        ["vim-illuminate"] = false,
        ["vimwiki"] = false,
      },

      -- palettes = {
      --   global = { -- Globally accessible palettes, theme palettes take priority.
      --     my_grey = "#ebebeb",
      --     my_color = "#ffffff",
      --   },
      --   astrodark = { -- Extend or modify astrodarks palette colors
      --     ui = {
      --       red = "#800010", -- Overrides astrodarks red UI color
      --       accent = "#CC83E3", -- Changes the accent color of astrodark.
      --     },
      --     syntax = {
      --       cyan = "#800010", -- Overrides astrodarks cyan syntax color
      --       comments = "#CC83E3", -- Overrides astrodarks comment color.
      --     },
      --     my_color = "#000000", -- Overrides global.my_color
      --   },
      -- },

      -- highlights = {
      --   global = { -- Add or modify hl groups globally, theme specific hl groups take priority.
      --     modify_hl_groups = function(hl, c)
      --       hl.PluginColor4 = { fg = c.my_grey, bg = c.none }
      --     end,
      --     ["@String"] = { fg = "#ff00ff", bg = "NONE" },
      --   },
      --   astrodark = {
      --     -- first parameter is the highlight table and the second parameter is the color palette table
      --     modify_hl_groups = function(hl, c) -- modify_hl_groups function allows you to modify hl groups,
      --       hl.Comment.fg = c.my_color
      --       hl.Comment.italic = true
      --     end,
      --     ["@String"] = { fg = "#ff00ff", bg = "NONE" },
      --   },
      -- },
    },
    config = function(_, opts)
      vim.g.astrotheme_enable_italic = true
      require("astrotheme").setup(opts)

      vim.cmd.colorscheme("astrodark")
    end,
  },
}

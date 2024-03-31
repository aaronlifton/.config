return {
  -- https://github.com/marko-cerovac/material.nvim
  "marko-cerovac/material.nvim",
  -- enabled = false,
  lazy = false,
  name = "material",
  opts = {
    style = "darker", -- darker, lighter, oceanic, palenight, deep ocean
  },
  config = function(_, opts)
    -- local colors = require("material.colors")
    require("material").setup({
      contrast = {
        terminal = true, -- Enable contrast for the built-in terminal
        --   sidebars = false, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
        floating_windows = false, -- Enable contrast for floating windows
        cursor_line = false, -- Enable darker background for the cursor line
        -- non_current_windows = true, -- Enable contrasted background for non-current windows
        filetypes = { "markdown", "mdx" }, -- Specify which filetypes get the contrasted (darker) background
      },
      styles = { -- Give comments style such as bold, italic, underline etc.
        --   comments = { [[ italic = true ]] },
        --   strings = { [[ bold = true ]] },
        comments = { italic = true },
        keywords = { italic = true },
        types = { italic = true },
        --   variables = {},
        --   operators = {},
      },
      ----
      plugins = {
        -- Available plugins:
        "dap",
        "illuminate",
        "indent-blankline",
        "mini",
        "neotest",
        "noice",
        "nvim-cmp",
        "nvim-web-devicons",
        "telescope",
        "trouble",
        "which-key",
        -- Available plugins:
        "dashboard",
        -- "eyeliner",
        "fidget",
        -- "flash",
        "gitsigns",
        "harpoon",
        -- "hop",
        "illuminate",
        "indent-blankline",
        -- "lspsaga",
        "mini",
        -- "neogit",
        "neotest",
        "neo-tree",
        "neorg",
        "noice",
        "nvim-cmp",
        "nvim-navic",
        -- "nvim-tree",
        "nvim-web-devicons",
        -- "rainbow-delimiters",
        -- "sneak",
        "telescope",
        "trouble",
        "which-key",
        "nvim-notify",
      },
      --   disable = {
      --     colored_cursor = false, -- Disable the colored cursor
      --     borders = false, -- Disable borders between verticaly split windows
      --     background = false, -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
      --     term_colors = true, -- Prevent the theme from setting terminal colors
      --     eob_lines = false, -- Hide the end-of-buffer lines
      --   },
      --   -- high_visibility = {
      --   --   lighter = false, -- Enable higher contrast text for lighter style
      --   --   darker = true, -- Enable higher contrast text for darker style
      --   -- },
      --   -- lualine_style = "default", -- Lualine style ( can be 'stealth' or 'default' )
      custom_colors = function(colors)
        -- colors.editor.selection = "424557"
        -- colors.editor.highlight = "#323752"
        -- colors.editor.border = "#323752"
        colors.editor.border = "#8b8fa7"
      end,
      custom_highlights = {
        -- LineNr = { bg = "#FF0000" },
        -- Visual = { bg = "#424557", fg = "#0F111A", underline = false },
        -- Normal = { bg = "#000000" },
        -- SignColumn = { fg = "#0F111A", bg = "#000000" }, --colors.editor.bg }
        -- DiffAdd = { fg = "#0F111A", bg = "#000000" },
        GitSignsAdd = { fg = "#cbe699" }, --colors.editor.bg }
        GitSignsAddNr = { fg = "#cbe699" }, --colors.editor.bg }
        GitSignsAddLn = { fg = "#cbe699" }, --colors.editor.bg }
        GitSignsAddUntracked = { fg = "#cbe699" }, --colors.editor.bg }
        GitSignsAddUntrackedNr = { fg = "#cbe699" }, --colors.editor.bg }
        GitSignsAddUntrackedLn = { fg = "#cbe699" }, --colors.editor.bg }
        -- Dropbar
        -- DropBarMenuCurrentContext = { link = "PmenuSel" },
        -- DropBarMenuHoverEntry = { link = "Visual" },
        -- DropBarMenuHoverIcon = { reverse = true },
        -- DropBarMenuHoverSymbol = { bold = true },
        -- DropBarMenuNormalFloat = { link = "NormalFloat" },
        PmenuSbar = { link = "NormalNC" },
        PmenuThumb = { bg = "#cbe699" },
        -- DropBarMenuSbar = { link = "PmenuThumb" }, --{ guibg = "#323232" }, --- { link = "PmenuSbar" } ,
        -- DropBarMenuThumb = { link = "PmenuThumb" }, -- "#b0bec5"
        -- #07080d
        DropBarMenuSbar = { link = "NormalNC" },
        DropBarMenuThumb = { link = "NormalNC" },
        DropBarFzfMatch = { link = "NormalNC" },
        DropBarIconKindScope = { link = "NormalNC" },
        DropBarHover = { link = "NormalNC" },
        DropBarPreview = { link = "NormalNC" },
        DropBarIconKindArray = { link = "NormalNC" },
        DropBarMenuHoverSymbol = { link = "NormalNC" },
        DropBarMenuNormalFloat = { link = "NormalNC" },
        DropBarIconKindH1Marker = { link = "NormalNC" },
        DropBarIconKindH2Marker = { link = "NormalNC" },
        DropBarIconKindH3Marker = { link = "NormalNC" },
        DropBarIconKindH4Marker = { link = "NormalNC" },
        DropBarIconKindH5Marker = { link = "NormalNC" },
        DropBarIconKindH6Marker = { link = "NormalNC" },
        DropBarIconKindProperty = { link = "GrappleName" },
        DropBarIconKindNamespace = { link = "GrappleName" },
        DropBarIconKindSpecifier = { link = "GrappleName" },
        DropBarIconKindReference = { link = "GrappleName" },
        Search = { link = "Added" },
        IncSearch = { bg = "#cbe699" },
      },
      -- /END
    })

    vim.cmd("colorscheme material")
    -- setup mini.pick
    require("config/highlights")
  end,
}

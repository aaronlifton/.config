local cp = require("catppuccin.palettes").get_palette("macchiato") -- Import your favorite catppuccin colors

return {
  {
    "catppuccin/nvim",
    lazy = false,
    name = "catppuccin",
    opts = {
      styles = {
        comments = { "italic" },
      },
      background = {
        light = "latte",
        dark = "mocha",
      },
      term_colors = true,
      custom_highlights = function()
        return {
          -- FloatermBorder = { fg = cp.base },
          -- TelescopeMatching = { fg = cp.blue },
          -- TelescopeSelection = { fg = cp.text, bg = cp.surface0, bold = true },
          -- TelescopePromptPrefix = { bg = cp.surface0 },
          -- TelescopePromptNormal = { bg = cp.surface0 },
          -- TelescopeResultsNormal = { bg = cp.mantle },
          -- TelescopePreviewNormal = { bg = cp.mantle },
          -- TelescopePromptBorder = { bg = cp.surface0, fg = cp.surface0 },
          -- TelescopeResultsBorder = { bg = cp.mantle, fg = cp.mantle },
          -- TelescopePreviewBorder = { bg = cp.mantle, fg = cp.mantle },
          -- TelescopePromptTitle = { bg = cp.red, fg = cp.mantle },
          -- TelescopeResultsTitle = { fg = cp.mantle },
          -- TelescopePreviewTitle = { bg = cp.green, fg = cp.mantle },
          DiffChange = { fg = cp.blue, bg = cp.mantle },
          -- nvim-dots

          -- For base configs
          -- NormalFloat = { fg = cp.text, bg = cp.mantle },
          -- FloatBorder = {
          --   fg = cp.mantle,
          --   bg = cp.mantle,
          -- },
          -- CursorLineNr = { fg = cp.green },
          --
          -- -- For native lsp configs
          -- DiagnosticVirtualTextError = { bg = cp.none },
          -- DiagnosticVirtualTextWarn = { bg = cp.none },
          -- DiagnosticVirtualTextInfo = { bg = cp.none },
          -- DiagnosticVirtualTextHint = { bg = cp.none },
          -- LspInfoBorder = { link = "FloatBorder" },
          --
          -- -- For mason.nvim
          -- MasonNormal = { link = "NormalFloat" },
          --
          -- -- For indent-blankline
          -- IblIndent = { fg = cp.surface0 },
          -- IblScope = { fg = cp.surface2, style = { "bold" } },
          --
          -- -- For nvim-cmp and wilder.nvim
          Pmenu = { fg = cp.overlay2, bg = cp.base },
          PmenuBorder = { fg = cp.surface1, bg = cp.base },
          PmenuSel = { bg = cp.green, fg = cp.base },
          CmpItemAbbr = { fg = cp.overlay2 },
          CmpItemAbbrMatch = { fg = cp.blue, style = { "bold" } },
          CmpDoc = { link = "NormalFloat" },
          CmpDocBorder = {
            fg = cp.mantle,
            bg = cp.mantle,
          },

          -- For fidget
          FidgetTask = { bg = cp.none, fg = cp.surface2 },
          FidgetTitle = { fg = cp.blue, style = { "bold" } },
          --
          -- -- For nvim-notify
          -- NotifyBackground = { bg = cp.base },
          --
          -- -- For trouble.nvim
          -- TroubleNormal = { bg = cp.base },
          --
          -- -- For telescope.nvim
          -- TelescopeMatching = { fg = cp.lavender },
          -- TelescopeResultsDiffAdd = { fg = cp.green },
          -- TelescopeResultsDiffChange = { fg = cp.yellow },
          -- TelescopeResultsDiffDelete = { fg = cp.red },
          --
          -- -- For glance.nvim
          -- GlanceWinBarFilename = { fg = cp.subtext1, style = { "bold" } },
          -- GlanceWinBarFilepath = { fg = cp.subtext0, style = { "italic" } },
          -- GlanceWinBarTitle = { fg = cp.teal, style = { "bold" } },
          -- GlanceListCount = { fg = cp.lavender },
          -- GlanceListFilepath = { link = "Comment" },
          -- GlanceListFilename = { fg = cp.blue },
          -- GlanceListMatch = { fg = cp.lavender, style = { "bold" } },
          -- GlanceFoldIcon = { fg = cp.green },
          --
          -- -- For nvim-treehopper
          -- TSNodeKey = {
          --   fg = cp.peach,
          --   bg = cp.base,
          --   style = { "bold", "underline" },
          -- },
          --
          -- -- For treesitter
          -- ["@keyword.return"] = { fg = cp.pink, style = {} },
          -- ["@error.c"] = { fg = cp.none, style = {} },
          -- ["@error.cpp"] = { fg = cp.none, style = {} },
        }
      end,
      integrations = {
        aerial = true,
        alpha = true,
        flash = true,
        navic = { enabled = true, custom_bg = "lualine" },
        cmp = true,
        -- barbecue = {
        --   dim_dirname = true, -- directory name is dimmed by default
        --   bold_basename = true,
        --   dim_context = false,
        --   alt_background = false,
        -- },
        dap = true,
        dap_ui = true,
        dashboard = true,
        dropbar = { enabled = true, color_mode = true },
        -- flash = true,
        fidget = true,
        headlines = true,
        -- gitgutter = true,
        gitsigns = true,
        -- harpoon = false,
        illuminate = true,
        -- indent_blankline = { enabled = true },
        indent_blankline = {
          enabled = true,
          scope_color = "lavender", -- catppuccin color (eg. `lavender`) Default: text
          colored_indent_levels = false,
        },
        mason = true,
        markdown = true,
        mini = true,
        -- native_lsp = {
        --   enabled = true,
        --   underlines = {
        --     errors = { "undercurl" },
        --     hints = { "undercurl" },
        --     warnings = { "undercurl" },
        --     information = { "undercurl" },
        --   },
        -- },
        native_lsp = {
          enabled = true,
          virtual_text = {
            errors = { "italic" },
            hints = { "italic" },
            warnings = { "italic" },
            information = { "italic" },
          },
          underlines = {
            errors = { "underline" },
            hints = { "underline" },
            warnings = { "underline" },
            information = { "underline" },
          },
          inlay_hints = {
            background = true,
          },
        },
        leap = true,
        lsp_trouble = false,
        -- navic = { enabled = false, custom_bg = "lualine" },
        neotest = true,
        neogit = true,
        neotree = true,
        notify = true,
        noice = true,
        ufo = true,
        overseer = true,
        octo = true,
        -- rainbow_delimiters = true,
        semantic_tokens = true,
        telescope = {
          enabled = true,
          style = "nvchad",
        },
        -- symbols_outline = false,
        treesitter = true,
        treesitter_context = true,
        which_key = true,
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    opts = {
      highlights = require("catppuccin.groups.integrations.bufferline").get({
        styles = { "italic", "bold" },
        custom = {
          all = {
            fill = { bg = cp.mantle },
            background = { bg = cp.mantle },
          },
        },
      }),
    },
  },
  {
    "rasulomaroff/reactive.nvim",
    optional = true,
    opts = {
      load = { "catppuccin-macchiato-cursor", "catppuccin-macchiato-cursorline" },
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    options = {
      theme = "catppuccin",
    },
  },
}

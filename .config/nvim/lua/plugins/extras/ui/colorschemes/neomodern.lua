return {
  "cdmill/neomodern.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    -----MAIN OPTIONS-----
    --
    -- Can be one of: 'iceclimber' | 'gyokuro' | 'hojicha' | 'roseprime'
    theme = "iceclimber",
    -- Can be one of: 'light' | 'dark', or set via vim.o.background
    variant = "dark",
    -- Use an alternate, darker bg
    alt_bg = false,
    -- If true, docstrings will be highlighted like strings, otherwise they will be
    -- highlighted like comments. Note, behavior is dependent on the language server.
    colored_docstrings = true,
    -- If true, highlights the {sign,fold} column the same as cursorline
    cursorline_gutter = true,
    -- If true, highlights the gutter darker than the bg
    dark_gutter = false,
    -- if true favor treesitter highlights over semantic highlights
    favor_treesitter_hl = false,
    -- Don't set background of floating windows. Recommended for when using floating
    -- windows with borders.
    plain_float = false,
    -- Show the end-of-buffer character
    show_eob = true,
    -- If true, enable the vim terminal colors
    term_colors = true,
    -- Keymap (in normal mode) to toggle between light and dark variants.
    toggle_variant_key = nil,
    -- Don't set background
    transparent = false,

    -----DIAGNOSTICS and CODE STYLE-----
    --
    diagnostics = {
      darker = true, -- Darker colors for diagnostic
      undercurl = true, -- Use undercurl for diagnostics
      background = true, -- Use background color for virtual text
    },
    -- The following table accepts values the same as the `gui` option for normal
    -- highlights. For example, `bold`, `italic`, `underline`, `none`.
    code_style = {
      comments = "italic",
      conditionals = "none",
      functions = "none",
      keywords = "none",
      headings = "bold", -- Markdown headings
      operators = "none",
      keyword_return = "none",
      strings = "none",
      variables = "none",
    },

    -----PLUGINS-----
    --
    -- The following options allow for more control over some plugin appearances.
    plugin = {
      lualine = {
        -- Bold lualine_a sections
        bold = true,
        -- Don't set section/component backgrounds. Recommended to not set
        -- section/component separators.
        plain = false,
      },
      cmp = { -- works for nvim.cmp and blink.nvim
        -- Don't highlight lsp-kind items. Only the current selection will be highlighted.
        plain = false,
        -- Reverse lsp-kind items' highlights in blink/cmp menu.
        reverse = false,
      },
    },

    -- CUSTOM HIGHLIGHTS --
    --
    -- Override default colors
    colors = {},
    -- Override highlight groups
    highlights = {
      -- MiniPickMatchCurrent = { link = "Visual" },
    },
  },
  config = function(_, opts)
    local theme = opts.theme
    local C = require("neomodern.palette").get(theme, "dark")
    -- local C = {
    --   alt = "#abbceb",
    --   alt_bg = "#111113",
    --   bg = "#171719",
    --   colormap = {
    --     c00 = "#555568",
    --     c01 = "#e67e80",
    --     c02 = "#465D4B",
    --     c03 = "#ad9368",
    --     c04 = "#86a3f0",
    --     c05 = "#6b6b99",
    --     c06 = "#44676C",
    --     c07 = "#79797E",
    --     c08 = "#555568",
    --     c09 = "#cc93b8",
    --     c0A = "#658c6d",
    --     c0B = "#cfa18c",
    --     c0C = "#abbceb",
    --     c0D = "#a8a6de",
    --     c0E = "#629da3",
    --     c0F = "#bbbac1",
    --   },
    --   comment = "#555568",
    --   constant = "#86a3f0",
    --   diag_blue = "#778fd1",
    --   diag_green = "#658c6d",
    --   diag_red = "#e67e80",
    --   diag_yellow = "#ad9368",
    --   fg = "#bbbac1",
    --   func = "#cc93b8",
    --   keyword = "#8a88db",
    --   line = "#1d1d22",
    --   number = "#cfa18c",
    --   operator = "#9b99a3",
    --   property = "#629da3",
    --   string = "#6b6b99",
    --   type = "#a8a6de",
    --   visual = "#2a2a31",
    -- }
    -- vim.list_extend(opts.highlights, {
    --   MiniPickBorder = { link = "FloatBorder" },
    --   MiniPickBorderBusy = { link = "DiagnosticFloatingWarn" },
    --   MiniPickBorderText = {
    --     fg = C.diag_yellow,
    --     bg = C.bg,
    --   },
    --   MiniPickIconDirectory = { link = "Directory" },
    --   MiniPickIconFile = { link = "MiniPickNormal" },
    --   MiniPickHeader = { link = "DiagnosticFloatingHint" },
    --   MiniPickMatchCurrent = {
    --     fg = C.type,
    --     bg = C.alt,
    --     style = { "bold" },
    --   },
    --   MiniPickMatchMarked = { link = "Visual" },
    --   MiniPickMatchRanges = { link = "DiagnosticFloatingHint" },
    --   MiniPickNormal = { link = "NormalFloat" },
    --   MiniPickPreviewLine = { link = "CursorLine" },
    --   MiniPickPreviewRegion = { link = "IncSearch" },
    --   -- Thank you connnor.1
    --   MiniPickPrompt = { fg = C.text, bg = C.alt_bg },
    --   MiniPickPromptCaret = {
    --     fg = C.flamingo,
    --     bg = C.alt_bg,
    --   },
    --   MiniPickPromptPrefix = {
    --     fg = C.flamingo,
    --     bg = C.alt_bg,
    --   },
    -- })
    require("neomodern").setup(opts)
    -- Convenience function that simply calls `:colorscheme <theme>` with the theme
    -- specified in your config.

    -- Disabled below
    -- require("neomodern").load()

    -- vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { link = "Visual" })
    -- vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { fg = C.func, bg = C.alt_bg })
    -- vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { bg = Util.colors.lighten("#111113", 0.6, "#bbbac1") })
    vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { bg = "#555559" })

    -- local trouble_hls = {
    --   TroubleCode = { fg = t.magenta },
    --   TroubleCount = { bg = t.bg_highlight, bold = true },
    --   TroubleDirectory = { fg = t.grey, bold = true },
    --   TroubleFilename = { fg = t.cyan },
    --   TroubleIconArray = { fg = t.pink },
    --   TroubleIconBoolean = { link = "Boolean" },
    --   TroubleIconConstant = { link = "Constant" },
    --   TroubleIconDirectory = { fg = t.blue },
    --   TroubleIconEvent = { link = "Special" },
    --   TroubleIconField = { link = "Boolean" },
    --   TroubleIconFile = { link = "Normal" },
    --   TroubleIconFunction = { link = "@function" },
    --   TroubleIndent = { link = "LineNr" },
    --   TroubleIndentFoldClosed = { link = "CursorLineNr" },
    --   TroublePos = { link = "LineNr" },
    --   TroublePreview = { link = "Visual" },
    --   TroubleSource = { link = "Comment" },
    -- }

    -- Call this once to generate the extra themes in the `extras/` folder.
    -- require("neomodern.extras").setup()

    -- local function get_fzf_opts()
    --   local path = vim.fs.joinpath(
    --     vim.fs.abspath("~/.local/share/nvim/lazy/neomodern.nvim"),
    --     "extras",
    --     "fzf",
    --     string.format("%s.zsh", theme)
    --   )
    --   local fd = vim.uv.fs_open(path, "r", 438)
    --   if not fd then return nil end
    --
    --   local stat = assert(vim.uv.fs_fstat(fd))
    --   if not (stat.type == "file" or stat.type == "link") then return end
    --
    --   local function extract_fzf_opts(str, index)
    --     local opts = {}
    --     for opt in str:gmatch('export FZF_DEFAULT_OPTS="([^"]*)"') do
    --       -- Remove the $FZF_DEFAULT_OPTS\n prefix
    --       local cleaned = opt:gsub("%$FZF_DEFAULT_OPTS\\n", "")
    --       table.insert(opts, cleaned)
    --     end
    --     return opts[index]:gsub("\n", " ")
    --   end
    --   vim.uv.fs_read(fd, stat.size, 0, function(err, data)
    --     if err then vim.uv.fs_close(fd) end
    --     vim.uv.fs_close(fd)
    --     vim.schedule_wrap(function()
    --       local fzf_opts1 = extract_fzf_opts(data, 1)
    --       local fzf_opts2 = extract_fzf_opts(data, 2)
    --
    --       vim.api.nvim_echo({ { vim.inspect(fzf_opts1), "Normal" }, { vim.inspect(fzf_opts2), "Normal" } }, true, {})
    --     end)
    --   end)
    -- end
  end,
  init = function()
    -- vim.env.YAZI_FZF_OPTS =
    --   "--color=fg:#555568,bg:#171719,hl:#a8a6de,gutter:#171719 --color=fg+:#629da3,bg+:#1d1d22,hl+:#a8a6de --color=info:#abbceb,prompt:#a8a6de,pointer:#629da3 --color=marker:#8a88db,spinner:#8a88db,header:#8a88db"
    vim.env.YAZI_FZF_OPTS =
      "--color=fg:#bbbac1,bg:#111113,hl:#a8a6de,gutter:#111113 --color=fg+:#629da3,bg+:#1d1d22,hl+:#a8a6de --color=info:#555568,prompt:#a8a6de,pointer:#629da3 --color=marker:#8a88db,spinner:#8a88db,header:#8a88db"
  end,
}

return {
  "dgox16/oldworld.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    terminal_colors = true, -- enable terminal colors
    variant = "oled", -- default, oled, cooler
    styles = { -- You can pass the style using the format: style = true
      comments = {}, -- style for comments
      keywords = {}, -- style for keywords
      identifiers = {}, -- style for identifiers
      functions = {}, -- style for functions
      variables = {}, -- style for variables
      booleans = { italic = true, bold = true },
    },
    -- highlight_overrides = {
    --   Comment = { bg = "#ff0000" },
    -- },
    integrations = { -- You can disable/enable integrations
      alpha = false,
      cmp = true,
      flash = false,
      gitsigns = false,
      hop = false,
      indent_blankline = false,
      lazy = true,
      lsp = true,
      markdown = true,
      mason = true,
      navic = false,
      neo_tree = true,
      neogit = true,
      neorg = true,
      noice = true,
      notify = true,
      rainbow_delimiters = false,
      telescope = true,
      treesitter = true,
    },
  },
}

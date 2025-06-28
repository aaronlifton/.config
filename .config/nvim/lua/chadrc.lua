local M = {}

M.base46 = {
  -- theme = 'catppuccin',
  -- theme = "vscode_dark",
  -- theme = "material-deep-ocean",
  theme = "ayu_dark",
  -- hl_override = {
  --   LineNr = { fg = "#256173" },
  --   CursorLineNr = { fg = "#569CD6", bold = true },
  -- },
}

M.ui = {
  statusline = {
    theme = "default",
    separator_style = "arrow",
  },

  cmp = {
    icons_left = true,
  },
}

return M

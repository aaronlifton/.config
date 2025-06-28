local util = require("nvim-base46.util")

local M = {}

---@param colors base46.Colors
M.setup = function(colors)
  local c = colors
  local hi = util.highlight

  require("nvim-base46.highlights.base").setup(c, hi)
  require("nvim-base46.highlights.syntax").setup(c, hi)
  require("nvim-base46.highlights.lsp").setup(c, hi)
  require("nvim-base46.highlights.treesitter").setup(c, hi)

  -- Plugins
  require("nvim-base46.highlights.lazy").setup(c, hi)
  require("nvim-base46.highlights.cmp").setup(c, hi)
  require("nvim-base46.highlights.mason").setup(c, hi)
  require("nvim-base46.highlights.nvimtree").setup(c, hi)
  require("nvim-base46.highlights.telescope").setup(c, hi)
  require("nvim-base46.highlights.git").setup(c, hi)
  require("nvim-base46.highlights.devicons").setup(c, hi)
end

---@param colors base46.Colors
M.setup_terminal = function(colors)
  vim.g.terminal_color_0 = colors.base00
  vim.g.terminal_color_1 = colors.base08
  vim.g.terminal_color_2 = colors.base0B
  vim.g.terminal_color_3 = colors.base0A
  vim.g.terminal_color_4 = colors.base0D
  vim.g.terminal_color_5 = colors.base0E
  vim.g.terminal_color_6 = colors.base0C
  vim.g.terminal_color_7 = colors.base05
  vim.g.terminal_color_8 = colors.base03
  vim.g.terminal_color_9 = colors.base08
  vim.g.terminal_color_10 = colors.base0B
  vim.g.terminal_color_11 = colors.base0A
  vim.g.terminal_color_12 = colors.base0D
  vim.g.terminal_color_13 = colors.base0E
  vim.g.terminal_color_14 = colors.base0C
  vim.g.terminal_color_15 = colors.base07
end

return M

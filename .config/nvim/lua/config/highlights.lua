local colors = require("material.colors")
local e = colors.editor
local m = colors.main
local b = colors.backgrounds
local g = colors.git
vim.api.nvim_set_hl(0, "MiniPickBorder", { fg = e.border, bg = e.bg })
vim.api.nvim_set_hl(0, "MiniPickBorderBusy", { fg = e.border, bg = e.bg })
vim.api.nvim_set_hl(0, "MiniPickBorderText", { fg = e.fg, bg = e.bg })
vim.api.nvim_set_hl(0, "MiniPickIconDirectory", { fg = e.fg, bg = e.bg_alt })
vim.api.nvim_set_hl(0, "MiniPickIconFile", { fg = e.fg, bg = e.bg })
vim.api.nvim_set_hl(0, "MiniPickHeader", { fg = e.fg, bg = e.bg })
vim.api.nvim_set_hl(0, "MiniPickMatchCurrent", { fg = g.modified, bg = b.cursor_line })
vim.api.nvim_set_hl(0, "MiniPickMatchMarked", { fg = m.green, bg = m.darkred })
vim.api.nvim_set_hl(0, "MiniPickMatchRanges", { fg = m.orange, bg = e.bg })
vim.api.nvim_set_hl(0, "MiniPickNormal", { fg = e.fg, bg = b.floating_windows })
vim.api.nvim_set_hl(0, "MiniPickPreviewLine", { fg = b.cursor_line, bg = m.darkyellow })
vim.api.nvim_set_hl(0, "MiniPickPreviewRegion", { fg = e.fg, bg = e.highlight })
-- vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })
-- :=require("material.colors")
-- {
--   backgrounds = {
--     cursor_line = "#323232",
--     floating_windows = "#212121",
--     non_current_windows = "#212121",
--     sidebars = "#212121",
--     terminal = "#1A1A1A"
--   },
--   editor = {
--     accent = "#FF9800",
--     active = "#323232",
--     bg = "#212121",
--     bg_alt = "#1A1A1A",
--     border = "#343434",
--     contrast = "#1A1A1A",
--     cursor = "#FFCC00",
--     disabled = "#474747",
--     fg = "#B0BEC5",
--     fg_dark = "#8C8B8B",
--     highlight = "#3F3F3F",
--     line_numbers = "#424242",
--     link = "#80CBC4",
--     selection = "#404040",
--     title = "#EEFFFF",
--     vsplit = "#343434"
--   },
--   git = {
--     added = "#C3E88D",
--     modified = "#82AAFF",
--     removed = "#F07178"
--   },
--   lsp = {
--     error = "#FF5370",
--     hint = "#C792EA",
--     info = "#B0C9FF",
--     warning = "#FFCB6B"
--   },
--   main = {
--     black = "#000000",
--     blue = "#82AAFF",
--     cyan = "#89DDFF",
--     darkblue = "#6E98EB",
--     darkcyan = "#71C6E7",
--     darkgreen = "#ABCF76",
--     darkorange = "#E2795B",
--     darkpurple = "#B480D6",
--     darkred = "#DC6068",
--     darkyellow = "#E6B455",
--     gray = "#717CB4",
--     green = "#C3E88D",
--     orange = "#F78C6C",
--     paleblue = "#B0C9FF",
--     purple = "#C792EA",
--     red = "#F07178",
--     white = "#EEFFFF",
--     yellow = "#FFCB6B"
--   },
--   syntax = {
--     comments = "#515151",
--     field = "#B0BEC5",
--     fn = "#82AAFF",
--     keyword = "#C792EA",
--     operator = "#89DDFF",
--     string = "#C3E88D",
--     type = "#C792EA",
--     value = "#F78C6C",
--     variable = "#B0BEC5"
--   }
-- }
--

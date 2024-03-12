local M = {}
local wezterm = require("wezterm")
-- require toml from colors folder
-- get absolute path to file
local serde = wezterm.serde
local color_palettes = {
	"catppuccin-mocha",
	"catppuccin-macchiato",
	"DoomOne",
}

for _, v in ipairs(color_palettes) do
	local file = wezterm.home_dir .. "/.config/wezterm/colors/" .. v .. ".toml"
	local fd = io.input(file)
	local colors = serde.toml_decode(fd:read("a"))

	M[v] = colors
end
-- local background = "#0a0a00"
-- local background = "#0c0e14"

-- M.catpuccin_mocha = {
-- 	foreground = "#cdd6f4",
-- 	background = "#1e1e2e",
-- 	cursor_bg = "#f5e0dc",
-- 	cursor_border = "#f5e0dc",
-- 	cursor_fg = "#cdd6f4",
-- 	selection_bg = "#585b70",
-- 	selection_fg = "#cdd6f4",
-- 	ansi = { "#45475a", "#f38ba8", "#a6e3a1", "#f9e2af", "#89b4fa", "#f5c2e7", "#94e2d5", "#bac2de" },
-- 	brights = { "#585b70", "#f38ba8", "#a6e3a1", "#f9e2af", "#89b4fa", "#f5c2e7", "#94e2d5", "#a6adc8" },
-- }
--
-- M.catppuccin_macchiato = {
-- 	foreground = "#cad3f5",
-- 	background = "#24273a",
-- 	cursor_bg = "#f4dbd6",
-- 	cursor_border = "#f4dbd6",
-- 	cursor_fg = "#cad3f5",
-- 	selection_bg = "#5b6078",
-- 	selection_fg = "#cad3f5",
-- 	ansi = { "#494d64", "#ed8796", "#a6da95", "#eed49f", "#8aadf4", "#f5bde6", "#8bd5ca", "#b8c0e0" },
-- 	brights = { "#5b6078", "#ed8796", "#a6da95", "#eed49f", "#8aadf4", "#f5bde6", "#8bd5ca", "#a5adcb" },
-- }
--
M.doomone = {
	foreground = "#bbc2cf",
	background = "#282c34",
	cursor_bg = "#51afef",
	cursor_border = "#51afef",
	cursor_fg = "#1b1b1b",
	selection_bg = "#42444b",
	selection_bg_brighter = "#42444b",
	selection_fg = "#bbc2cf",
	ansi = { "#000000", "#ff6c6b", "#98be65", "#ecbe7b", "#a9a1e1", "#c678dd", "#51afef", "#bbc2cf" },
	brights = { "#ff6655", "#99bb66", "#ecbe7b", "#a9a1e1", "#c678dd", "#51afef", "#bfbfbf" },
} --

M.colors = M.doomone

M.colorscheme = function(appearance)
	if appearance:find("Dark") then
		return "Catppuccin Mocha"
	else
		return "Catppuccin Latte"
	end
end

return M

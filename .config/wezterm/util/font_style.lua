local wezterm = require("wezterm")
local M = {}

M.set_config = function(config, name)
	config.freetype_render_target = "Normal" -- Normal, Light, HorizontalLcd - https://wezfurlong.org/wezterm/config/lua/config/freetype_render_target.html
	config.freetype_load_target = "Normal" -- Normal, Light, Mono, HorizontalLcd - https://wezfurlong.org/wezterm/config/lua/config/freetype_load_target.html
	config.freetype_load_flags = "DEFAULT" -- DEFAULT, NO_HINTING, NO_BITMAP, FORCE_AUTOHINT, MONOCHROME, NO_AUTOHINT - https://wezfurlong.org/wezterm/config/lua/config/freetype_load_flags.html
	-- config.cell_width = 0.9

	-- Font 1 (Hack, 1.1, 15, 1)
	if name == "Hack" then
		config.font = wezterm.font("Hack Nerd Font Mono")
		config.line_height = 1.1
		config.font_size = 15.0
	end
	if name == "ProFontIIx" then -- ProFontIIx Nerd Font Mono
		config.freetype_render_target = "Light" -- Normal, Light, HorizontalLcd - https://wezfurlong.org/wezterm/config/lua/config/freetype_render_target.html
		config.freetype_load_target = "Mono" -- Normal, Light, Mono, HorizontalLcd - https://wezfurlong.org/wezterm/config/lua/config/freetype_load_target.html
		config.freetype_load_flags = "DEFAULT" -- DEFAULT, NO_HINTING, NO_BITMAP, FORCE_AUTOHINT, MONOCHROME, NO_AUTOHINT - https://wezfurlong.org/wezterm/config/lua/config/freetype_load_flags.html
		config.line_height = 1.1
		config.font_size = 15.0
		config.font = wezterm.font("ProFontIIx Nerd Font Mono")
	end
	if name == "DaddyTimeMono" then
		config.line_height = 1
		config.font_size = 15.0
		config.font = wezterm.font({
			family = "DaddyTimeMono Nerd Font Mono",
			weight = "Regular",
		})
	end
	if name == "MonoLisa" then
		config.line_height = 1.1
		config.cell_width = 0.95
		config.font_size = 16.0
		config.font = wezterm.font({
			family = "MonoLisa Nerd Font Mono",
			weight = "Regular",
			-- weight = "Light",
		})
	end
	if name == "Berkeley" then
		config.font_size = 16.0
		config.font = wezterm.font("Berkeley Mono Trial")
	end
	if name == "Geist" then
		-- config.line_height = 1.1
		-- config.cell_width = 0.95
		config.font_size = 16.0
		config.font = wezterm.font({
			family = "Geist Nerd Font",
			weight = "Regular",
		})
		config.font = wezterm.font("GeistMono Nerd Font Mono")
	end
	if name == "SFMono" then
		config.font_size = 16.0
		config.cell_width = 0.95
		config.font = wezterm.font("Liga SFMono Nerd Font Mono")
	end
	if name == "Comic" then
		config.font_size = 16.0
		config.cell_width = 0.95
		config.font = wezterm.font("Liga Comic Mono")
	end
end

return M

-- Style 1
-- font = wezterm.font("ProFontIIx Nerd Font Mono"), -- Iosevka, Hack Nerd Font Mono
-- font_size = 14.0,
-- line_height = 1.1,
-- freetype_render_target = "HorizontalLcd", -- Normal, Light, HorizontalLcd - https://wezfurlong.org/wezterm/config/lua/config/freetype_render_target.html
-- freetype_load_target = "HorizontalLcd", -- Normal, Light, Mono, HorizontalLcd - https://wezfurlong.org/wezterm/config/lua/config/freetype_load_target.html
-- freetype_load_flags = "DEFAULT", -- DEFAULT, NO_HINTING, NO_BITMAP, FORCE_AUTOHINT, MONOCHROME, NO_AUTOHINT - https://wezfurlong.org/wezterm/config/lua/config/freetype_load_flags.html
-- freetype_load_flags = "NO_HINTING", -- NO_DEFAULT, NO_HINTING, NO_BITMAP, FORCE_AUTOHINT, MONOCHROME, NO_AUTOHINT - https://wezfurlong.org/wezterm/config/lua/config/freetype_load_flags.html

-- Style 1
-- font = wezterm.font({
-- 	family = "ProFontIIx Nerd Font Mono", -- Iosevka, Hack Nerd Font Mono
-- 	weight = "Light", -- "Light",
-- }),
-- font_size = 13.0,
-- line_height = 1.1,
-- -- freetype_render_target = "HorizontalLcd", -- Normal, Light, HorizontalLcd - https://wezfurlong.org/wezterm/config/lua/config/freetype_render_target.html
-- freetype_load_target = "HorizontalLcd", -- Normal, Light, Mono, HorizontalLcd - https://wezfurlong.org/wezterm/config/lua/config/freetype_load_target.html
-- freetype_load_flags = "DEFAULT", -- DEFAULT, NO_HINTING, NO_BITMAP, FORCE_AUTOHINT, MONOCHROME, NO_AUTOHINT - https://wezfurlong.org/wezterm/config/lua/config/freetype_load_flags.html
-- freetype_load_flags = "NO_HINTING", -- NO_DEFAULT, NO_HINTING, NO_BITMAP, FORCE_AUTOHINT, MONOCHROME, NO_AUTOHINT - https://wezfurlong.org/wezterm/config/lua/config/freetype_load_flags.html
-- cell_width = 0.9,

-- Style 3
-- -- Monaspace (TODO: try them out)
-- font = wezterm.font({
-- 	-- Argon, Krypton, Neon, Radon, Xenon
-- 	family = "Monaspace Argon",
-- 	-- Bold BoldItalic ExtraBold ExtraBoldItalic ExtraLight ExtraLightItalic Italic Light LightItalic Medium MediumItalic Regular SemiBold SemiBoldItalic SemiWideBold SemiWideBoldItalic SemiWideExtraBold SemiWideExtraBoldItalic SemiWideExtraLight SemiWideExtraLightItalic SemiWideItalic SemiWideLight SemiWideLightItalic SemiWideMedium SemiWideMediumItalic SemiWideRegular SemiWideSemiBold SemiWideSemiBoldItalic WideBold WideBoldItalic WideExtraBold WideExtraBoldItalic WideExtraLight WideExtraLightItalic WideItalic WideLight WideLightItalic WideMedium WideMediumItalic WideRegular WideSemiBold WideSemiBoldItalic
-- 	weight = "Regular", -- "Light",
-- 	-- weight = "Light", -- "Light",
-- 	-- no calt for no "texture healing"
-- 	harfbuzz_features = {
-- 		"calt",
-- 		"liga",
-- 		"dlig",
-- 		"ss01",
-- 		"ss02",
-- 		"ss03",
-- 		"ss04",
-- 		"ss05",
-- 		"ss06",
-- 		"ss07",
-- 		"ss08",
-- 	},
-- }),

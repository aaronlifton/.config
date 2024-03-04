local wezterm = require("wezterm")

local tighter_bounding_box = {
	line_height = 1.1,
	cell_width = 0.9,
}
local normal_bounding_box = {
	line_height = 1.0,
	cell_width = 1.1,
}
local fonts = {
	hack = {
		font = wezterm.font("Hack Nerd Font Mono"),
	},
	sfmono_nerd_font = {
		-- font = wezterm.font("SF Mono Nerd Font"),
		font = wezterm.font({
			family = "Liga SFMono Nerd Font Mono",
			weight = "Regular",
			harfbuzz_features = {
				"calt",
				"liga",
				-- "dlig",
				"ss01",
				"ss02",
				"ss03",
				"ss04",
				"ss05",
				"ss06",
				"ss07",
				"ss08",
			},
		}),
		font_size = 16,
		-- table.unpack(tighter_bounding_box)
		table.unpack(normal_bounding_box),
	},
	monaspace = {
		font = wezterm.font({
			-- Argon, Krypton, Neon, Radon, Xenon
			family = "Monaspace Argon",
			-- Bold BoldItalic ExtraBold ExtraBoldItalic ExtraLight ExtraLightItalic Italic Light LightItalic Medium MediumItalic Regular SemiBold SemiBoldItalic SemiWideBold SemiWideBoldItalic SemiWideExtraBold SemiWideExtraBoldItalic SemiWideExtraLight SemiWideExtraLightItalic SemiWideItalic SemiWideLight SemiWideLightItalic SemiWideMedium SemiWideMediumItalic SemiWideRegular SemiWideSemiBold SemiWideSemiBoldItalic WideBold WideBoldItalic WideExtraBold WideExtraBoldItalic WideExtraLight WideExtraLightItalic WideItalic WideLight WideLightItalic WideMedium WideMediumItalic WideRegular WideSemiBold WideSemiBoldItalic
			weight = "Regular", -- "Light",
			-- weight = "Light", -- "Light",
			-- no calt for no "texture healing"
			harfbuzz_features = {
				"calt",
				"liga",
				"dlig",
				"ss01",
				"ss02",
				"ss03",
				"ss04",
				"ss05",
				"ss06",
				"ss07",
				"ss08",
			},
		}),
	},
	profont = {
		font = wezterm.font({
			family = "ProFontIIx Nerd Font Mono", -- Iosevka, Hack Nerd Font Mono
			weight = "Light", -- "Light",
		}),
			font_size = 13.0,
			-- freetype_render_target = "HorizontalLcd", -- Normal, Light, HorizontalLcd - https://wezfurlong.org/wezterm/config/lua/config/freetype_render_target.html
			freetype_load_target = "HorizontalLcd", -- Normal, Light, Mono, HorizontalLcd - https://wezfurlong.org/wezterm/config/lua/config/freetype_load_target.html
			freetype_load_flags = "DEFAULT", -- DEFAULT, NO_HINTING, NO_BITMAP, FORCE_AUTOHINT, MONOCHROME, NO_AUTOHINT - https://wezfurlong.org/wezterm/config/lua/config/freetype_load_flags.html
			freetype_load_flags = "NO_HINTING", -- NO_DEFAULT, NO_HINTING, NO_BITMAP, FORCE_AUTOHINT, MONOCHROME, NO_AUTOHINT - https://wezfurlong.org/wezterm/config/lua/config/freetype_load_flags.html
			table.unpack(tighter_bounding_box),
	},
	profont2 = {
		font = wezterm.font("ProFontIIx Nerd Font Mono"), -- Iosevka, Hack Nerd Font Mono
			font_size = 14.0,
			line_height = 1.1,
			freetype_render_target = "HorizontalLcd", -- Normal, Light, HorizontalLcd - https://wezfurlong.org/wezterm/config/lua/config/freetype_render_target.html
			freetype_load_target = "HorizontalLcd", -- Normal, Light, Mono, HorizontalLcd - https://wezfurlong.org/wezterm/config/lua/config/freetype_load_target.html
			freetype_load_flags = "DEFAULT", -- DEFAULT, NO_HINTING, NO_BITMAP, FORCE_AUTOHINT, MONOCHROME, NO_AUTOHINT - https://wezfurlong.org/wezterm/config/lua/config/freetype_load_flags.html
			freetype_load_flags = "NO_HINTING", -- NO_DEFAULT, NO_HINTING, NO_BITMAP, FORCE_AUTOHINT, MONOCHROME, NO_AUTOHINT - https://wezfurlong.org/wezterm/config/lua/config/freetype_load_flags.html
	},
	liga_sfmono_nerd_font = {
		font = wezterm.font({
			family = "SF Mono Nerd Font",
			weight = "Regular",
			harfbuzz_features = {
				"calt",
				"liga",
				"dlig",
				"ss01",
				"ss02",
				"ss03",
				"ss04",
				"ss05",
				"ss06",
				"ss07",
				"ss08",
			},
		}),
	},
	playful_fonts = {
		comic_mono = {
			font = wezterm.font("ComicMono NF"),
		},
		comic_shanns_mono = {
			font = wezterm.font("ComicShannsMono Nerd Font Mono"),
		},
		daddy_time = {
			font = wezterm.font("DaddyTimeMono Nerd Font Mono"),
		},
	},
}

local tab_icons = {
	bash = "",
	caffeinate = "",
	brew = "",
	fish = "",
	git = "",
	lazygit = "",
	pm2 = "",
	["pm2 log"] = "",
	node = "",
	npm = "",
	nvim = "",
	ssh = "",
	tmux = "",
	wezterm = "",
}

local process_icons = {
	["docker"] = wezterm.nerdfonts.linux_docker,
	["docker-compose"] = wezterm.nerdfonts.linux_docker,
	["psql"] = "󱤢",
	["usql"] = "󱤢",
	["kuberlr"] = wezterm.nerdfonts.linux_docker,
	["ssh"] = wezterm.nerdfonts.fa_exchange,
	["ssh-add"] = wezterm.nerdfonts.fa_exchange,
	["kubectl"] = wezterm.nerdfonts.linux_docker,
	["stern"] = wezterm.nerdfonts.linux_docker,
	["nvim"] = wezterm.nerdfonts.custom_vim,
	["make"] = wezterm.nerdfonts.seti_makefile,
	["vim"] = wezterm.nerdfonts.dev_vim,
	["node"] = wezterm.nerdfonts.mdi_hexagon,
	["go"] = wezterm.nerdfonts.seti_go,
	["zsh"] = wezterm.nerdfonts.dev_terminal,
	["bash"] = wezterm.nerdfonts.cod_terminal_bash,
	["btm"] = wezterm.nerdfonts.mdi_chart_donut_variant,
	["htop"] = wezterm.nerdfonts.mdi_chart_donut_variant,
	["cargo"] = wezterm.nerdfonts.dev_rust,
	["sudo"] = wezterm.nerdfonts.fa_hashtag,
	["lazydocker"] = wezterm.nerdfonts.linux_docker,
	["git"] = wezterm.nerdfonts.dev_git,
	["lua"] = wezterm.nerdfonts.seti_lua,
	["wget"] = wezterm.nerdfonts.mdi_arrow_down_box,
	["curl"] = wezterm.nerdfonts.mdi_flattr,
	["gh"] = wezterm.nerdfonts.dev_github_badge,
	["ruby"] = wezterm.nerdfonts.cod_ruby,
}

return {
	icons = {
		tab = tab_icons,
		process = process_icons,
	},
	-- current = fonts.sfmono_nerd_font,
	-- current = fonts.monaspace,
	current = fonts.hack,
	table.unpack(fonts),
}

C = {
	catppuccin_palette = {
		rosewater = "#f4dbd6",
		flamingo = "#f0c6c6",
		pink = "#f5bde6",
		mauve = "#c6a0f6",
		red = "#ed8796",
		maroon = "#ee99a0",
		peach = "#f5a97f",
		yellow = "#eed49f",
		green = "#a6da95",
		teal = "#8bd5ca",
		sky = "#91d7e3",
		sapphire = "#7dc4e4",
		blue = "#8aadf4",
		lavender = "#b7bdf8",
		text = "#cad3f5",
		subtext1 = "#b8c0e0",
		subtext0 = "#a5adcb",
		overlay2 = "#939ab7",
		overlay1 = "#8087a2",
		overlay0 = "#6e738d",
		surface2 = "#5b6078",
		surface1 = "#494d64",
		surface0 = "#363a4f",
		base = "#24273a",
		mantle = "#1e2030",
		crust = "#181926",
	},
	tokyonight_moon = {
		bg = "#222436",
		fg = "#c8d3f5",
		red = "#ff757f",
		red1 = "#c53b53",
		green = "#c3e88d",
		green1 = "#4fd6be",
		green2 = "#41a6b5",
		yellow = "#ffc777",
		blue = "#82aaff",
		blue0 = "#3e68d7",
		blue1 = "#65bcff",
		blue2 = "#0db9d7",
		blue5 = "#89ddff",
		blue6 = "#b4f9f8",
		blue7 = "#394b70",
		magenta = "#c099ff",
		magenta2 = "#ff007c",
		cyan = "#86e1fc",
		white = "#a9b1d6",
		subtext1 = "#3b4261",
		subtext0 = "#2e3340",
		overlay2 = "#232634",
		overlay1 = "#1f2335",
		overlay0 = "#1c1f2b",
		surface2 = "#191a21",
		surface1 = "#16161e",
		surface0 = "#11111b",
		base = "#0d0d14",
		mantle = "#09090f",
		crust = "#05050a",
		bg_dark = "#1e2030",
		bg_dark1 = "#191B29",
		bg_highlight = "#2f334d",
		comment = "#636da6",
		dark3 = "#545c7e",
		dark5 = "#737aa2",
		fg_dark = "#828bb8",
		fg_gutter = "#3b4261",
		orange = "#ff966c",
		purple = "#fca7ea",
		teal = "#4fd6be",
		terminal_black = "#444a73",
		git = {
			add = "#b8db87",
			change = "#7ca1f2",
			delete = "#e26a75",
		},
	},
}

-- Plugins
require("zoxide"):setup({
	update_db = false,
})

require("session"):setup({
	sync_yanked = true,
})

local search_jump_theme = {
	catppuccin = {
		unmatch_fg = C.catppuccin_palette.overlay0,
		match_str_fg = C.catppuccin_palette.peach,
		match_str_bg = C.catppuccin_palette.base,
		first_match_str_fg = C.catppuccin_palette.lavender,
		first_match_str_bg = C.catppuccin_palette.base,
		label_fg = C.catppuccin_palette.green,
		label_bg = C.catppuccin_palette.base,
	},
	tokyonight_moon = {
		unmatch_fg = C.tokyonight_moon.dark3,
		match_str_fg = C.tokyonight_moon.magenta2,
		match_str_bg = C.tokyonight_moon.fg,
		first_match_str_fg = C.tokyonight_moon.magenta2,
		-- first_match_str_bg = C.tokyonight_moon.fg,
		label_fg = C.tokyonight_moon.magenta,
		label_bg = C.tokyonight_moon.dark3,
	},
}

local IS_NVIM = os.getenv("NVIM")
local NVIM_FLOAT_WINDOW = os.getenv("NVIM_FLOAT_WINDOW")
local IS_FLOAT = NVIM_FLOAT_WINDOW
local IS_SIDEPANE = os.getenv("YAZI_SIDEPANE")
IS_SIDEPANE = IS_SIDEPANE or (IS_NVIM and not NVIM_FLOAT_WINDOW)

if IS_SIDEPANE then
	require("searchjump"):setup({
		only_current = false, -- only search the current window
		show_search_in_statusbar = false,
		auto_exit_when_unmatch = false,
		enable_capital_label = false,
		search_patterns = { "%.e%d+", "s%d+e%d+" }, -- demo:{"%.e%d+","s%d+e%d+"}
		unmatch_fg = C.tokyonight_moon.dark3,
		match_str_fg = C.tokyonight_moon.fg,
		match_str_bg = C.tokyonight_moon.magenta2,
		first_match_str_fg = C.tokyonight_moon.magenta2,
		first_match_str_bg = C.tokyonight_moon.fg,
		label_fg = C.tokyonight_moon.yellow,
		label_bg = C.tokyonight_moon.bg,
		-- label_fg = C.tokyonight_moon.magenta2,
		-- label_bg = C.tokyonight_moon.bg_dark1,
	})
else
	require("searchjump"):setup({
		only_current = false, -- only search the current window
		show_search_in_statusbar = false,
		auto_exit_when_unmatch = false,
		enable_capital_label = false,
		search_patterns = {}, -- demo:{"%.e%d+","s%d+e%d+"}
		unmatch_fg = C.catppuccin_palette.overlay0,
		match_str_fg = C.catppuccin_palette.peach,
		match_str_bg = C.catppuccin_palette.base,
		first_match_str_fg = C.catppuccin_palette.lavender,
		first_match_str_bg = C.catppuccin_palette.base,
		label_fg = C.catppuccin_palette.green,
		label_bg = C.catppuccin_palette.base,
	})
end

-- local catppuccin_theme = require("yatline-catppuccin"):setup("macchiato") -- or "latte" | "frappe" | "macchiato"
local tokyo_night_theme = require("yatline-tokyo-night"):setup("moon") -- or moon/storm/day
local yatline_colors = {
	theme = tokyo_night_theme,
	style_a = {
		fg = "black",
		bg_mode = {
			normal = "white",
			select = "brightyellow",
			un_set = "brightred",
		},
	},
	style_b = { bg = "brightblack", fg = "brightwhite" },
	style_c = { bg = "black", fg = "brightwhite" },

	permissions_t_fg = "green",
	permissions_r_fg = "yellow",
	permissions_w_fg = "red",
	permissions_x_fg = "cyan",
	permissions_s_fg = "white",
}

if IS_NVIM and not IS_FLOAT then
	require("yatline"):setup({
		section_separator = { open = "", close = "" },
		part_separator = { open = "", close = "" },
		inverse_separator = { open = "", close = "" },

		show_background = false,
		---
		tab_width = 10,
		tab_use_inverse = false,

		selected = { icon = "󰻭", fg = "yellow" },
		copied = { icon = "", fg = "green" },
		cut = { icon = "", fg = "red" },

		total = { icon = "󰮍", fg = "yellow" },
		succ = { icon = "", fg = "green" },
		fail = { icon = "", fg = "red" },
		found = { icon = "󰮕", fg = "blue" },
		processed = { icon = "󰐍", fg = "green" },

		show_background = true,

		display_header_line = true,
		display_status_line = true,

		---
		header_line = {
			left = {
				section_a = {
					{ type = "line", custom = false, name = "tabs", params = { "left" } },
				},
				section_b = {},
				section_c = {},
			},
			right = {
				section_a = {
					-- { type = "string", custom = false, name = "date", params = { "%A, %d %B %Y" } },
				},
				section_b = {
					{ type = "string", custom = false, name = "date", params = { "%X" } },
				},
				section_c = {},
			},
		},

		status_line = {
			left = {
				section_a = {
					{ type = "string", custom = false, name = "tab_mode" },
				},
				section_b = {
					-- { type = "string", custom = false, name = "hovered_size" },
				},
				section_c = {
					{ type = "string", custom = false, name = "hovered_path" },
					-- { type = "coloreds", custom = false, name = "count" },
					{ type = "coloreds", custom = false, name = "modified-time" },
				},
			},
			right = {
				section_a = {
					-- { type = "string", custom = false, name = "cursor_position" },
				},
				section_b = {
					-- { type = "string", custom = false, name = "cursor_percentage" },
				},
				section_c = {
					-- { type = "string", custom = false, name = "hovered_file_extension", params = { true } },
					-- { type = "coloreds", custom = false, name = "permissions" },
				},
			},
		},
		table.unpack(yatline_colors),
	})
else
	-- Default configuration
	require("yatline"):setup({
		section_separator = { open = "", close = "" },
		part_separator = { open = "", close = "" },
		inverse_separator = { open = "", close = "" },
		--
		-- style_a = {
		-- 	fg = "black",
		-- 	bg_mode = {
		-- 		normal = "white",
		-- 		select = "brightyellow",
		-- 		un_set = "brightred",
		-- 	},
		-- },
		-- style_b = { bg = "brightblack", fg = "brightwhite" },
		-- style_c = { bg = "black", fg = "brightwhite" },
		--
		-- permissions_t_fg = "green",
		-- permissions_r_fg = "yellow",
		-- permissions_w_fg = "red",
		-- permissions_x_fg = "cyan",
		-- permissions_s_fg = "white",

		tab_width = 20,
		tab_use_inverse = false,

		selected = { icon = "󰻭", fg = "yellow" },
		copied = { icon = "", fg = "green" },
		cut = { icon = "", fg = "red" },

		total = { icon = "󰮍", fg = "yellow" },
		succ = { icon = "", fg = "green" },
		fail = { icon = "", fg = "red" },
		found = { icon = "󰮕", fg = "blue" },
		processed = { icon = "󰐍", fg = "green" },

		show_background = true,

		display_header_line = true,
		display_status_line = true,

		component_positions = { "header", "tab", "status" },

		header_line = {
			left = {
				section_a = {
					{ type = "line", custom = false, name = "tabs", params = { "left" } },
				},
				section_b = {},
				section_c = {},
			},
			right = {
				section_a = {
					{ type = "string", custom = false, name = "date", params = { "%A, %d %B %Y" } },
				},
				section_b = {
					{ type = "string", custom = false, name = "date", params = { "%X" } },
				},
				section_c = {
					{ type = "coloreds", custom = false, name = "tab_path" },
				},
			},
		},

		status_line = {
			left = {
				section_a = {
					{ type = "string", custom = false, name = "tab_mode" },
				},
				section_b = {
					{ type = "string", custom = false, name = "hovered_size" },
				},
				section_c = {
					{ type = "string", custom = false, name = "hovered_path" },
					{ type = "coloreds", custom = false, name = "count" },
				},
			},
			right = {
				section_a = {
					{ type = "string", custom = false, name = "cursor_position" },
				},
				section_b = {
					{ type = "string", custom = false, name = "cursor_percentage" },
				},
				section_c = {
					{ type = "string", custom = false, name = "hovered_file_extension", params = { true } },
				},
			},
		},
		table.unpack(yatline_colors),
	})
end
require("yatline-tab-path"):setup()
require("yatline-tab-path"):setup({
	path_fg = "cyan",
	filter_fg = "brightyellow",
	search_label = " search",
	filter_label = " filter",
	no_filter_label = "",
	flatten_label = " flatten",
	separator = "  ",
})
require("yatline-modified-time"):setup()
-- require("yatline-githead"):setup()
require("yatline-githead"):setup({
	show_branch = true,
	branch_prefix = "on",
	prefix_color = "white",
	branch_color = "blue",
	branch_symbol = "",
	branch_borders = "()",

	commit_color = "bright magenta",
	commit_symbol = "@",

	show_behind_ahead = true,
	behind_color = "bright magenta",
	behind_symbol = "⇣",
	ahead_color = "bright magenta",
	ahead_symbol = "⇡",

	show_stashes = false,
	stashes_color = "bright magenta",
	stashes_symbol = "$",

	show_state = true,
	show_state_prefix = true,
	state_color = "red",
	state_symbol = "~",

	show_staged = true,
	staged_color = "bright yellow",
	staged_symbol = "+",

	show_unstaged = false,
	unstaged_color = "bright yellow",
	unstaged_symbol = "!",

	show_untracked = true,
	untracked_color = "blue",
	untracked_symbol = "?",
})
-- Broken after yazi v25.4.8
-- require("auto-layout")

require("git"):setup()

if IS_SIDEPANE and not IS_FLOAT then
	-- require("toggle-pane"):entry("min-preview")
	-- require("toggle-pane"):entry("min-parent")
	require("toggle-pane"):entry("max-current")
	-- require("no-status"):setup()
end
if IS_NVIM and IS_FLOAT then
	require("full-border"):setup({
		-- 	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
		type = ui.Border.ROUNDED,
	})
end

require("folder-rules"):setup()

-- You can configure your bookmarks by lua language
local bookmarks = {}
local home_path = os.getenv("HOME")
table.insert(bookmarks, {
	tag = "User Config",

	path = (home_path .. "./.config"),
	key = "c",
})
table.insert(bookmarks, {
	tag = "Yazi Config",
	path = (home_path .. "./.config/yazi"),
	key = "y",
})
table.insert(bookmarks, {
	tag = "Nvim Config",
	path = (home_path .. "./.config/nvim"),
	key = "n",
})
table.insert(bookmarks, {
	tag = "Aerospace Config",
	path = (home_path .. "./.config/aerospace"),
	key = "a",
})
table.insert(bookmarks, {
	tag = "Helix Config",
	path = (home_path .. "./.config/helix"),
	key = "h",
})
table.insert(bookmarks, {
	tag = "Hammerspoon Config",
	path = (home_path .. "./.config/hammerspoon"),
	key = "H",
})
table.insert(bookmarks, {
	tag = "Downloads",
	path = home_path .. "/Downloads",
	key = "d",
})

require("yamb"):setup({
	-- Optional, the path ending with path seperator represents folder.
	bookmarks = bookmarks,
	-- Optional, recieve notification everytime you jump.
	jump_notify = true,
	-- Optional, the cli of fzf.
	cli = "fzf",
	-- Optional, a string used for randomly generating keys, where the preceding characters have higher priority.
	keys = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ",
	-- Optional, the path of bookmarks
	path = (os.getenv("HOME") .. "/.config/yazi/bookmark"),
})

-- require("fg"):setup({
-- 	default_action = "jump",
-- })

local YAZI_FZF_OPTS = os.getenv("YAZI_FZF_OPTS")
if IS_NVIM and YAZI_FZF_OPTS then
	require("fr"):setup({
		fzf = YAZI_FZF_OPTS,
	})
end

--
-- require("fr"):setup({
-- 	fzf = [[--info-command='echo -e "$FZF_INFO 💛"' --no-scrollbar]],
-- 	rg = "--colors 'line:fg:red' --colors 'match:style:nobold'",
-- 	bat = "--style 'header,grid'",
-- 	rga = {
-- 		"--follow",
-- 		"--hidden",
-- 		"--no-ignore",
-- 		"--glob",
-- 		"'!.git'",
-- 		"--glob",
-- 		"!'.venv'",
-- 		"--glob",
-- 		"'!node_modules'",
-- 		"--glob",
-- 		"'!.history'",
-- 		"--glob",
-- 		"'!vendor'",
-- 		"--glob",
-- 		"'!.git'",
-- 		"--glob",
-- 		"'!.github'",
-- 		"--glob",
-- 		"'!.cursor'",
-- 	},
-- 	rga_preview = {
-- 		"--colors 'line:fg:red'"
-- 			.. " --colors 'match:fg:blue'"
-- 			.. " --colors 'match:bg:black'"
-- 			.. " --colors 'match:style:nobold'",
-- 	},
-- })

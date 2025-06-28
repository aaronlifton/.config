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
}

-- Plugins

require("zoxide"):setup({
	update_db = false,
})

require("session"):setup({
	sync_yanked = true,
})

require("searchjump"):setup({
	unmatch_fg = catppuccin_palette.overlay0,
	match_str_fg = catppuccin_palette.peach,
	match_str_bg = catppuccin_palette.base,
	first_match_str_fg = catppuccin_palette.lavender,
	first_match_str_bg = catppuccin_palette.base,
	lable_fg = catppuccin_palette.green,
	lable_bg = catppuccin_palette.base,
	only_current = false, -- only search the current window
	show_search_in_statusbar = false,
	auto_exit_when_unmatch = false,
	enable_capital_lable = false,
	search_patterns = {}, -- demo:{"%.e%d+","s%d+e%d+"}
})

require("yatline")
-- Broken after yazi v25.4.8
-- require("auto-layout")

require("git"):setup()

if os.getenv("NVIM") then
	--  require("toggle-pane"):entry("min-preview")
	-- require("toggle-pane"):entry("min-parent")
	require("toggle-pane"):entry("max-current")
else
	require("full-border"):setup({
		-- 	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
		type = ui.Border.ROUNDED,
	})
end

-- require("fg"):setup({
-- 	default_action = "jump",
-- })

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

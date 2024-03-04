local wezterm = require("wezterm")
local fonts = require("util/fonts")
local color_util = require("util/colorscheme")
local vim_settings = require("util/vim")

-- wezterm.on("gui-startup", function(cmd) -- set startup Window position
-- 	local tab, pane, window = wezterm.mux.spawn_window(cmd or { position = { x = 0, y = 0 }, width = 90, height = 80 })
-- end)

local config = {}
if wezterm.config_builder then
	config = wezterm.config_builder()
end
-- local smart_path = "~/Code/nvim-plugins/smart-splits.nvim"
-- local smart_splits = wezterm.plugin.require(smart_path)
local smart_splits = wezterm.plugin.require("http://github.com/mrjones2014/smart-splits.nvim")

smart_splits.apply_to_config(config, {
	-- the default config is here, if you'd like to use the default keys,
	-- you can omit this configuration table parameter and just use
	-- smart_splits.apply_to_config(config)

	-- directional keys to use in order of: left, down, up, right
	direction_keys = { "h", "j", "k", "l" },
	-- modifier keys to combine with direction_keys
	modifiers = {
		move = "CTRL", -- modifier to use for pane movement, e.g. CTRL+h to move left
		-- resize = "META", -- modifier to use for pane resize, e.g. META+h to resize to the left
		resize = "ALT", -- modifier to use for pane resize, e.g. META+h to resize to the left
	},
})

local a = wezterm.action
local act = a

local function map(things)
	local t = {}
	for key in string.gmatch(things, "([^,]+)") do
		table.insert(t, a.SendKey({ key = key }))
	end
	return t
end

wezterm.on("update-status", function(window, pane)
	local padding = {
		left = "1cell",
		right = 0,
		top = 0,
		bottom = 0,
	}
	local overrides = window:get_config_overrides() or {}
	if string.find(pane:get_title(), "^n-vi-m-.*") then
		overrides.window_padding = {
			left = 0,
			right = 0,
			top = 0,
			bottom = 0,
		}
	else
		overrides.window_padding = padding
	end
	window:set_config_overrides(overrides)
end)

local function get_current_working_dir(tab)
	local current_dir = tab.active_pane and tab.active_pane.current_working_dir or { file_path = "" }
	local HOME_DIR = string.format("file://%s", os.getenv("HOME"))

	return current_dir == HOME_DIR and "." or string.gsub(current_dir.file_path, "(.*[/\\])(.*)", "%2")
end

local function get_process(tab)
	if not tab.active_pane or tab.active_pane.foreground_process_name == "" then
		return "[?]"
	end

	local process_name = string.gsub(tab.active_pane.foreground_process_name, "(.*[/\\])(.*)", "%2")
	if string.find(process_name, "kubectl") then
		process_name = "kubectl"
	end

	return fonts.icons.process[process_name] or string.format("[%s]", process_name)
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
	local has_unseen_output = false
	if not tab.is_active then
		for _, pane in ipairs(tab.panes) do
			if pane.has_unseen_output then
				has_unseen_output = true
				break
			end
		end
	end

	local cwd = wezterm.format({
		{ Attribute = { Intensity = "Bold" } },
		{ Text = get_current_working_dir(tab) },
	})

	local title = string.format(" %s ~ %s  ", get_process(tab), cwd)

	if has_unseen_output then
		return {
			{ Foreground = { Color = "#8866bb" } },
			{ Text = title },
		}
	end

	return {
		{ Text = title },
	}
end)

local background = "#0a0a00"
wezterm.on("update-right-status", function(window, pane)
	local status = ""
	local max_args = 3

	local info = pane:get_foreground_process_info()
	if info then
		status = info.name
		for i = 2, #info.argv do
			status = status .. " " .. info.argv[i]
		end
	end

	local time = ""
	if window:get_dimensions().is_full_screen then
		time = " | " .. wezterm.strftime("%R ")
	end

	window:set_right_status(wezterm.format({
		{ Foreground = { Color = "#7eb282" } },
		{ Text = status },
		{ Foreground = { Color = "#808080" } },
		{ Text = time },
	}))
end)

config.colors = {
	-- colors = { background = "#0c0e14" },
	background = background,
	cursor_bg = "#a9a1e1",
	cursor_fg = background,
	cursor_border = "#fb4934",
	selection_fg = background,
	selection_bg = "#fb4934",
	tab_bar = {
		background = background,
		inactive_tab_edge = "rgba(28, 28, 28, 0.9)",
		active_tab = {
			bg_color = background,
			fg_color = "#c0c0c0",
		},
		inactive_tab = {
			bg_color = background,
			fg_color = "#808080",
		},
		inactive_tab_hover = {
			bg_color = background,
			fg_color = "#808080",
		},
	},
	scrollbar_thumb = "white",
}

-- config.color_scheme = color_util.get_colorscheme(wezterm.gui.get_appearance()),
config.color_scheme = "Catppuccin Mocha"
config.color_scheme_dirs = { "/Users/aaron/.config/wezterm/colors" }
config.font_size = 15.0
config.line_height = 1.1
-- config.cell_width = 0.9
config.freetype_render_target = "Normal" -- Normal, Light, HorizontalLcd - https://wezfurlong.org/wezterm/config/lua/config/freetype_render_target.html
config.freetype_load_target = "Normal" -- Normal, Light, Mono, HorizontalLcd - https://wezfurlong.org/wezterm/config/lua/config/freetype_load_target.html
config.freetype_load_flags = "DEFAULT" -- DEFAULT, NO_HINTING, NO_BITMAP, FORCE_AUTOHINT, MONOCHROME, NO_AUTOHINT - https://wezfurlong.org/wezterm/config/lua/config/freetype_load_flags.html
config.font = wezterm.font("Hack Nerd Font Mono")
-- config.font = wezterm.font("ProFontIIx Nerd Font Mono")
config.debug_key_events = true
config.automatically_reload_config = true
config.window_frame = {}
config.window_padding = { left = 10, right = 10, top = 10, bottom = 10 }
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.window_decorations = "RESIZE"
config.max_fps = 120
config.front_end = "WebGpu" -- OpenGL, Software, WebGpu
config.enable_scroll_bar = true
config.min_scroll_bar_height = "2cell"
config.window_background_opacity = 0.999
config.window_close_confirmation = "NeverPrompt"
config.quick_select_alphabet = "arstqwfpzxcvneioluymdhgjbk"
config.command_palette_font_size = 16.0
config.command_palette_fg_color = "#82aaff" --'white', --rgba(0.75, 0.75, 0.75, 0.8)',
config.command_palette_bg_color = "#191b28"
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = false -- https://www.leonerd.org.uk/hacks/fixterms/
-- config.enable_csi_u_key_encoding = true

keys = {
	-- Make Option-Left equivalent to Alt-b which many line editors interpret as backward-word
	{ key = "LeftArrow", mods = "OPT", action = act.SendString("\x1bb") },
	-- Make Option-Right equivalent to Alt-f; forward-word
	{ key = "RightArrow", mods = "OPT", action = act.SendString("\x1bf") },
	-- Jump word to the left
	{
		key = "LeftArrow",
		mods = "OPT",
		action = act.SendKey({
			key = "b",
			mods = "ALT",
		}),
	},

	-- Jump word to the right
	{
		key = "RightArrow",
		mods = "OPT",
		action = act.SendKey({ key = "f", mods = "ALT" }),
	},
	-- Go to beginning of line
	{
		key = "LeftArrow",
		mods = "CMD",
		action = act.SendKey({
			key = "a",
			mods = "CTRL",
		}),
	},

	-- Go to end of line
	{
		key = "RightArrow",
		mods = "CMD",
		action = act.SendKey({ key = "e", mods = "CTRL" }),
	},
	{ key = "r", mods = "LEADER", action = act.ActivateKeyTable({ name = "resize_pane", one_shot = false }) },
	-- CTRL+SHIFT+Space, followed by 'a' will put us in activate-panemode until we press some other key or until 1 second (1000ms)of time elapses
	{
		key = "a",
		mods = "LEADER",
		action = act.ActivateKeyTable({ name = "activate_pane", timeout_milliseconds = 1000 }),
	},
	{ key = "a", mods = "CTRL|SHIFT", action = wezterm.action({ SendString = "\x01" }) },
	-- Send "CTRL-A" to the terminal when pressing CTRL-A, CTRL-A
	{ key = "a", mods = "LEADER|CTRL", action = wezterm.action.SendKey({ key = "a", mods = "CTRL" }) },
	{ key = "|", mods = "LEADER|SHIFT", action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "LEADER", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "y", mods = "LEADER", action = wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }) },
	-- generate a keybinding that would reload the config
	{ key = "z", mods = "LEADER", action = "TogglePaneZoomState" },
	{ key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
	{ key = "j", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
	{ key = "k", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
	{ key = "l", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
	{ key = "H", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Left", 5 } }) },
	{ key = "J", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Down", 5 } }) },
	{ key = "K", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Up", 5 } }) },
	{ key = "L", mods = "LEADER|SHIFT", action = wezterm.action({ AdjustPaneSize = { "Right", 5 } }) },
	{ key = "1", mods = "LEADER", action = wezterm.action({ ActivateTab = 0 }) },
	{ key = "2", mods = "LEADER", action = wezterm.action({ ActivateTab = 1 }) },
	{ key = "3", mods = "LEADER", action = wezterm.action({ ActivateTab = 2 }) },
	{ key = "4", mods = "LEADER", action = wezterm.action({ ActivateTab = 3 }) },
	{ key = "5", mods = "LEADER", action = wezterm.action({ ActivateTab = 4 }) },
	{ key = "6", mods = "LEADER", action = wezterm.action({ ActivateTab = 5 }) },
	{ key = "7", mods = "LEADER", action = wezterm.action({ ActivateTab = 6 }) },
	{ key = "8", mods = "LEADER", action = wezterm.action({ ActivateTab = 7 }) },
	{ key = "9", mods = "LEADER", action = wezterm.action({ ActivateTab = 8 }) },
	{ key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentPane = { confirm = true } }) },
	{
		key = "p",
		mods = "LEADER",
		action = act.ShowLauncherArgs({ flags = "FUZZY|TABS|WORKSPACES" }),
	},
	{
		key = ".",
		mods = "CMD",
		action = wezterm.action.ActivateCommandPalette,
	},
	{ key = "RightArrow", mods = "CTRL|SHIFT", action = wezterm.action({ SendString = "\x05" }) },
	{ key = "y", mods = "CMD", action = wezterm.action.SpawnCommandInNewTab({ args = { "top" } }) },
	{ key = "k", mods = "CMD", action = act.ActivatePaneDirection("Down") },
	{ key = "LeftArrow", mods = "CMD", action = a.ActivatePaneDirection("Left") },
	{ key = "RightArrow", mods = "CMD", action = act.ActivatePaneDirection("Right") },
	{ key = "UpArrow", mods = "CMD|SHIFT", action = act.AdjustPaneSize({ "Up", 1 }) },
	{ key = "DownArrow", mods = "CMD|SHIFT", action = act.AdjustPaneSize({ "Down", 1 }) },
	-- cmd-arrow key pane navigation
	{ key = "UpArrow", mods = "CMD", action = a.ActivatePaneDirection("Up") },
	{ key = "DownArrow", mods = "CMD", action = a.ActivatePaneDirection("Down") },
	{ key = "LeftArrow", mods = "CMD", action = a.ActivatePaneDirection("Left") },
	{ key = "RightArrow", mods = "CMD", action = a.ActivatePaneDirection("Right") },
	--vim-like pane navigation
	{ key = "j", mods = "LEADER", action = a.ActivatePaneDirection("Down") },
	{ key = "k", mods = "LEADER", action = a.ActivatePaneDirection("Up") },
	{ key = "UpArrow", mods = "CMD|SHIFT", action = a.AdjustPaneSize({ "Up", 1 }) },
	{ key = "DownArrow", mods = "CMD|SHIFT", action = a.AdjustPaneSize({ "Down", 1 }) },
	{ key = "LeftArrow", mods = "CMD|SHIFT", action = a.AdjustPaneSize({ "Left", 1 }) },
	{ key = "RightArrow", mods = "CMD|SHIFT", action = a.AdjustPaneSize({ "Right", 1 }) },
	{ key = "c", mods = "CMD|SHIFT", action = a.Multiple(map('",+,y')) },
	{ key = "s", mods = "CMD", action = a.Multiple(map("Escape,:,w,Enter")) },
	{ key = "a", mods = "CMD", action = a.Multiple(map("Escape,g,g,V,G")) },
	{ key = "p", mods = "CMD|SHIFT", action = a.Multiple(map("Escape,:")) },
	{ key = "p", mods = "CMD", action = a.Multiple(map("Escape,:")) },
	{
		key = "f",
		mods = "CMD|SHIFT",
		action = a.Multiple(map("Escape,:,T,e,l,e,s,c,o,p,e, ,l,i,v,e,_,g,r,e,p,Enter")),
	},
	{
		key = "e",
		mods = "CMD|SHIFT",
		action = a.Multiple(map("Escape,:,N,e,o,t,r,e,e, ,r,e,v,e,a,l,_,f,o,r,c,e,_,c,w,d,Enter")),
	},
	{
		key = "o",
		mods = "CMD",
		action = a.Multiple(map("Escape,:,T,e,l,e,s,c,o,p,e, ,g,i,t,_,f,i,l,e,s,Enter")),
	},
	{
		key = "o",
		mods = "CMD|SHIFT",
		action = a.Multiple(map("Escape,:,T,e,l,e,s,c,o,p,e, ,f,i,n,d,_,f,i,l,e,s,Enter")),
	},
	{
		key = "b",
		mods = "CMD",
		action = a.Multiple(map("Escape,:,N,e,o,t,r,e,e, ,t,o,g,g,l,e,Enter")),
	},
	{ key = "|", mods = "CMD|SHIFT", action = a.Multiple(map("g,z,a,`,Escape")) },
	{ key = "r", mods = "CTRL|SHIFT", action = wezterm.action.ReloadConfiguration },
	{
		mods = "CMD|SHIFT",
		key = "m",
		action = wezterm.action_callback(function(_win, _pane)
			--wezterm.background_child_process {'xdg-open',win:effective_config().window_background_image, }
			local success, stdout, stderr = wezterm.run_child_process({ "ls", "-l" })
			print(success, stdout, stderr)
		end),
	},
	{
		mods = "CMD|SHIFT",
		key = "s",
		action = wezterm.action_callback(function(window, pane)
			-- Here you can dynamically construct a longer list if needed
			local home = wezterm.home_dir
			local workspaces = {
				{ id = home, label = "Home" },
				{ id = home .. "/Code", label = "Work" },
				{ id = home .. "/Documents", label = "Personal" },
				{ id = home .. "/.config", label = "Config" },
			}
			window:perform_action(
				a.InputSelector({
					action = wezterm.action_callback(function(inner_window, inner_pane, id, label)
						if not id and not label then
							wezterm.log_info("cancelled")
						else
							wezterm.log_info("id =" .. id)
							wezterm.log_info("label =" .. label)
							inner_window:perform_action(
								a.SwitchToWorkspace({
									name = label,
									spawn = { label = "Workspace:" .. label, cwd = id },
								}),
								inner_pane
							)
						end
					end),
					title = "Choose Workspace",
					choices = workspaces,
					fuzzy = true,
					-- Nightly version only: https://wezfurlong.org/wezterm/config/lua/keyassignment/InputSelector.html?h=input+selector#:~:text=These%20additional%20fields%20are%20also%20available%3A
					fuzzy_description = "Fuzzy find and/or make a workspace",
				}),
				pane
			)
		end),
	},
	{ key = "M", mods = "CTRL|SHIFT", action = wezterm.action.SpawnWindow },
	{ key = "N", mods = "CTRL|SHIFT", action = wezterm.action.DisableDefaultAssignment },
	{
		key = "N",
		mods = "CTRL|SHIFT",
		action = a.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				--line will be `nil` if they hit escape without entering anything, an empty string if they just hit enter, or the actual line of text they wrote
				if line then
					window:perform_action(a.SwitchToWorkspace({ name = line }), pane)
				end
			end),
		}),
	},
	{
		key = "w",
		mods = "ALT",
		action = a.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }),
	},
	-- https://wezfurlong.org/wezterm/config/lua/keyassignment/SwitchToWorkspace.html#prompting-for-the-workspace-name
	-- Prompt for a name to use for a new workspace and switch to it.
	-- rename workspace
	{
		key = "W",
		mods = "ALT|SHIFT",
		action = a.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for current workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				-- line will be `nil` if they hit escape without entering anything, an empty string if they just hit enter, or the actual line of text they wrote
				if line then
					wezterm.mux.rename_workspace(window:active_workspace(), line)
					window:perform_action(act.SwitchToWorkspace({ name = line }), pane)
				end
			end),
		}),
	},
	{ key = "\\", mods = "LEADER", action = a.PaneSelect({ alphabet = "asdfghjkl;", mode = "SwapWithActive" }) },
	-- Move Tabs Relatively
	{ key = "{", mods = "ALT|SHIFT", action = a.MoveTabRelative(-1) },
	{ key = "}", mods = "ALT|SHIFT", action = a.MoveTabRelative(1) },
	-- Open Links Via Keyboard
	{
		key = "o",
		mods = "CTRL|SHIFT",
		action = act.QuickSelectArgs({
			label = "open url",
			patterns = { "\\" },
			action = wezterm.action_callback(function(window, pane)
				local url = window:get_selection_text_for_pane(pane)
				wezterm.open_with(url)
			end),
		}),
	},
	-- ScrollBack To Prompt
	{ key = "UpArrow", mods = "CTRL|SHIFT", action = act.ScrollToPrompt(-1) },
	{ key = "DownArrow", mods = "CTRL|SHIFT", action = act.ScrollToPrompt(1) },
	-- CTRL+A, followed by 'r' will put us in resize-pane
	-- mode until we cancel that mode.
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
		}),
	},

	-- CTRL+A followed by 'a' will put us in activate-pane
	-- mode until we press some other key or until 1 second (1000ms)
	-- of time elapses
	{
		key = "a",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "activate_pane",
			timeout_milliseconds = 1000,
		}),
	},
	-- table.unpack(bounded_super_vim_keys),
	table.unpack(vim_settings.keys),
}

wezterm.on("update-right-status", function(window, pane)
	local name = window:active_key_table()
	if name then
		name = "TABLE: " .. name
	end
	window:set_right_status(name or "")
end)

local key_tables = {
	copy_mode = {
		{ key = "a", mods = "CTRL", action = a.CopyMode("MoveToStartOfLine") },
		{ key = "e", mods = "CTRL", action = a.CopyMode("MoveToEndOfLineContent") },
	},
	-- Defines the keys that are active in our resize-pane mode.
	-- Since we're likely to want to make multiple adjustments,
	-- we made the activation one_shot=false. We therefore need
	-- to define a key assignment for getting out of this mode.
	-- 'resize_pane' here corresponds to the name="resize_pane" in
	-- the key assignments above.
	resize_pane = {
		{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },

		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },

		{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },

		{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
	},

	-- Defines the keys that are active in our activate-pane mode.
	-- 'activate_pane' here corresponds to the name="activate_pane" in
	-- the key assignments above.
	activate_pane = {
		{ key = "LeftArrow", action = act.ActivatePaneDirection("Left") },
		{ key = "h", action = act.ActivatePaneDirection("Left") },

		{ key = "RightArrow", action = act.ActivatePaneDirection("Right") },
		{ key = "l", action = act.ActivatePaneDirection("Right") },

		{ key = "UpArrow", action = act.ActivatePaneDirection("Up") },
		{ key = "k", action = act.ActivatePaneDirection("Up") },

		{ key = "DownArrow", action = act.ActivatePaneDirection("Down") },
		{ key = "j", action = act.ActivatePaneDirection("Down") },
	},
}

config.keys = keys
config.key_tables = key_tables

-- TODO: review and delete
-- local wezterm = require 'wezterm'
--
-- {
-- 	key = "!",
-- 	mods = "SHIFT",
-- 	action = wezterm.action_callback(function(_, pane)
-- 		pane:move_to_new_window()
-- 	end),
-- },
-- {
-- 	key = "t",
-- 	mods = "CMD",
-- 	action = wezterm.action.SpawnCommandInNewTab({
-- 		args = { "prevd" },
-- 	}),
-- },
-- background = {
-- 	-- This is the deepest/back-most layer. It will be rendered first
-- 	{
-- 		source = {
-- 			File = "/Users/aaron/.config/wezterm/backgrounds/solarized_darcula.jpg",
-- 		},
-- 		-- The texture tiles ''vertically but not horizontally.
-- 		-- When we repeat it, mirror it so that it appears "more seamless".
-- 		-- An alternative to this is to set `width = "100%"` and have
-- 		-- it stretch across the display
-- 		repeat_x = "Mirror",
-- 		hsb = { brightness = 0.7, saturation = 0.4 },
-- 		-- When the viewport scrolls, move this layer 10% of the number of
-- 		-- pixels moved by the main viewport. This makes it appear to be
-- 		-- further behind the text.
-- 		attachment = { Parallax = 0.25 },
-- 		opacity = 0.5,
-- 	},
-- },
-- window_background_image = "/Users/aaron/.config/wezterm/backgrounds/solarized_darcula.jpg",

---- OTHER
-- local success, stdout, stderr = wezterm.run_child_process { 'ls', '-l' }

return config

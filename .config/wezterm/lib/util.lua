local wezterm = require("wezterm")

local function is_vi_process(pane)
	return pane:get_foreground_process_name():find("n?vim") ~= nil
end

local direction_keys = {
	h = "Left",
	j = "Down",
	k = "Up",
	l = "Right",
}

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "ALT|SHIFT" or "ALT",
		action = wezterm.action_callback(function(win, pane)
			if is_vi_process(pane) then
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "ALT|SHIFT" or "ALT" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

local function split_nav(resize_or_move, key)
	return {
		key = key,
		mods = resize_or_move == "resize" and "ALT|SHIFT" or "ALT",
		action = wezterm.action_callback(function(win, pane)
			if is_vi_process(pane) then
				win:perform_action({
					SendKey = { key = key, mods = resize_or_move == "resize" and "ALT|SHIFT" or "ALT" },
				}, pane)
			else
				if resize_or_move == "resize" then
					win:perform_action({ AdjustPaneSize = { direction_keys[key], 3 } }, pane)
				else
					win:perform_action({ ActivatePaneDirection = direction_keys[key] }, pane)
				end
			end
		end),
	}
end

local function better_close(mods, key)
	return {
		key = key,
		mods = mods,
		action = wezterm.action_callback(function(win, pane)
			if is_vi_process(pane) then
				win:perform_action({
					SendKey = { key = key, mods = mods },
				}, pane)
			else
				win:perform_action({ CloseCurrentPane = { confirm = false } }, pane)
			end
		end),
	}
end

-- Continue here: https://github.com/CharlesChiuGit/dotfiles/blob/87fefcfe1cad63a018da5cdb2e8cd170fb5955d4/terminals/wezterm/config/keymap.lua#L52

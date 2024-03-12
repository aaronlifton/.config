local wezterm = require("wezterm")
local M = {}

local function is_vim(pane)
	is_vim_env = pane:get_user_vars().IS_NVIM == "true"
	if is_vim_env == true then
		return true
	end
	-- This gsub is equivalent to POSIX basename(3)
	-- Given "/foo/bar" returns "bar"
	-- Given "c:\\foo\\bar" returns "bar"
	local process_name = string.gsub(pane:get_foreground_process_name(), "(.*[/\\])(.*)", "%2")
	return process_name == "nvim" or process_name == "vim"
end

--- cmd+keys that we want to send to neovim.
local super_vim_keys_map = {
	-- s = utf8.char(0xAA),
	-- a = utf8.char(0xAB),
	b = utf8.char(0xAC),
	x = utf8.char(0xAD),
	-- c = utf8.char(0xAE),
	-- o = utf8.char(0xAF),
	-- [";"] = utf8.char(0xB0),
	-- d = utf8.char(0xB1),
	-- h = utf8.char(0xB2),
	-- j = utf8.char(0xB3),
	-- k = utf8.char(0xB4),
	-- l = utf8.char(0xB5),
	-- ["\\"] = utf8.char(0xB6),
	-- ["Enter"] = utf8.char(0xB7),
	-- ["'"] = utf8.char(0xB8),
}

M.bind_super_key_to_vim = function(key, char)
	return {
		key = key,
		mods = "CMD",
		action = wezterm.action_callback(function(win, pane)
			if char and is_vim(pane) then
				-- pass the keys through to vim/nvim
				win:perform_action({
					SendKey = { key = char, mods = nil },
				}, pane)
			else
				win:perform_action({
					SendKey = {
						key = key,
						mods = "CMD",
					},
				}, pane)
			end
		end),
	}
end

M.keys = {}

for key, char in pairs(super_vim_keys_map) do
	table.insert(M.keys, M.bind_super_key_to_vim(key, char))
end

return M

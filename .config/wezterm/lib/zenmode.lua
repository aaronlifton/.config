local wezterm = require("wezterm")

local module = {}

-- see also https://github.com/wez/wezterm/discussions/2550
--- @type WeztermEventCallback
function module.handle_event(window, pane, name, value)
	if name ~= "ZEN_MODE" then
		return
	end

	local overrides = window:get_config_overrides() or {}
	local incremental = value:find("+")
	local number_value = tonumber(value)
	if incremental ~= nil then
		while number_value > 0 do
			window:perform_action(wezterm.action.IncreaseFontSize, pane)
			number_value = number_value - 1
		end
		overrides.enable_tab_bar = false
	elseif number_value < 0 then
		window:perform_action(wezterm.action.ResetFontSize, pane)
		overrides.font_size = nil
		overrides.enable_tab_bar = true
	else
		overrides.font_size = number_value
		overrides.enable_tab_bar = false
	end
	window:set_config_overrides(overrides)
end

return module

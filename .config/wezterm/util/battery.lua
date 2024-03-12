local wezterm = require("wezterm")
local colorscheme = require("colorscheme")
local fonts = wezterm.nerdfonts
local colors = colorscheme.theme.config.colors
local module = {}

module.get = function()
	local battery = ""
	local battery_info = wezterm.battery_info()

	if battery_info then
		local icon = ""

		for _, b in ipairs(battery_info) do
			local charge = b.state_of_charge * 100

			if charge <= 10 then
				icon = fonts.md_battery_alert
			elseif charge > 10 and charge <= 30 then
				icon = fonts.md_battery_20
			elseif charge > 30 and charge <= 50 then
				icon = fonts.md_battery_40
			elseif charge > 50 and charge <= 70 then
				icon = fonts.md_battery_60
			elseif charge > 70 and charge <= 90 then
				icon = fonts.md_battery_80
			else
				icon = fonts.md_battery
			end

			battery = icon .. " " .. string.format("%.0f%%", charge)
		end

		return battery
	end
end

module.color = function()
	local battery_info = wezterm.battery_info()
	for _, b in ipairs(battery_info) do
		local charge = b.state_of_charge * 100

		if charge <= 10 then
			return colors.ansi[2]
		elseif charge < 40 then
			return colors.ansi[4]
		end

		return colors.ansi[3]
	end
end

return module

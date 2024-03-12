local wezterm = require("wezterm")
local module = {}

module.icon = function(weathercode)
	local weathers = {
		[-1] = " ", -- undefined
		[0] = "󰖨 ",
		[1] = " ",
		[2] = " ",
		[3] = "󰖐 ",
		[45] = "󰱋 ",
		[48] = "󰱋 ",
		[51] = "󰖗 ",
		[53] = "󰖖 ",
		[55] = "󰖖 ",
		[56] = "󰖒 ",
		[57] = "󰖒 ",
		[61] = "󰖗 ",
		[63] = "󰖖 ",
		[65] = "󰖖 ",
		[66] = "󰖒 ",
		[67] = "󰖒 ",
		[71] = "󰖘 ",
		[73] = "󰼶 ",
		[75] = "󰼶 ",
		[77] = "󰖘 ",
		[80] = "󰖗 ",
		[81] = "󰖖 ",
		[82] = "󰖖 ",
		[85] = "󰖘 ",
		[86] = "󰼶 ",
		[95] = "󰖓 ",
		[96] = "󰖓 ",
		[99] = "󰖓 ",
	}
	return weathers[weathercode]
end

module.conditions = function()
	if wezterm.GLOBAL.weather_timer % (3600 * 2) == 0 then -- every 2 hours
		local success, stdout, stderr = wezterm.run_child_process({
			"curl",
			"--silent",
			"https://api.open-meteo.com/v1/forecast?latitude=53.25741&longitude=-1.90982&current_weather=true",
		})

		if not success or not stdout then
			return
		end

		wezterm.GLOBAL.weather_conditions = module.icon(wezterm.json_parse(stdout).current_weather.weathercode)
			.. " "
			.. wezterm.json_parse(stdout).current_weather.temperature
			.. "°C"
	end

	wezterm.GLOBAL.weather_timer = wezterm.GLOBAL.weather_timer + 1

	return wezterm.GLOBAL.weather_conditions
end

return module

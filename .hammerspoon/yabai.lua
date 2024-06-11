-- Send message(s) to a running instance of yabai.
local function yabai(commands)
	for _, cmd in ipairs(commands) do
		os.execute("/opt/homebrew/bin/yabai -m " .. cmd)
	end
end

local function alt(key, commands)
	hs.hotkey.bind({ "alt" }, key, function()
		yabai(commands)
	end)
end

local function altCtrl(key, commands)
	hs.hotkey.bind({ "alt", "ctrl" }, key, function()
		yabai(commands)
	end)
end

-- alpha
altCtrl("f", { "window --toggle zoom-fullscreen" })
--altCtrl("l", { "space --focus recent" })
altCtrl("m", { "space --toggle mission-control" })
altCtrl("p", { "window --toggle pip" })
--altCtrl("g", { "space --toggle padding", "space --toggle gap" })
altCtrl("r", { "space --rotate 90" })
altCtrl("t", { "window --toggle float", "window --grid 4:4:1:1:2:2" })

-- special characters
altCtrl("'", { "space --layout stack" })
altCtrl(";", { "space --layout bsp" })
altCtrl("0", { "space --focus recent" })

local function altShift(key, commands)
	hs.hotkey.bind({ "alt", "shift" }, key, function()
		yabai(commands)
	end)
end

local function altShiftNumber(number)
	altShift(number, { "window --space " .. number, "space --focus " .. number })
end

for i = 1, 9 do
	local num = tostring(i)
	altCtrl(num, { "space --focus " .. num })
	altShiftNumber(num)
end

local homeRow = { h = "west", j = "south", k = "north", l = "east" }

for key, direction in pairs(homeRow) do
	-- alt(key, { "window --focus " .. direction })
	altShift(key, { "window --swap " .. direction })
end

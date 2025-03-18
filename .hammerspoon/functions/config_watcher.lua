local ConfigWatcher = {}

---@param files string[]
local function reload_config(files)
	local should_reload = false
	for _, file in pairs(files) do
		if file:sub(-4) == ".lua" then
			should_reload = true
		end
	end
	if should_reload then
		hs.reload()
	end
end

function ConfigWatcher.watch_config_and_reload()
	hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config):start()
	hs.alert.show("Config loaded")
end

return ConfigWatcher

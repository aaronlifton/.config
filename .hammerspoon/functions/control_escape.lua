local State = {
	sends_escape = true,
	last_mods = {},
}
setmetatable(State, {
	__index = function(self, key)
		return self[key]
	end,
})
function State:set(key, value)
	self[key] = value
end

local control_key_timer = hs.timer.delayed.new(0.15, function()
	send_escape = false
end)

local last_mods = {}
local control_handler = function(evt)
	local new_mods = evt:getFlags()
	if last_mods["ctrl"] == new_mods["ctrl"] then
		return false
	end
	if not last_mods["ctrl"] then
		last_mods = new_mods
		send_escape = true
		control_key_timer:start()
	else
		last_mods = new_mods
		control_key_timer:stop()
		if send_escape then
			return true,
				{
					hs.eventtap.event.newKeyEvent({}, "escape", true),
					hs.eventtap.event.newKeyEvent({}, "escape", false),
				}
		end
	end
	return false
end

local control_tap = hs.eventtap.new({ 12 }, control_handler)

control_tap:start()

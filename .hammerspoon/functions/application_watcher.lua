local CHROME = "Google Chrome"
local browser = require("functions/browser")
local logger = require("functions/logger")

local chrome_modal = hs.hotkey.modal.new({}, nil, nil)
chrome_modal:bind({ "alt" }, "t", browser.newTabToRight)

--- Application watcher
---@param appName string
---@param eventType string
---@param appObject hs.application
local function application_watcher(appName, eventType, appObject)
	logger.d(appName, eventType == hs.application.watcher.activated and "activated" or "deactivated")
	if eventType == hs.application.watcher.activated then
		if appName == CHROME then
			logger.d("Entered Chrome")
			chrome_modal:enter()
		end
	end
	if eventType == hs.application.watcher.deactivated then
		if appName == CHROME then
			chrome_modal:exit()
		end
	end
	-- if eventType == hs.application.watcher.activated then
	-- 	if appName == "Kitty" then
	-- 		fk_modal:enter()
	-- 	end
	-- end
	-- if eventType == hs.application.watcher.deactivated then
	-- 	if appName == "kitty" then
	-- 		fk_modal.exit()
	-- 	end
	-- end
end

---@type hs.application.watcher
local appWatcher = hs.application.watcher.new(application_watcher)
return appWatcher

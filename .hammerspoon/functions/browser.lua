local logger = require("functions/logger")

local M = {}

M.jump = function(browserName)
	local function open()
		hs.application.launchOrFocus(browserName)
	end
	local function jump(url)
		local script = ([[(function() {
      var browser = Application('%s');
      browser.activate();

      for (win of browser.windows()) {
        var tabIndex =
          win.tabs().findIndex(tab => tab.url().match(/%s/));

        if (tabIndex != -1) {
          win.activeTabIndex = (tabIndex + 1);
          win.index = 1;
        }
      }
    })();
  ]]):format(browserName, url)

		-- print(script)
		hs.osascript.javascript(script)
	end
	return { open = open, jump = jump }
end

-- Function to create a new tab to the right in Chrome
M.newTabToRight = function()
	logger.d('Selecting "newTabToRight"')
	local app = hs.application.find("Chrome")
	app:selectMenuItem({ "Tab", "New Tab to the Right" })
end

return M

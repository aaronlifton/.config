local M = {}

-- Timer for periodic Aerospace monitoring
local aerospaceTimer = nil

-- Function to check if Aerospace is running
local function isAerospaceRunning()
  local app = hs.application.get("bobko.aerospace")
  return app ~= nil and app:isRunning()
end

-- Function to update Aerospace status
local function updateAerospaceStatus(C)
  local wasEnabled = C.aerospaceEnabled
  C.aerospaceEnabled = isAerospaceRunning()

  -- Log status changes
  if wasEnabled ~= C.aerospaceEnabled then
    if C.aerospaceEnabled then
      Logger.d("Aerospace detected as running - enabling Aerospace mode")
    else
      Logger.d("Aerospace no longer running - disabling Aerospace mode")
    end
  end
end

-- Application watcher for Aerospace
local aerospaceWatcher = nil

function M.initConfig(C)
  C.screenCount = #hs.screen.allScreens()

  -- Initial Aerospace status check
  C.aerospaceEnabled = isAerospaceRunning()
  Logger.d("Initial Aerospace status: " .. (C.aerospaceEnabled and "enabled" or "disabled"))

  -- Set up application watcher to monitor Aerospace launches/quits
  if aerospaceWatcher then aerospaceWatcher:stop() end

  aerospaceWatcher = hs.application.watcher.new(function(appName, eventType, appObject)
    -- Check if this is the Aerospace app
    if appObject and appObject:bundleID() == "bobko.aerospace" then
      if eventType == hs.application.watcher.launched then
        Logger.d("Aerospace launched - enabling Aerospace mode")
        C.aerospaceEnabled = true
      elseif eventType == hs.application.watcher.terminated then
        Logger.d("Aerospace terminated - disabling Aerospace mode")
        C.aerospaceEnabled = false
      end
    end
  end)

  aerospaceWatcher:start()

  -- Set up periodic timer as backup (checks every 30 seconds)
  if aerospaceTimer then aerospaceTimer:stop() end

  aerospaceTimer = hs.timer.doEvery(30, function()
    updateAerospaceStatus(C)
  end)

  Logger.d("Configurator initialized with Aerospace monitoring")
end

-- Cleanup function to stop watchers/timers
function M.cleanup()
  if aerospaceWatcher then
    aerospaceWatcher:stop()
    aerospaceWatcher = nil
  end

  if aerospaceTimer then
    aerospaceTimer:stop()
    aerospaceTimer = nil
  end

  Logger.d("Configurator cleanup completed")
end

return M

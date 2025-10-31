-- Test script for configurator.lua
-- This script tests the Aerospace detection functionality

local configurator = require("configurator")

-- Mock logger for testing
Logger = {
  d = function(msg)
    print("[DEBUG] " .. msg)
  end,
  w = function(msg)
    print("[WARNING] " .. msg)
  end,
  i = function(msg)
    print("[INFO] " .. msg)
  end,
  e = function(msg)
    print("[ERROR] " .. msg)
  end,
}

-- Test configuration object
local testConfig = {
  aerospaceEnabled = false,
  omarchyEnabled = false,
  screenCount = nil,
}

print("Testing Aerospace detection...")

-- Initialize the configurator
configurator.initConfig(testConfig)

print("Initial aerospaceEnabled:", testConfig.aerospaceEnabled)

-- Wait a moment and check again
print("Waiting 2 seconds and checking again...")
hs.timer.doAfter(2, function()
  print("Final aerospaceEnabled:", testConfig.aerospaceEnabled)

  -- Cleanup
  configurator.cleanup()
  print("Cleanup completed")
end)

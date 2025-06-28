-- Test script to verify the brew cache is working
local brewCache = require("functions.brew_cache")

print("Testing brew cache...")

-- First call (should create cache)
local start_time = os.clock()
local prefix1 = brewCache.get_brew_prefix()
local time1 = os.clock() - start_time
print("First call took: " .. time1 .. " seconds")
print("Prefix: " .. (prefix1 or "nil"))

-- Second call (should use cache)
start_time = os.clock()
local prefix2 = brewCache.get_brew_prefix()
local time2 = os.clock() - start_time
print("Second call took: " .. time2 .. " seconds")
print("Prefix: " .. (prefix2 or "nil"))

print("Cache is working if second call is significantly faster!")

-- Check cache file exists
local cache_file = hs.configdir .. "/.brew_prefix_cache"
local attr = hs.fs.attributes(cache_file)
if attr then
  print("Cache file exists at: " .. cache_file)
  print("Cache file size: " .. attr.size .. " bytes")
  print("Cache file modified: " .. os.date("%Y-%m-%d %H:%M:%S", attr.modification))
else
  print("Cache file not found!")
end

local M = {}

-- Cache file path
local cache_file = hs.configdir .. "/.brew_prefix_cache"

-- Function to read cache
local function read_cache()
  local file = io.open(cache_file, "r")
  if file then
    local content = file:read("*all")
    file:close()
    return content:gsub("%s+", "") -- Remove whitespace
  end
  return nil
end

-- Function to write cache
local function write_cache(prefix)
  local file = io.open(cache_file, "w")
  if file then
    file:write(prefix)
    file:close()
  end
end

-- Function to check if cache is valid (exists and is not too old)
local function is_cache_valid()
  local attr = hs.fs.attributes(cache_file)
  if not attr then
    return false
  end
  
  -- Check if cache is less than 24 hours old
  local cache_age = os.time() - attr.modification
  return cache_age < 86400 -- 24 hours in seconds
end

-- Main function to get brew prefix with caching
function M.get_brew_prefix()
  -- Try to read from cache first
  if is_cache_valid() then
    local cached_prefix = read_cache()
    if cached_prefix and cached_prefix ~= "" then
      return cached_prefix
    end
  end
  
  -- Cache miss or invalid, run brew command
  local brewPrefixOutput, _, _, _ = hs.execute("brew --prefix", true)
  
  if brewPrefixOutput then
    local brewPrefix = string.gsub(brewPrefixOutput, "%s+", "")
    -- Cache the result
    write_cache(brewPrefix)
    return brewPrefix
  end
  
  return nil
end

-- Function to invalidate cache (useful for testing or manual refresh)
function M.invalidate_cache()
  os.remove(cache_file)
end

return M


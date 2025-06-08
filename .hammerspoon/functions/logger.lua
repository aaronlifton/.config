local logger = hs.logger.new("init.lua", "debug")

local null_logger = {
  d = function(...) end,
  i = function(...) end,
  w = function(...) end,
  e = function(...) end,
  f = function(...) end,
}

-- Create a table to be returned by require
local returned_object = {
  -- Put the null_logger directly in this table
  null_logger = null_logger,
  -- We won't put the main logger here initially
}

-- Create a metatable
local meta = {
  -- When a key is not found in 'returned_object',
  -- the __index function is called.
  -- 't' is the table being indexed (returned_object)
  -- 'key' is the key being looked up (e.g., "d", "i", "w")
  __index = function(t, key)
    -- We return the value of that key from the *actual* logger object
    return logger[key]
  end,
}

-- Set the metatable on the table we will return
setmetatable(returned_object, meta)

-- Return the table with the metatable
return returned_object

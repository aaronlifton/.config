local M = {}

---@alias FKeyMap {number_key: string, f_key: string}

-- Add Function Key bindings using a loop
--- @type FKeyMap[]
local fkey_mappings = {
  { number_key = "1", f_key = "f1" },
  { number_key = "2", f_key = "f2" },
  { number_key = "3", f_key = "f3" },
  { number_key = "4", f_key = "f4" },
  { number_key = "5", f_key = "f5" },
  { number_key = "6", f_key = "f6" },
  { number_key = "7", f_key = "f7" },
  { number_key = "8", f_key = "f8" },
  { number_key = "9", f_key = "f9" },
  { number_key = "0", f_key = "f10" },
  { number_key = "-", f_key = "f11" },
  { number_key = "=", f_key = "f12" },
}

M.bindings = {}

-- Loop generated below the main table definition
for _, mapping in ipairs(fkey_mappings) do
  table.insert(M.bindings, {
    mod = K.mod.cmdShift,
    key = mapping.number_key,
    -- action = function() hs.eventtap.keyStroke({}, mapping.f_key) end -- Use pressDUR for tap
    action = function()
      hs.eventtap.keyStroke({}, mapping.f_key)
    end,
  })
end

return M

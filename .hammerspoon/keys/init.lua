local M = {}

M.bindings = {}

local key_files = {
  "chars",
  -- "function",
  "browser",
  "window",
  "util",
}

function M.bind()
  for _, key in ipairs(key_files) do
    ---@diagnostic disable-next-line: no-unknown
    local f = require("keys." .. key)
    if type(f.bind) == "function" then
      Logger.d(string.format("Found bind function for key: %s", key))
      f.bind()
    elseif type(f.bindings) == "table" then
      Logger.d(string.format("Found table bindings for key: %s", key))
      for _, binding in ipairs(f.bindings) do
        hs.hotkey.bind(binding.mod, binding.key, binding.action)
      end
    else
      error("Invalid key file: " .. key)
    end
  end
end

return M

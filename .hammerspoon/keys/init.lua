local M = {}

M.bindings = {}

local omarchyConflictedKeyFiles = {
  "window",
}

local key_files = {
  chars = true,
  ["function"] = true,
  browser = true,
  window = true,
  util = true,
}

if Config.useOmarchy then
  for _, key_file in pairs(omarchyConflictedKeyFiles) do
    key_files[key_file] = false
  end
end

function M.bind()
  for key, enabled in pairs(key_files) do
    if not enabled or key == "" then goto continue end

    -- Check if file exists before requiring
    local file_path = hs.configdir .. "/keys/" .. key .. ".lua"
    if not hs.fs.attributes(file_path) then
      Logger.w(string.format("Key file does not exist: %s", file_path))
      goto continue
    end

    -- Use pcall to safely require the module
    local success, f = pcall(require, "keys." .. key)
    if not success then
      Logger.e(string.format("Failed to load key file '%s': %s", key, f))
      goto continue
    end

    if type(f.bind) == "function" then
      Logger.d(string.format("Found bind function for key: %s", key))
      local bind_success, bind_error = pcall(f.bind)
      if not bind_success then Logger.e(string.format("Failed to bind keys for '%s': %s", key, bind_error)) end
    elseif type(f.bindings) == "table" then
      Logger.d(string.format("Found table bindings for key: %s", key))
      for _, binding in ipairs(f.bindings) do
        local hotkey_success, hotkey_error = pcall(hs.hotkey.bind, binding.mod, binding.key, binding.action)
        if not hotkey_success then Logger.e(string.format("Failed to bind hotkey for '%s': %s", key, hotkey_error)) end
      end
    else
      Logger.w(string.format("Invalid key file structure: %s (no bind function or bindings table)", key))
    end

    ::continue::
  end
end

return M

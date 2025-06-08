---@class ConfigWatcher
---@field watcher hs.pathwatcher
local ConfigWatcher = {}

---@param files string[]
local function reload_config(files)
  local should_reload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then should_reload = true end
  end
  if should_reload then hs.reload() end
end

ConfigWatcher.watcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reload_config)

function ConfigWatcher.watch_config_and_reload(self)
  self.watcher:start()
  hs.alert.show("Config loaded")
end

function ConfigWatcher.stop(self)
  self.watcher:stop()
  hs.alert.show("Config watcher stopped")
end

return ConfigWatcher

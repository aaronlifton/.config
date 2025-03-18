local Easing = {}
setmetatable(Easing, {})
Easing.__index = Easing

Easing.KEYFRAMES = {
  ANDROID = {
    { phase = 1.0, curl = 1.0 },
    { phase = 2.5, curl = 3.0 },
    { phase = 3.5, curl = 5.0 },
    { phase = 4, curl = 6 },
  },
}

function Easing.new(type, keyframes, opts)
  local self = setmetatable({}, Easing)
  self.type = type or "bezier"
  self.keyframes = keyframes
  self.steps = opts and opts.steps or 10
  return self
end

function Easing:bezierEaseInOut(t)
  return t < 0.5 and 4 * t ^ 3 or 1 - (-2 * t + 2) ^ 3 / 2
end

function Easing:lerp(a, b, t)
  return a + (b - a) * t
end

function Easing:generateConfigs(n, min_level, max_level)
  min_level = min_level or 1
  max_level = max_level or 4
  local configs = {}
  for i = 1, n do
    local t = (i - 1) / (n - 1)
    local level = min_level + math.floor((max_level - min_level) * t)
    local config = self:generateConfig(level)
    if config then configs[i] = config end
  end
  return configs
end

function Easing:generateConfig(level)
  if self.type == "bezier" then
    local t = (level - 1) / 3
    local easedT = self:bezierEaseInOut(t)
    return { phase = level * easedT, curl = level * easedT }
  elseif self.type == "linear" then
    return { phase = level, curl = level }
  elseif self.type == "android" then
    if not self.keyframes or #self.keyframes < 2 then return nil end
    local t = math.random()
    local i = math.floor(t * (#self.keyframes - 1)) + 1
    local k1, k2 = self.keyframes[i], self.keyframes[i + 1] or self.keyframes[#self.keyframes]
    return { phase = self:lerp(k1.phase, k2.phase, t), curl = self:lerp(k1.curl, k2.curl, t) }
  end
end

---@param config Easing
---@return Easing|nil
function Easing:setConfig(config)
  if not config then return end
  for k, v in pairs(config) do
    vim.g["neovide_cursor_vfx_particle_" .. k] = v
  end
  return config
end

--- @type table<string, {num_configs: number, frame_num: number}>
Easing.ConfigSetterDefaults = {
  bezier = { num_configs = 5, frame_num = 1 },
  linear = { num_configs = 2, frame_num = 1 },
  android = { num_configs = 3, frame_num = 1.0 },
}

---@alias EasingConfigSetter fun(n: number, frame: number):Easing|nil

for type, defaults in pairs(Easing.ConfigSetterDefaults) do
  ---@type EasingConfigSetter
  Easing[type] = function(n, frame)
    n = n or defaults.num_configs
    frame = frame or defaults.frame_num

    local instance = Easing.new(type, type == "android" and Easing.KEYFRAMES.ANDROID or nil)
    local configs = instance:generateConfigs(n)
    -- Use frame number to select config, defaulting to first frame
    local config_index = math.min(math.max(math.floor(frame), 1), #configs)
    return instance:setConfig(configs[config_index])
  end
end

return Easing

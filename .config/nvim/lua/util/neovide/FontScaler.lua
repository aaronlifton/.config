if not vim.g.neovide then return {} end

-- Initialize vim.g variables with defaults
vim.g.neovide_increment_scale_factor = vim.g.neovide_increment_scale_factor or 0.1
vim.g.neovide_min_scale_factor = vim.g.neovide_min_scale_factor or 0.7
vim.g.neovide_max_scale_factor = vim.g.neovide_max_scale_factor or 2.0
vim.g.neovide_initial_scale_factor = vim.g.neovide_scale_factor or 1
vim.g.neovide_scale_factor = vim.g.neovide_scale_factor or 1

---@param scale_factor number
---@return number
local function clamp_scale_factor(scale_factor)
  return math.max(math.min(scale_factor, vim.g.neovide_max_scale_factor), vim.g.neovide_min_scale_factor)
end

---@param scale_factor number
---@param clamp? boolean
local function set_scale_factor(scale_factor, clamp)
  vim.g.neovide_scale_factor = clamp and clamp_scale_factor(scale_factor) or scale_factor
end

local function reset_scale_factor()
  vim.g.neovide_scale_factor = vim.g.neovide_initial_scale_factor
end

---@param increment number
---@param clamp? boolean
local function change_scale_factor(increment, clamp)
  set_scale_factor(vim.g.neovide_scale_factor + increment, clamp)
end

---@param multiplier number
local function multiply_scale_factor(multiplier)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * multiplier
end

local FontScaler = {
  set = set_scale_factor,
  reset = reset_scale_factor,
  change = change_scale_factor,
  multiply = multiply_scale_factor,
  clamp = clamp_scale_factor,
}

return FontScaler

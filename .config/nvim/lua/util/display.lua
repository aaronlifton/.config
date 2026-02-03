---@class util.display
local M = {}

local SEP = "…"

-- Truncate path to max_width, preserving filename
-- Modes: "head" (truncate start), "middle" (truncate middle), "smart" (keep first + last dirs)
---@param path string
---@param max_width number
---@param mode? "head"|"middle"|"smart"
---@return string
function M.truncate_path(path, max_width, mode, sep)
  if #path <= max_width then return path end
  mode = mode or "smart"
  sep = sep or SEP

  local dir, filename = path:match("^(.*)/([^/]+)$")
  if not dir then return path:sub(1, max_width - 1) .. sep end

  -- Reserve space for filename + separator + ellipsis
  local available = max_width - #filename - 2 -- "…/"
  if available <= 0 then
    -- Filename alone is too long, truncate it
    return sep .. filename:sub(-(max_width - 1))
  end

  if mode == "head" then
    -- Truncate from start: …/rest/of/path/file.lua
    return sep .. dir:sub(-available) .. "/" .. filename
  elseif mode == "middle" then
    -- Truncate from middle: start/…/end/file.lua
    local half = math.floor(available / 2)
    local left = dir:sub(1, half)
    local right = dir:sub(-(available - half - 1))
    return left .. sep .. right .. "/" .. filename
  else -- "smart"
    -- Keep first directory and filename: first/…/file.lua
    local first_dir = dir:match("^([^/]+)")
    if first_dir and #first_dir + 3 < available then
      local rest_available = available - #first_dir - 2 -- "/…"
      local rest = dir:sub(#first_dir + 2) -- skip "first_dir/"
      if #rest > rest_available then rest = sep .. rest:sub(-rest_available + 1) end
      return first_dir .. "/" .. rest .. "/" .. filename
    else
      -- Fall back to head truncation
      return sep .. dir:sub(-available) .. "/" .. filename
    end
  end
end

return M

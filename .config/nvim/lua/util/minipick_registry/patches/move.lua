local M = {}

local applied = false

M.apply = function()
  if applied then return true end
  local ok_pick, MiniPick = pcall(require, "mini.pick")
  if not ok_pick or not MiniPick then return false end

  local _, H = debug.getupvalue(MiniPick.start, 1)
  if type(H) ~= "table" or type(H.actions) ~= "table" then return false end

  MiniPick.actions = setmetatable({}, { __index = H.actions })
  if not MiniPick._with_focus_lock then
    MiniPick._with_focus_lock = function(fn)
      if type(H.cache) ~= "table" then return fn() end
      local prev = H.cache.is_in_getcharstr
      H.cache.is_in_getcharstr = true
      local ok, result = pcall(fn)
      H.cache.is_in_getcharstr = prev
      if not ok then error(result) end
      return result
    end
  end

  applied = true
  return true
end

return M

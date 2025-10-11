---@class util.tabline.complete
local M = {}

---@param findstart number
---@param base string
---@private
function M.tab(findstart, base)
  if findstart == 1 then return 0 end

  local choices = { "Dev", "Test", "Doc", "AI", "Rails", "NPM" }
  local matches = {}

  -- If base is empty, return all choices
  if base == "" then return choices end

  -- Filter choices that match the base string (case-insensitive)
  base = base:lower()
  for _, choice in ipairs(choices) do
    if choice:lower():find(base, 1, true) == 1 then table.insert(matches, choice) end
  end

  return matches
end

return M

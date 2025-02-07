---@class util.bufferline.sort
local M = {}

M.category_sort = function(buf_a, buf_b)
  local function get_file_type(buf)
    local path = buf.path or ""
    if path:match("%.md$") or path:match("%.txt$") then
      return 3 -- docs
    elseif path:match("%_test") or path:match("%_spec") or path:match("%.snap$") then
      return 2 -- tests
    else
      return 1 -- regular files
    end
  end

  local type_a = get_file_type(buf_a)
  local type_b = get_file_type(buf_b)

  if type_a ~= type_b then return type_a < type_b end

  -- If files are of the same type, sort by buffer ID
  return buf_a.id < buf_b.id
end

return M

---@class util.system
local M = {}
local _cache = {}

---@return string|nil
function M.hostname()
  local f = io.popen("hostname")
  if not f then return nil end
  local hostname = f:read("*a")
  hostname = string.sub(hostname, 1, -2)
  f:close()
  return hostname
end

function M.user()
  return vim.fn.expand("$USER")
end

-- function M.tbl_slice(tbl, start_idx, end_idx)
--   local ret = {}
--   if not start_idx then start_idx = 1 end
--   if not end_idx then end_idx = #tbl end
--   for i = start_idx, end_idx do
--     table.insert(ret, tbl[i])
--   end
--   return ret
-- end
function M.update_lines(bufnr, original_lines, new_lines) end
function done()
  if not vim.api.nvim_buf_is_valid(bufnr) then
    log.info("Buffer become invalid while formatting, not applying formatting")
    return
  end

  local original_lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  -- M.update_lines(bufnr, input, output)
  require("conform.runner").apply_format(bufnr, input, output, false, false, false)
end

local Mcache = {}
setmetatable(Mcache, {
  __index = function(_, key)
    return function()
      if _cache[key] then
        return _cache[key]
      else
        _cache[key] = M[key]()
        return _cache[key]
      end
    end
  end,
})

return Mcache

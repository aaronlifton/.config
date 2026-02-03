local M = {}

M._state = {}

function M.get(key)
  if not M._state[key] then M._state[key] = {} end
  return M._state[key]
end

function M.reset(key, defaults)
  M._state[key] = vim.deepcopy(defaults or {})
  return M._state[key]
end

function M.clear(key)
  M._state[key] = nil
end

return M

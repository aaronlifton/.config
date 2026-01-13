---@class util.debug
local M = {}

M.state = {
  echoed = {},
  echoed_count = {},
}

function M.echo_once(x, desc, count)
  count = count or 0
  if count > 0 then
    if M.state.echoed_count[desc] == nil then M.state.echoed_count[desc] = 0 end
    M.state.echoed_count[desc] = M.state.echoed_count[desc] + 1
    if M.state.echoed_count[desc] < count then return end
  else
    if M.state.echoed[desc] then return end
  end

  vim.api.nvim_echo({
    { ("%s\n"):format(desc), "Title" },
    { vim.inspect(x), "Normal" },
  }, true, {})
  M.state.echoed[desc] = true
end

return M

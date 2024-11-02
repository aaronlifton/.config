--- Keys utils
---@class util.keys
---@field type_keys fun(keys: string, flags: string): nil
local M = {}

function M.type_keys(keys, flags)
  -- stylua: ignore
  vim.api.nvim_feedkeys(
    vim.api.nvim_replace_termcodes(keys, true, false, true),
    flags or 'x',
    false
  )
end

return M

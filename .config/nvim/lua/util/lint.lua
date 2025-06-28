---@class util.lint
---@field linters_by_ft table<string, string[]> A table mapping file types to their respective linters.
local M = {}

---
---@param tbl table
---@param opts PluginOpts
function M.add_linters(tbl, opts)
  for ft, linters in pairs(tbl) do
    if opts.linters_by_ft[ft] == nil then
      opts.linters_by_ft[ft] = linters
    else
      vim.list_extend(opts.linters_by_ft[ft], linters)
    end
  end
end

return M

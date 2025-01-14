---@class util.conform
local M = {}

---@param bufnr integer
---@param ... string
---@return string
function M.first(bufnr, ...)
  local conform = require("conform")
  for i = 1, select("#", ...) do
    local formatter = select(i, ...)
    if conform.get_formatter_info(formatter, bufnr).available then return formatter end
  end
  return select(1, ...)
end

--- Appends formatters for each filetype
---@param opts conform.setupOpts
---@param formatters_by_ft table<string, conform.FiletypeFormatter>
function M.add_formatters(opts, formatters_by_ft)
  for ft, formatters in pairs(formatters_by_ft) do
    if opts.formatters_by_ft[ft] == nil then
      opts.formatters_by_ft[ft] = formatters
    else
      if type(formatters) == "function" then formatters = formatters(0) end
      -- vim.list_extend(opts.formatters_by_ft[ft], formatters)
      for _, formatter in ipairs(formatters) do
        ---@diagnostic disable-next-line: param-type-mismatch
        table.insert(opts.formatters_by_ft[ft], formatter)
      end
      if formatters.stop_after_first ~= nil then
        opts.formatters_by_ft[ft].stop_after_first = formatters.stop_after_first
      end
    end
  end
end
return M

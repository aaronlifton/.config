local M = {}

M.add_formatters = function(opts, tbl)
  for ft, formatters in pairs(tbl) do
    if opts.formatters_by_ft[ft] == nil then
      opts.formatters_by_ft[ft] = formatters
    else
      vim.list_extend(opts.formatters_by_ft[ft], formatters)
    end
  end
end

M.add_linters = function(opts, tbl)
  for ft, linters in pairs(tbl) do
    if opts.linters_by_ft[ft] == nil then
      opts.linters_by_ft[ft] = linters
    else
      vim.list_extend(opts.linters_by_ft[ft], linters)
    end
  end
end

return M

---@class util.format
---@overload fun(): nil
local M = setmetatable({}, {
  __call = function(m, ...)
    return m.format(...)
  end,
})

-- Manually format with conform, when LSP formatter fails (e.g Ruby-LSP)
function M.format()
  local ft = vim.bo.filetype
  local bufnr = vim.api.nvim_get_current_buf()
  local formatters = {
    ruby = function(opts)
      M.rubocop(opts)
    end,
  }
  if formatters[ft] then
    formatters[ft]({ bufnr = bufnr })
  else
    vim.notify("No formatter found for " .. ft, vim.log.levels.ERROR, { title = "Util.format" })
  end
end

function M.rubocop(opts)
  local title = "Rubocop"
  local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
  ---@type string[]
  local formatters = { "rubocop" }

  require("conform").format({
    bufnr = bufnr,
    formatters = formatters,
    stop_after_first = true,
    -- async = false,
    lsp_format = "never",
  }, function(err, did_edit)
    if err then
      vim.notify("Error running formatter: " .. err, vim.log.levels.ERROR, { title = title })
      return
    end
    local result = did_edit and "edited" or "no changes"
    vim.notify("Formatter result: " .. result, vim.log.levels.INFO, { title = title })
  end)
end
return M

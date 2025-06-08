---@class util.lsp
---@field ruby util.lsp.ruby
local M = {}

function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, bufnr)
    end,
  })
end

function M.publish_to_ts_error_translator(err, result, ctx, config)
  require("ts-error-translator").translate_diagnostics(err, result, ctx, config)
  vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
end

return M

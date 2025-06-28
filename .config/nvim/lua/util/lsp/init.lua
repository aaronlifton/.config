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

---@param client_name string
---@param bufnr number|nil
---@return (boolean, vim.lsp.Client|nil)
function M.is_client_running(client_name, bufnr)
  bufnr = bufnr or 0
  local clients = vim.lsp.get_clients({ bufnr = bufnr, name = client_name })
  local client_attached = false
  if #clients > 0 then client_attached = true end
  local client = clients[1]

  local formatted_client_name = Util.string.first_to_upper(client.name)
  local is_str = client_attached and "is" or "is NOT"
  vim.notify(
    ("%s LSP %s attached to this buffer."):format(formatted_client_name, is_str),
    vim.log.levels.INFO,
    { title = "LSP Client Status" }
  )
  return client_attached, client
end

return M

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

--- Dedupe LSP location items by path:lnum
---@param items table[] LSP location items
---@return table[] Deduped items
function M.dedupe_by_location(items)
  local seen = {}
  local deduped = {}
  for _, item in ipairs(items) do
    local path = item.path or item.filename or ""
    local key = path .. ":" .. tostring(item.lnum or 1)
    if not seen[key] then
      seen[key] = true
      deduped[#deduped + 1] = item
    end
  end
  return deduped
end

--- Check if an LSP item matches the current cursor position
---@param item table LSP location item
---@param buf_id number|nil Buffer ID (defaults to current buffer)
---@return boolean
function M.item_matches_cursor(item, buf_id)
  buf_id = buf_id or vim.api.nvim_get_current_buf()
  local path = item.path or item.filename
  if path == nil then return false end

  local buf_path = vim.api.nvim_buf_get_name(buf_id)
  if buf_path == "" then return false end

  if vim.fn.fnamemodify(path, ":p") ~= vim.fn.fnamemodify(buf_path, ":p") then return false end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local lnum = item.lnum or 1
  local col = item.col or 1
  return cursor[1] == lnum and cursor[2] + 1 == col
end

--- Jump to an LSP location item
---@param item table LSP location item
function M.jump_to_location(item)
  local path = item.path or item.filename
  if path then
    vim.cmd("edit " .. vim.fn.fnameescape(path))
  end
  local lnum = item.lnum or 1
  local col = item.col or 1
  pcall(vim.api.nvim_win_set_cursor, 0, { lnum, col - 1 })
end

--- Create an on_list handler with auto-jump and dedupe behavior
---@param opts? { dedupe?: boolean, auto_jump?: boolean, scope?: string }
---@return fun(data: table)
function M.make_on_list(opts)
  opts = vim.tbl_extend("force", { dedupe = true, auto_jump = true }, opts or {})

  return function(data)
    local items = data.items or {}
    if #items == 0 then
      vim.notify("No locations found", vim.log.levels.INFO)
      return
    end

    -- Normalize items
    for _, item in ipairs(items) do
      item.path = item.path or item.filename
    end

    -- Dedupe by location
    if opts.dedupe then
      items = M.dedupe_by_location(items)
    end

    -- Auto-jump for single result
    if opts.auto_jump and #items == 1 then
      M.jump_to_location(items[1])
      return
    end

    -- For references: if 2 results and one is at cursor, jump to the other
    if opts.auto_jump and opts.scope == "references" and #items == 2 then
      local buf_id = vim.api.nvim_get_current_buf()
      if M.item_matches_cursor(items[1], buf_id) then
        M.jump_to_location(items[2])
        return
      end
      if M.item_matches_cursor(items[2], buf_id) then
        M.jump_to_location(items[1])
        return
      end
    end

    -- Fall back to quickfix list
    vim.fn.setqflist({}, " ", { title = data.title or "LSP Locations", items = items })
    vim.cmd("copen")
  end
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

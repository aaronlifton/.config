-- TODO: remove, since nvim 0.10.0 has been released
-- From https://github.com/Shopify/ruby-lsp/blob/main/EDITORS.md
-- textDocument/diagnostic support until 0.10.0 is released
---@class util.lsp.ruby
local M = {}
-- selene allow(global_usage)
-- _timers = {}
-- function M.setup_diagnostics(client, buffer)
--   if require("vim.lsp.diagnostic")._enable then
--     return
--   end
--
--   local diagnostic_handler = function()
--     local params = vim.lsp.util.make_text_document_params(buffer)
--     client.request("textDocument/diagnostic", { textDocument = params }, function(err, result)
--       if err then
--         local err_msg = string.format("diagnostics error - %s", vim.inspect(err))
--         vim.lsp.log.error(err_msg)
--       end
--       local diagnostic_items = {}
--       if result then
--         diagnostic_items = result.items
--       end
--       vim.lsp.diagnostic.on_publish_diagnostics(
--         nil,
--         vim.tbl_extend("keep", params, { diagnostics = diagnostic_items }),
--         { client_id = client.id }
--       )
--     end)
--   end
--
--   diagnostic_handler() -- to request diagnostics on buffer when first attaching
--
--   vim.api.nvim_buf_attach(buffer, false, {
--     on_lines = function()
--       if _timers[buffer] then
--         vim.fn.timer_stop(_timers[buffer])
--       end
--       _timers[buffer] = vim.fn.timer_start(200, diagnostic_handler)
--     end,
--     on_detach = function()
--       if _timers[buffer] then
--         vim.fn.timer_stop(_timers[buffer])
--       end
--     end,
--   })
-- end

-- M.on_attach = function(client, buffer)
--   M.setup_diagnostics(client, buffer)
--   M.add_ruby_deps_command(client, buffer)
-- end

-- require("lspconfig").ruby_lsp.setup({
--   on_attach = function(client, buffer)
--     add_ruby_deps_command(client, buffer)
--   end,
-- })
--
M.add_ruby_deps_command = function(client, bufnr)
  vim.api.nvim_buf_create_user_command(bufnr, "ShowRubyDeps", function(opts)
    local params = vim.lsp.util.make_text_document_params()
    local showAll = opts.args == "all"

    client.request("rubyLsp/workspace/dependencies", params, function(error, result)
      if error then
        print("Error showing deps: " .. error)
        return
      end

      local qf_list = {}
      for _, item in ipairs(result) do
        if showAll or item.dependency then
          table.insert(qf_list, {
            text = string.format("%s (%s) - %s", item.name, item.version, item.dependency),
            filename = item.path,
          })
        end
      end

      vim.fn.setqflist(qf_list)
      -- vim.cmd("copen")
      require("trouble").open({ mode = "quickfix", focus = false })
    end, bufnr)
  end, {
    nargs = "?",
    complete = function()
      return { "all" }
    end,
  })
end

M.solargraph_lsp_config = function()
  local solargraph = LazyVim.opts("nvim-lspconfig").servers.solargraph
  if vim.g.ruby_lsp_references_provider == "solargraph" then
    solargraph.enabled = true
    solargraph.settings = {
      solargraph = {
        completion = false,
        definitions = false,
        diagnostics = false,
        formatting = false,
        folding = false,
        hover = false,
        references = true,
        rename = false,
        symbols = false,
        useBundler = false,
      },
    }
  end
  return solargraph
end

return M

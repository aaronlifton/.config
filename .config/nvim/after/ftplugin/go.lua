-- local Util = require("lazyvim.util")
-- Util.toggle.inlay_hints(nil, false)

-- prevent buffer from enabling inlay hints
-- vim.api.nvim_create_autocmd({ "BufNewFile", "BufEnter", "BufWritePre" }, {
--   pattern = "*.go",
--   callback = function()
--     Util.toggle.inlay_hints(nil, false)
--   end,
-- })

-- LazyVim.lsp.on_attach(function(client, buffer)
--   if client.supports_method("textDocument/inlayHint") then
--     -- LazyVim.toggle.inlay_hints(buffer, false)
--     vim.defer_fn(function()
--       LazyVim.toggle.inlay_hints(buffer, false)
--     end, 100)
--   end
-- end)

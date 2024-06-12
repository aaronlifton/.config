local M = {}

M.echo = function(title, body)
  vim.api.nvim_echo({ { title, "Title" }, { vim.inspect(body), "String" } }, true, {})
end

return M

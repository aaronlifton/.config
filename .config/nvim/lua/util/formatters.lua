---@class util.formatters
local M = {}

M.biome_conditions = {
  biome_present = true,
  prettier_present = false,
  dprint_present = false,
}
M.prettier_settings = {
  ---@param ctx conform.Context
  markdown_file = function(ctx)
    return vim.fn.fnamemodify(ctx.filename, ":e") == "mdx"
  end,
  biome_present = true,
  prettier_present = false,
  dprint_present = false,
}

return M

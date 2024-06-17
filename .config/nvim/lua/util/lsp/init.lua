---@class util.lsp
---@field lua_library string[]
---@field ruby util.lsp.ruby
---@field nls util.lsp.nls
local M = {
  lua_library = require("util.lsp.lua_library"),
  ruby = require("util.lsp.ruby"),
  nls = require("util.lsp.nls"),
}

---@param tbl table<string, string[]>
M.add_formatters = function(opts, tbl)
  for ft, formatters in pairs(tbl) do
    if opts.formatters_by_ft[ft] == nil then
      opts.formatters_by_ft[ft] = formatters
    else
      vim.list_extend(opts.formatters_by_ft[ft], formatters)
    end
  end
end

---@param tbl table<string, string[]>
M.remove_formatters = function(opts, tbl)
  for ft, formatters in pairs(tbl) do
    if opts.formatters_by_ft[ft] ~= nil then
      for _, formatter in ipairs(formatters) do
        for i, f in ipairs(opts.formatters_by_ft[ft]) do
          if f == formatter then
            table.remove(opts.formatters_by_ft[ft], i)
          end
        end
      end
    end
  end
end

---@param tbl table<string, string[]>
M.set_formatters = function(opts, tbl)
  for ft, formatters in pairs(tbl) do
    opts.formatters_by_ft[ft] = formatters
  end
end

---@param tbl table<string, string[]>
M.add_linters = function(opts, tbl)
  for ft, linters in pairs(tbl) do
    if opts.linters_by_ft[ft] == nil then
      opts.linters_by_ft[ft] = linters
    else
      vim.list_extend(opts.linters_by_ft[ft], linters)
    end
  end
end

M.add_formatter_settings = function(opts, tbl)
  for formatter, settings in pairs(tbl) do
    if opts.formatters[formatter] == nil then
      opts.formatters[formatter] = settings
    else
      for setting, value in pairs(settings) do
        opts.formatters[formatter][setting] = value
      end
    end
  end
end

function M.on_attach(on_attach)
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      on_attach(client, bufnr)
    end,
  })
end

---@return string[]
function M.library()
  local runtime_paths = vim.api.nvim_get_runtime_file("", true)
  local library = {}
  for _, path in ipairs(runtime_paths) do
    -- add bob nightly runtime paths
    if string.match(path, "nvim-macos") then
      table.insert(library, path)
    end
  end
  table.insert(library, vim.fn.expand("~/.local/share/nvim/lazy/lazydev.nvim"))
  local additional_paths = require("util.lua_ls_library")
  for _, path in ipairs(additional_paths) do
    table.insert(library, path)
  end
  return library
end

-- local conform = require("conform")
---@param ctx conform.Context
---@return string
M.jsx_formatter = function(ctx)
  local dprint_filenames = { "dprint.json", ".dprint.json", "dprint.jsonc", ".dprint.jsonc" }
  local has_biome = vim.fs.find({ "biome.json" }, { path = ctx.filename, upward = true })[1]
  local has_dprint = vim.fs.find(dprint_filenames, { upward = true })[1]
  local has_prettier = vim.fs.find({ ".prettierrc.js" }, { upward = true })[1]
  local has_eslint = vim.fs.find({ ".eslintrc.js" }, { upward = true })[1]

  if ctx.filename:match(".astro") then
    return "dprint"
  elseif has_prettier and has_eslint then
    return "prettier"
  elseif has_biome and not has_dprint then
    return "biome"
  else
    return "dprint"
  end
end

function M.publish_to_ts_error_translator(err, result, ctx, config)
  require("ts-error-translator").translate_diagnostics(err, result, ctx, config)
  vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
end

return M

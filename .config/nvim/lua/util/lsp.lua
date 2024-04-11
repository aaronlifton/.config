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

---@param names string[]
---@return string[]
function M.get_plugin_paths(names)
  local plugins = require("lazy.core.config").plugins
  local paths = {}
  for _, name in ipairs(names) do
    if plugins[name] then
      table.insert(paths, plugins[name].dir .. "/lua")
    else
      vim.notify("Invalid plugin name: " .. name)
    end
  end
  return paths
end

---@param plugins string[]
---@return string[]
function M.library(plugins)
  local paths = M.get_plugin_paths(plugins)
  table.insert(paths, vim.fn.stdpath("config") .. "/lua")
  table.insert(paths, vim.env.VIMRUNTIME .. "/lua")
  table.insert(paths, "${3rd}/luv/library")
  table.insert(paths, "${3rd}/busted/library")
  table.insert(paths, "${3rd}/luassert/library")
  table.insert(paths, vim.fn.expand("~/.local/share/nvim/lazy/neodev.nvim/types/nightly"))
  table.insert(paths, vim.fn.expand("~/Code/nvim-plugins/leap.nvim/lua/"))
  return paths
end

return M

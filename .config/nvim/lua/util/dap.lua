--- Debug jest helper
---@class util.dap
local M = {}

M.debug_jest = function()
  local dap = require("dap")
  local util = require("dap.utils")
  -- filter for "node --inspect-brk"
  local ps = util.get_processes({ filter = "brk" })
  local proc = ps[1]
  if not proc then
    return
  end
  local providers = dap.providers
  local provider_keys = vim.tbl_keys(providers.configs)
  local all_configs = {}
  table.sort(provider_keys)
  local bufnr = 229 -- vim.fn.bufnr()
  for _, provider in ipairs(provider_keys) do
    local config_provider = providers.configs[provider]
    local configs = config_provider(bufnr)
    if vim.islist(configs) then
      vim.list_extend(all_configs, configs)
    end
  end
  local attach_config = vim.tbl_filter(function(config)
    return config.name == "Attach"
  end, all_configs)
  if attach_config[1] then
    dap.run(attach_config)
  end
  dap.attach()
end

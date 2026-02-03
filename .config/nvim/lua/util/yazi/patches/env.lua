local M = {}

M.patch_yazi = function()
  local Y = require("yazi")
  local prev = Y.yazi
  Y.yazi = function(config, input_path, args)
    if config and config.env then
      for k, v in pairs(config.env) do
        vim.env[k] = v
      end
    else
      vim.env.NVIM_FLOAT_WINDOW = nil
    end
    prev(config, input_path, args)
  end
end

return M

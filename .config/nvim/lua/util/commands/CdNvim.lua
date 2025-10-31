vim.api.nvim_create_user_command("CdNvim", function()
  local nvim_config_path = vim.fn.stdpath("config") --[[@as string]]
  vim.cmd("cd " .. nvim_config_path)
  vim.api.nvim_echo({ { "Changed directory to: ", "Normal" }, { nvim_config_path, "Directory" } }, false, {})
end, {})

-- bootstrap lazy.nvim, LazyVim and your plugins
-- require("pre-lazy")
vim.g.base46_cache = vim.fn.stdpath("data") .. "/nvchad/base46/"

require("config.lazy")

-- if vim.env.CURSOR then
--   require("util.cursor")
if vim.g.vscode then
  -- require("util.myvscode")
  vim.notify("Loading cursor settings", vim.log.levels.INFO)
  vim.api.nvim_echo({ { vim.inspect("Loading cursor settings"), "Normal" } }, true, {})
  require("util.cursor")
end
if vim.g.neovide then require("util.neovide") end

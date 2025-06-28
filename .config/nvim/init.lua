-- bootstrap lazy.nvim, LazyVim and your plugins
-- require("pre-lazy")
vim.g.base46_cache = vim.fn.stdpath("data") .. "/nvchad/base46/"

require("config.lazy")

if vim.env.CURSOR then
  require("util.cursor")
elseif vim.g.vscode then
  -- require("util.myvscode")
  require("util.cursor")
end
if vim.g.neovide then require("util.neovide") end

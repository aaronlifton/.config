-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
if vim.g.vscode then require("util.vscode") end

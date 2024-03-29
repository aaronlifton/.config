-- [nfnl] Compiled from plugins/fennel.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local util = require("lspconfig/util")
  return {fennel_language_server = {default_config = {cmd = "fennel-language-server", filetypes = {"fennel"}, root_dir = util.root_pattern("fnl"), single_file_support = true, settings = {fennel = {workspace = {}, diagnostics = {globals = "vim"}}}}}}
end
return {{"bakpakin/fennel.vim", lazy = true, ft = {"fennel"}}, {"neovim/nvim-lspconfig", opts = _1_}}

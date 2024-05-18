-- Options are automatically loaded before lazy.nvim startupoptions
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local o = vim.opt
local g = vim.g
local b = vim.b

---Get the full path to the LazyVim src dir
---@return string
function _G.get_lazyvim_base_dir()
  return "~/.local/share/nvim/lazy/LazyVim"
end
-- vim.cmd("set spell syntax=off")
-- vim.cmd("set nospell")

o.autoindent = true
o.breakindent = true
o.background = "dark"
o.backspace = { "eol", "start", "indent" }
-- o.breakindent = true
o.clipboard:append({ "unnamed", "unnamedplus" })
o.fillchars = { eob = " " }
o.spellfile = "/Users/aaron/.config/nvim/spell/en.utf-8.add"
o.spelllang = "en_us" -- "en"
o.sps = "file:/Users/aaron/.config/nvim/spell/sugg,best"
o.startofline = true
o.swapfile = false
o.textwidth = 80
o.termguicolors = trueoptions
-- o.formatoptions = "jcrqlnt" -- "jcroqlnt" -- tcqj
-- o.colorcolumn = "80"

-- g.gui_font_face = "Hack Nerd Font Mono"
-- g.gui_font_face = "FiraCode Nerd Font"
-- g.gui_font_face = "MesloLGLDZ Nerd Font Mono"
-- g.gui_font_face = "MonaLisa Nerd Font Mono"
g.gui_font_face = "Sauce Code Pro Nerd Font Mono"
g.gui_font_size = 18
g.custom_notifications = {}
-------------------------------------------------

-- vim.env.XDG_CACHE_HOME = vim.env.XDG_CACHE_HOME or vim.env.HOME .. "/.cache"
-- vim.env.XDG_CONFIG_HOME = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config"
-- vim.env.XDG_DATA_HOME = vim.env.XDG_DATA_HOME or vim.env.HOME .. "/.local/share"

require("config.highlights").setup()
require("config.neovide")
-- require("vendor.colorschemes.aurora").colorscheme()

-- suppress error messages from lang servers
-- vim.notify = function(msg, log_level, _)
--   if msg:match("exit code") then
--     return
--   elseif msg:match("typed: false") then -- handle sorbet errors
--     return
--   end
--   if log_level == vim.log.levels.ERROR then
--     vim.api.nvim_err_writeln(msg)
--   else
--     vim.api.nvim_echo({ { msg } }, true, {})
--   end
-- end

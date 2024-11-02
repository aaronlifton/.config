-- Options are automatically loaded before lazy.nvim startupoptions
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local o = vim.opt
local g = vim.g
local config_path = vim.fn.stdpath("config")

---Get the full path to the LazyVim src dir
---@return string
function _G.get_lazyvim_base_dir()
  return "~/.local/share/nvim/lazy/LazyVim"
end
o.autoindent = true
o.breakindent = true
-- o.background = "dark"
o.backspace = { "eol", "start", "indent" }
-- o.breakindent = true
-- o.clipboard:append({ "unnamed", "unnamedplus" })
o.fillchars = { eob = " " }
o.spellfile = config_path .. "/spell/en.utf-8.add"
o.spelllang = "en_us" -- "en"
o.sps = "file:" .. config_path .. "/spell/sugg,best"
o.startofline = true
o.swapfile = false
o.textwidth = 80
o.termguicolors = true
o.shell = "fish"
-- o.formatoptions = "jcrqlnt" -- "jcroqlnt" -- tcqj
-- o.colorcolumn = "80"

-- g.gui_font_face = "Hack Nerd Font Mono"
-- g.gui_font_face = "FiraCode Nerd Font"
-- g.gui_font_face = "MesloLGLDZ Nerd Font Mono"
-- g.gui_font_face = "MonaLisa Nerd Font Mono"
g.lazyvim_picker = "fzf" -- telescope
g.cmp_widths = { abbr = 80, menu = 30 }
g.gui_font_face = "Sauce Code Pro Nerd Font Mono"
g.gui_font_size = 18
g.lsp_goto_source = "fzf" -- glance
-- g.lazyvim_ruby_lsp = "solargraph"
g.lazyvim_ruby_lsp = "ruby_lsp"
g.lazyvim_ruby_formatter = "rubocop"
g.ruby_lsp_references_provider = "solargraph"
g.lazyvim_prettier_needs_config = true
g.copilot_ghost_text = false
g.codeium_ghost_text = false
g.highlight_provider = "nvim-highlight-colors" -- "mini.hipatterns"
g.markdown_previewer = "markdown-preview" -- "peek"
g.animation_provider = "cinnamon" -- "mini.animate"
g.icon_size = "normal" -- "small"
g.enable_secondary_ruby_linter = false
-------------------------------------------------

-- vim.env.XDG_CACHE_HOME = vim.env.XDG_CACHE_HOME or vim.env.HOME .. "/.cache"
-- vim.env.XDG_CONFIG_HOME = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config"
-- vim.env.XDG_DATA_HOME = vim.env.XDG_DATA_HOME or vim.env.HOME .. "/.local/share"

-- require("config.neovide")

if vim.fn.executable("nvr") == 1 then
  vim.env["GIT_EDITOR"] = "nvr -cc close -cc vsplit --remote-wait +'set bufhidden=wipe'"
end

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
--

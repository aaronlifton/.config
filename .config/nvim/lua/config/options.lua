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

-- Fix for https://github.com/neovim/neovim/issues/31675
vim.hl = vim.highlight

-- o.autoindent = true -- LazyVim uses smartindent instead
-- o.breakindent = true
o.backspace = { "eol", "start", "indent" }
-- o.clipboard:append({ "unnamed", "unnamedplus" })
o.spellfile = config_path .. "/spell/en.utf-8.add"
o.spelllang = "en_us" -- "en_us", "en"
o.sps = "file:" .. config_path .. "/spell/sugg,best"
-- o.startofline = true
o.swapfile = false
o.textwidth = 80
o.shell = "fish"

-- Disable annoying cmd line stuff
-- o.showcmd = false
-- o.cmdheight = 0

-- o.formatoptions = "jcrqlnt" -- "jcroqlnt" -- tcqj
-- o.colorcolumn = "80"

-- g.gui_font_face = "Hack Nerd Font Mono"
-- g.gui_font_face = "FiraCode Nerd Font"
-- g.gui_font_face = "MesloLGLDZ Nerd Font Mono"
-- g.gui_font_face = "MonaLisa Nerd Font Mono"
g.gui_font_face = "Sauce Code Pro Nerd Font Mono"
g.gui_font_size = 18

g.lazyvim_picker = "fzf"
-- g.lazyvim_picker = "telescope" -- for testing plugins
g.cmp_widths = { abbr = 80, menu = 30 }
g.lsp_goto_source = "fzf" -- "fzf", "glance"
g.lualine_info_extras = true
g.lazyvim_cmp = "nvim-cmp" -- "nvim-cmp", "blink.cmp"
-- g.lazyvim_cmp = "blink.cmp"
g.lazyvim_ruby_lsp = "ruby_lsp" -- "ruby_lsp", "solargraph"
g.lazyvim_ruby_formatter = "rubocop"
g.lazyvim_eslint_auto_format = true
g.lazyvim_prettier_needs_config = false
-- if the completion engine supports the AI source,
-- use that instead of inline suggestions
g.ai_cmp = true
g.codeium_cmp_hide = false
g.ai_accept_word_provider = "supermaven"
g.highlight_provider = "nvim-highlight-colors" -- "nvim-highlight-colors", "mini.hipatterns"
g.markdown_previewer = "markdown-preview" -- "markdown-preview", "peek"
g.smooth_scroll_provider = "snacks" -- "cinnamon", mini.animate", "snacks"
g.icon_size = "normal" -- "normal", "small"
g.dprint_needs_config = true
-------------------------------------------------

-- vim.env.XDG_CACHE_HOME = vim.env.XDG_CACHE_HOME or vim.env.HOME .. "/.cache"
-- vim.env.XDG_CONFIG_HOME = vim.env.XDG_CONFIG_HOME or vim.env.HOME .. "/.config"
-- vim.env.XDG_DATA_HOME = vim.env.XDG_DATA_HOME or vim.env.HOME .. "/.local/share"

-- require("config.neovide")

-- Install via `pip install neovim-remote`
if vim.fn.executable("nvr") == 1 then
  vim.env["GIT_EDITOR"] = "nvr -cc close -cc vsplit +'setl bufhidden=delete'"
  -- vim.env["GIT_EDITOR"] = "nvr -cc close -cc vsplit --remote-wait +'setl bufhidden=delete'"
  -- vim.env["GIT_EDITOR"] = "nvr --nostart --remote-tab-wait +'set bufhidden=delete'"
end

-- Options are automatically loaded before lazy.nvim startupoptions
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local env = vim.env
local o = vim.opt
local g = vim.g
local config_path = vim.fn.stdpath("config")

---Get the full path to the LazyVim src dir
---@return string
function _G.get_lazyvim_base_dir()
  return "~/.local/share/nvim/lazy/LazyVim"
end

---Get the parent directory of the LazyVim base dir
---@return string
function _G.get_lazyvim_plugins_dir()
  return vim.fn.fnamemodify(get_lazyvim_base_dir(), ":h")
end

-- Fix for https://github.com/neovim/neovim/issues/31675
vim.hl = vim.highlight

o.shell = "fish"
o.spell = false
o.spelllang:append("en_us")
o.spellfile = config_path .. "/spell/en.utf-8.add"
-- o.startofline = true
-- o.swapfile = true -- Needed for `recover` and `undo`
o.sps = "file:" .. config_path .. "/spell/sugg,best"
o.swapfile = false -- This must be set to true `recover` and `undo`
o.textwidth = 80
-- o.winborder = "rounded"
-- o.colorcolumn = "80"

-- Disable annoying cmd line stuff
o.showcmd = false
o.laststatus = 3
o.cmdheight = 0

-- Disable mouse
-- o.mouse = ""

-- LazyVim default:
-- o.formatoptions = "jcroqlnt" -- tcqj

-- Remove 'o':
-- TODO: when LazyVim dependency is removed
-- o.formatoptions = "jcrqlnt"
-- vim.opt.formatoptions:remove({ "o" })
-------------------------------------------------

-- Custom global options
g.lsp_goto_source = "fzf" -- "fzf", "glance"
g.lualine_info_extras = true
g.codeium_cmp_hide = false
g.highlight_provider = "mini.hipatterns" -- "nvim-highlight-colors", "mini.hipatterns"
g.markdown_previewer = "markdown-preview" -- "markdown-preview", "peek"
g.smooth_scroll_provider = "snacks" -- "cinnamon", mini.animate", "snacks"
g.dprint_needs_config = true
-- g.lazyvim_picker = "fzf" -- Already enabled by LazyVim fzf extra
-- g.lazyvim_picker = "telescope" -- for testing plugins

-------------------------------------------------

-- Lazyvim options
-- g.lazyvim_cmp = "nvim-cmp" -- "nvim-cmp", "blink.cmp"
g.lazyvim_cmp = "blink.cmp"
g.cmp_widths = { abbr = 80, menu = 30 }
g.lazyvim_ruby_lsp = "ruby_lsp" -- "ruby_lsp", "solargraph"
g.lazyvim_ruby_formatter = "rubocop"
g.lazyvim_eslint_auto_format = true
g.lazyvim_prettier_needs_config = true
g.ai_cmp = true
g.icon_size = "normal" -- "normal", "small"
g.editorconfig = true
-------------------------------------------------

-- MiniPick
g.minipick_ts_highlight = true
-- g.minipick_max_ts_items = 200
g.minipick_path_max_width = 40
g.minipick_path_truncate_mode = "smart"
g.minipick_ff_path_max_width = nil
-- g.minipick_ff_path_trunate_mode = "head"
-- g.minipick_path_max_width = number (default: nil, no truncation)
-- g.minipick_path_truncate_mode = "head"|"middle"|"smart" (default: "smart")

-------------------------------------------------

-- Linux paths
env.XDG_CACHE_HOME = env.XDG_CACHE_HOME or env.HOME .. "/.cache"
env.XDG_CONFIG_HOME = env.XDG_CONFIG_HOME or env.HOME .. "/.config"
env.XDG_DATA_HOME = env.XDG_DATA_HOME or env.HOME .. "/.local/share"
env.XDG_STATE_HOME = env.XDG_STATE_HOME or env.HOME .. "/.local/state"

-- Install via `pip install neovim-remote`
if vim.fn.executable("nvr") == 1 then
  env["GIT_EDITOR"] = "nvr -cc close -cc vsplit +'setl bufhidden=delete'"
  -- env["GIT_EDITOR"] = "nvr -cc close -cc vsplit --remote-wait +'setl bufhidden=delete'"
  -- env["GIT_EDITOR"] = "nvr --nostart --remote-tab-wait +'set bufhidden=delete'"
end

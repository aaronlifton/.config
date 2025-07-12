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

---Get the parent directory of the LazyVim base dir
---@return string
function _G.get_lazyvim_plugins_dir()
  return vim.fn.fnamemodify(get_lazyvim_base_dir(), ":h")
end

-- Fix for https://github.com/neovim/neovim/issues/31675
vim.hl = vim.highlight

o.autowrite = true -- Enable auto write
-- only set clipboard if not in ssh, to make sure the OSC 52
-- integration works automatically. Requires Neovim >= 0.10.0
o.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
o.completeopt = "menu,menuone,noselect"
o.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
o.confirm = true -- Confirm to save changes before exiting modified buffer
o.cursorline = true -- Enable highlighting of the current line
o.expandtab = true -- Use spaces instead of tabs
o.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
o.foldlevel = 99
o.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
o.formatoptions = "jcroqlnt" -- tcqj
o.grepformat = "%f:%l:%c:%m"
o.grepprg = "rg --vimgrep"
o.ignorecase = true -- Ignore case
o.inccommand = "nosplit" -- preview incremental substitute
o.jumpoptions = "view"
o.laststatus = 3 -- global statusline
o.linebreak = true -- Wrap lines at convenient points
o.list = true -- Show some invisible characters (tabs...
o.mouse = "a" -- Enable mouse mode
o.number = true -- Print line number
o.pumblend = 10 -- Popup blend
o.pumheight = 10 -- Maximum number of entries in a popup
o.relativenumber = true -- Relative line numbers
o.ruler = false -- Disable the default ruler
o.scrolloff = 4 -- Lines of context
o.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
o.shiftround = true -- Round indent
o.shiftwidth = 2 -- Size of an indent
o.shortmess:append({ W = true, I = true, c = true, C = true })
o.showmode = false -- Dont show mode since we have a statusline
o.sidescrolloff = 8 -- Columns of context
o.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
o.smartcase = true -- Don't ignore case with capitals
o.smartindent = true -- Insert indents automatically
o.spelllang = { "en" }
o.splitbelow = true -- Put new windows below current
o.splitkeep = "screen"
o.splitright = true -- Put new windows right of current
o.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
o.tabstop = 2 -- Number of spaces tabs count for
o.termguicolors = true -- True color support
o.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
o.undofile = true
o.undolevels = 10000
o.updatetime = 200 -- Save swap file and trigger CursorHold
o.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
o.wildmode = "longest:full,full" -- Command-line completion mode
o.winminwidth = 5 -- Minimum window width
o.wrap = false -- Disable line wrap

if vim.fn.has("nvim-0.10") == 1 then
  o.smoothscroll = true
  o.foldexpr = "v:lua.require'lazyvim.util'.ui.foldexpr()"
  o.foldmethod = "expr"
  o.foldtext = ""
else
  o.foldmethod = "indent"
  o.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
-- o.autoindent = true -- LazyVim uses smartindent instead
-- o.breakindent = true
o.backspace = { "eol", "start", "indent" }
-- o.clipboard:append({ "unnamed", "unnamedplus" })
o.spellfile = config_path .. "/spell/en.utf-8.add"
o.spelllang = "en_us" -- "en_us", "en"
o.sps = "file:" .. config_path .. "/spell/sugg,best"
-- o.startofline = true
o.swapfile = false
-- o.swapfile = true -- Needed for `recover` and `undo`
o.textwidth = 80
o.shell = "fish"
-- o.winborder = "rounded"

-- Disable annoying cmd line stuff
-- o.showcmd = false
-- o.cmdheight = 0

-- o.formatoptions = "jcrqlnt" -- "jcroqlnt" -- tcqj
-- o.colorcolumn = "80"

-- g.gui_font_face = "Hack Nerd Font Mono"
-- g.gui_font_face = "FiraCode Nerd Font"
-- g.gui_font_face = "MesloLGLDZ Nerd Font Mono"
-- g.gui_font_face = "MonaLisa Nerd Font Mono"
-- g.gui_font_face = "Sauce Code Pro Nerd Font Mono"
-- g.gui_font_size = 18

-- g.lazyvim_picker = "fzf" -- Already enabled by LazyVim fzf extra
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
g.highlight_provider = "mini.hipatterns" -- "nvim-highlight-colors", "mini.hipatterns"
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

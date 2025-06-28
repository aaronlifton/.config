-- [[ Setting options ]]
-- See `:help o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`
local o = vim.opt
local g = vim.g
local config_path = vim.fn.stdpath("config")

--- lazyvim
o.autowrite = true -- Enable auto write
o.completeopt = "menu,menuone,noselect"
o.conceallevel = 2 -- Hide * markup for bold and italic, but not markers with substitutions
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
-- o.inccommand = "nosplit" -- preview incremental substitute
o.jumpoptions = "view"
o.laststatus = 3 -- global statusline
o.linebreak = true -- Wrap lines at convenient points
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
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
o.ignorecase = true -- Ignore case
o.smartcase = true -- Don't ignore case with capitals
o.smartindent = true -- Insert indents automatically
o.splitbelow = true -- Put new windows below current
o.splitkeep = "screen"
o.splitright = true -- Put new windows right of current
-- Moved to autocmds
-- o.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
o.tabstop = 2 -- Number of spaces tabs count for
o.termguicolors = true -- True color support
o.timeoutlen = vim.g.vscode and 1000 or 300 -- Lower than default (1000) to quickly trigger which-key
o.undofile = true
o.undolevels = 10000
o.updatetime = 200 -- Save swap file and trigger CursorHold
o.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
o.wildmode = "longest:full,full" -- Command-line completion mode
o.winminwidth = 5 -- Minimum window width
o.wrap = false

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
--- end
---
-- Fix for https://github.com/neovim/neovim/issues/31675
vim.hl = vim.highlight

-- Make line numbers default
o.number = true

-- Enable mouse mode, can be useful for resizing splits for example!
o.mouse = "a"

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  -- only set clipboard if not in ssh, to make sure the OSC 52
  -- integration works automatically. Requires Neovim >= 0.10.0
  -- o.clipboard = vim.env.SSH_TTY and "" or "unnamedplus" -- Sync with system clipboard
  o.clipboard = "unnamedplus"
end)

-- Enable break indent
o.breakindent = true

-- Keep signcolumn on by default
o.signcolumn = "yes"

-- Decrease update time
o.updatetime = 250

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `opt` instead of `vim.o`.
--  It is very similar to `o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
o.inccommand = "split"

-- Show which line your cursor is on
o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
-- o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
o.confirm = true

o.spellfile = config_path .. "/spell/en.utf-8.add"
o.spelllang = "en_us" -- "en_us", "en"
o.sps = "file:" .. config_path .. "/spell/sugg,best"
-- o.startofline = true
o.swapfile = false
o.textwidth = 80
o.shell = "fish"

g.lsp_goto_source = "fzf" -- "fzf", "glance"
g.lualine_info_extras = true
g.lazyvim_cmp = "nvim-cmp" -- "nvim-cmp", "blink.cmp"
g.lazyvim_ruby_lsp = "ruby_lsp" -- "ruby_lsp", "solargraph"
g.lazyvim_ruby_formatter = "rubocop"
g.lazyvim_eslint_auto_format = true
g.lazyvim_prettier_needs_config = false
-- if the completion engine supports the AI source,
-- use that instead of inline suggestions
-- g.ai_cmp = true
-- vim: ts=2 sts=2 sw=2 et

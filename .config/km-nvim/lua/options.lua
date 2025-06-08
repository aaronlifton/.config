-- [[ Setting options ]]
-- See `:help o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`
local o = vim.opt
local g = vim.g
local config_path = vim.fn.stdpath("config")

-- Fix for https://github.com/neovim/neovim/issues/31675
vim.hl = vim.highlight

-- Make line numbers default
o.number = true
-- You can also add relative line numbers, to help with jumping.
--  Experiment for yourself to see if you like it!
-- o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
o.mouse = "a"

-- Don't show the mode, since it's already in the status line
o.showmode = false

-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  o.clipboard = "unnamedplus"
end)

-- Enable break indent
o.breakindent = true

-- Save undo history
o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
o.ignorecase = true
o.smartcase = true

-- Keep signcolumn on by default
o.signcolumn = "yes"

-- Decrease update time
o.updatetime = 250

-- Decrease mapped sequence wait time
o.timeoutlen = 300

-- Configure how new splits should be opened
o.splitright = true
o.splitbelow = true

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
o.scrolloff = 10

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
o.tabstop = 2
o.shell = "fish"

o.shortmess:append({ W = true, I = true, c = true, C = true })
o.showmode = false -- Dont show mode since we have a statusline
o.sidescrolloff = 8 -- Columns of context
o.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
o.smartcase = true -- Don't ignore case with capitals
o.smartindent = true -- Insert indents automatically
o.spelllang = { "en" }

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

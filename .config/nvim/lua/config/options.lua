local Util = require("lazyvim.util")
-- Options are automatically loaded
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
--                                                                                                                                                                                            uuuuuuuybbbbbbbbb

-- vim.api.nvim_set_option("spelllang", "en_us")
-- vim.api.nvim_set_option("spell", true)

local opt = vim.opt

-- Optimizations on startup
vim.loader.enable()

vim.opt.spelllang = "en_us"
vim.opt.spell = false
vim.opt.sps = "file:/Users/aaron/.config/nvim/spell/sugg,best"
-- use a file for spell suggestions
vim.opt.spellfile = "/Users/aaron/.config/nvim/spell/en.utf-8.add"
vim.cmd("set spell syntax=off")
vim.cmd("set nospell")

vim.opt.mouse = "a"
vim.opt.clipboard:append({ "unnamed", "unnamedplus" })
-- vim.opt.termgui_colors = 256
vim.opt.background = "dark"
vim.opt.textwidth = 80

-- opt.foldtext = "v:lua.custom_fold_text()"
-- -- foldtext is now ufo
-- vim.opt.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
-- vim.opt.foldenable = false
vim.opt.startofline = true

-- Make Vim open and close folded text as needed because I can't be bothered to
-- do so myself and wouldn't use text folding at all if it wasn't automatic.
-- vim.opt.foldmethod = "marker"
-- vim.opt.foldopen = "all, insert"
-- vim.opt.foldclose = "all"
-- vim.opt.foldenable = false

-- This works
-- vim.opt.foldmethod = "manual"
-- vim.opt.foldexpr = "0"
-- vim.opt.foldlevel = 0
-- vim.opt.foldtext = "foldtext()"

vim.opt.swapfile = false

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
-- Default splitting will cause your main splits to jump when opening an edgebar.
-- To prevent this, set `splitkeep` to either `screen` or `topline`.
vim.opt.splitkeep = "screen"

-- Minimal setup
-- vim.opt.showcmd = false
-- vim.opt.laststatus = 0
-- vim.opt.cmdheight = 0

-- Backspacing and indentation when wrapping
vim.opt.backspace = { "eol", "start", "indent" }
vim.opt.breakindent = true

vim.api.nvim_set_hl(0, "LeapBackdrop", { link = "Comment" })

-- Defaults
-- vim.g.mapleader = " "
-- vim.g.maplocalleader = "\\"

vim.g.material_style = "darker"
vim.g.disable_leap_secondary_labels = false
vim.g.enable_leap_lightspeed_mode = false
vim.g.astro_typescript = "enable"
vim.g["denops#deno"] = "/Users/aaron/.deno/bin/deno"
vim.g.native_snippets_enabled = false
vim.g.multiplexer = "wez" -- tmux
vim.g.pairs_plugin = "mini.pairs"
vim.g.outline_plugin = "outline.nvim"
vim.g.replace_typescript_ls = false
vim.g.gui_font_face = "Hack Nerd Font Mono"
vim.g.gui_font_size = 18
vim.g.editorconfig = true

-- Disable some repl providers
for _, provider in ipairs({ "perl", "python3" }) do
  vim.g["loaded_" .. provider .. "_provider"] = 0
end

---Get the full path to the LazyVim src dir
---@return string
function _G.get_lazyvim_base_dir()
  return "~/.local/share/nvim/lazy/LazyVim"
end

vim.opt.runtimepath:append("~/Code/nvim-plugins/denops-getting-started")
vim.opt.runtimepath:append("~/Code/nvim-plugins/denops-helloworld.nvim")

vim.cmd("let $NVIM_TUI_ENALE_TRUE_COLOR=1")

-- Color fix
-- "Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
-- "If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
-- "(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if Util.has("nvim") then
  -- "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
  vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1
end
-- "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
-- "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
-- github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
if Util.has("termguicolors") then
  vim.opt.termguicolors = true
end

vim.commentstring = ""

-- create_autocmd({ 'BufEnter', 'BufNewFile' }, {
--   pattern = '.env*',
--   command = 'set filetype=conf',
-- })

-- require("mini.starter").open()

vim.g.root_spec = {
  "lsp",
  { ".git", "lua", ".obsidian", "package.json", "Makefile", "go.mod", "cargo.toml", "pyproject.toml", "src" },
  "cwd",
}
vim.g.autoformat = true -- globally
vim.b.autoformat = true -- buffer-local

vim.g.is_original_codelens_refresh = true
-- vim.lsp.inlay_hint.enable(0, false)
-- Fix inlay-hint auto-re-enabling bug
-- LazyVim.toggle.inlay_hints = function(buffer, enabled)
--   return false
-- end
-- function M.inlay_hints(buf, value)
--   local ih = vim.lsp.buf.inlay_hint or vim.lsp.inlay_hint
--   if type(ih) == "function" then
--     ih(buf, value)
--   elseif type(ih) == "table" and ih.enable then
--     if value == nil then
--       value = not ih.is_enabled(buf)
--     end
--     ih.enable(buf, value)
--   end
-- end
--

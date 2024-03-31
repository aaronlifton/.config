local Util = require("lazyvim.util")
local o = vim.opt
local g = vim.g
local b = vim.b

-- Optimizations on startup
-- vim.loader.enable()

-- vim.api.nvim_set_option("spelllang", "en_us")
-- vim.api.nvim_set_option("spell", true)
vim.cmd("set spell syntax=off")
vim.cmd("set nospell")

o.background = "dark"
o.backspace = { "eol", "start", "indent" }
o.breakindent = true
o.clipboard:append({ "unnamed", "unnamedplus" })
o.spell = false
o.spellfile = "/Users/aaron/.config/nvim/spell/en.utf-8.add"
o.spelllang = "en_us" -- "en"
o.sps = "file:/Users/aaron/.config/nvim/spell/sugg,best"
o.startofline = true
o.swapfile = false
o.textwidth = 80

g.material_style = "darker"
g.disable_leap_secondary_labels = false
g.enable_leap_lightspeed_mode = false
g.astro_typescript = "enable"
g["denops#deno"] = "/Users/aaron/.deno/bin/deno"
g.native_snippets_enabled = false
g.multiplexer = "wez" -- tmux
g.pairs_plugin = "mini.pairs"
g.outline_plugin = "outline.nvim"
g.replace_typescript_ls = false
g.gui_font_face = "Hack Nerd Font Mono"
g.gui_font_size = 18
g.editorconfig = true
g.root_spec = {
  "lsp",
  { ".git", "lua", ".obsidian", "package.json", "Makefile", "go.mod", "cargo.toml", "pyproject.toml", "src" },
  "cwd",
}
g.autoformat = true -- globally
b.autoformat = true -- buffer-local
-- opt.foldtext = "v:lua.custom_fold_text()"
-- -- foldtext is now ufo
-- o.foldtext = "v:lua.require'lazyvim.util'.ui.foldtext()"
-- o.foldmethod = "expr"
-- o.foldexpr = "nvim_treesitter#foldexpr()"
-- o.foldenable = false

-- Make Vim open and close folded text as needed because I can't be bothered to
-- do so myself and wouldn't use text folding at all if it wasn't automatic.
-- o.foldmethod = "marker"
-- o.foldopen = "all, insert"
-- o.foldclose = "all"
-- o.foldenable = false

-- This works
-- o.foldmethod = "manual"
-- o.foldexpr = "0"
-- o.foldlevel = 0
-- o.foldtext = "foldtext()"

-- views can only be fully collapsed with the global statusline
-- o.laststatus = 3
-- Default splitting will cause your main splits to jump when opening an edgebar.
-- To prevent this, set `splitkeep` to either `screen` or `topline`.
-- o.splitkeep = "screen"

-- Minimal setup
-- o.showcmd = false
-- o.laststatus = 0
-- o.cmdheight = 0

-- Backspacing and indentation when wrapping

-- Defaults
-- g.mapleader = " "
-- g.maplocalleader = "\\"

-- Disable some repl providers
for _, provider in ipairs({ "perl", "python3" }) do
  g["loaded_" .. provider .. "_provider"] = 0
end

---Get the full path to the LazyVim src dir
---@return string
function _G.get_lazyvim_base_dir()
  return "~/.local/share/nvim/lazy/LazyVim"
end

o.runtimepath:append("~/Code/nvim-plugins/denops-getting-started")
o.runtimepath:append("~/Code/nvim-plugins/denops-helloworld.nvim")

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
if Util.has("termguicolors") then o.termguicolors = true end

-- vim.commentstring = ""

-- create_autocmd({ 'BufEnter', 'BufNewFile' }, {
--   pattern = '.env*',
--   command = 'set filetype=conf',
-- })

-- require("mini.starter").open()

-- g.is_original_codelens_refresh = true
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

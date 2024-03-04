-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazetyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Default keymaps
local util = require("util")
local lazy_util = require("lazyvim.util")
local K = util.keymap
-- local Wez = require("config.keymaps.wezterm")
local map = K.map
local opts = { silent = true }
local wk = require("which-key")
wk.setup()

require("config.keymaps.base")
require("config.keymaps.windows")

local nav = {
  h = "Left",
  j = "Down",
  k = "Up",
  l = "Right",
}

local function navigate(dir)
  return function()
    local win = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(dir)
    local pane = vim.env.WEZTERM_PANE
    if pane and win == vim.api.nvim_get_current_win() then
      local pane_dir = nav[dir]
      vim.system({ "wezterm", "cli", "activate-pane-direction", pane_dir }, { text = true }, function(p)
        if p.code ~= 0 then
          vim.notify(
            "Failed to move to pane " .. pane_dir .. "\n" .. p.stderr,
            vim.log.levels.ERROR,
            { title = "Wezterm" }
          )
        end
      end)
    end
  end
end

util.set_user_var("IS_NVIM", true)

-- change word with <c-c>
vim.keymap.set("n", "<C-c>", "<cmd>normal! ciw<cr>a")

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
-- map("i", "<A-j>", "<esc><cy md>m .+1<cr>==gi", { desc = "Move down" })
-- map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
-- map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
-- map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- buffers
if lazy_util.has("bufferline.nvim") then
  map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
  map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
  map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
else
  map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
  map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
  map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
end
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- Quit
-- Close current buffer
map("n", "<S-q>", "<cmd>bdelete!<CR>", { silent = true })
-- Close buffers
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit all" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / clear hlsearch / diff update" }
)

map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- save file
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")
-- Identation
map("n", "<", "<<", { desc = "Deindent" })
map("n", ">", ">>", { desc = "Indent" })

-- Comment
map("n", "<leader>/", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
map("x", "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", opts)

-- Better paste
map("v", "p", '"_dP', opts)

-- Move to beginning/end of line
map("n", "<a-l>", "$", { desc = "Last character of Line" })
map("n", "<a-h>", "_", { desc = "First character of Line" })

-- -- U for redo
-- map("n", "U", "<C-r>", { desc = "Redo" })
-- -- Paste options
-- map("i", "<C-v>", '<C-r>"', { desc = "Paste on insert mode" })
map("v", "p", '"_dP', { desc = "Paste without overwriting" })

-- Delete and change without yanking
map({ "n", "x" }, "<A-d>", '"_d', { desc = "Delete without yanking" })
map({ "n", "x" }, "<A-c>", '"_c', { desc = "Change without yanking" })

-- Deleting without yanking empty line
map("n", "dd", function()
  local is_empty_line = vim.api.nvim_get_current_line():match("^%s*$")
  if is_empty_line then
    return '"_dd'
  else
    return "dd"
  end
end, { noremap = true, expr = true, desc = "Don't yank empty line to clipboard" })

-- Search inside visually highlighted text. Use `silent = false` for it to
-- make effect immediately.
map("x", "g/", "<esc>/\\%V", { silent = false, desc = "Search inside visual selection" })

-- Search visually selected text (slightly better than builtins in Neovim>=0.8)
map("x", "*", [[y/\V<C-R>=escape(@", '/\')<CR><CR>]])
map("x", "#", [[y?\V<C-R>=escape(@", '?\')<CR><CR>]])

-- Press jk fast to enter
map("i", "jk", "<ESC>", opts)

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

if not lazy_util.has("trouble.nvim") then
  map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
  map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
end

-- Keyboard remap for Mac fr
local symbol_key_opts = { desc = "which_key_ignore" }

map("n", "æ", "<A-a>", symbol_key_opts)
map("n", "Â", "<A-z>", symbol_key_opts)
map("n", "ê", "<A-e>", symbol_key_opts)
map("n", "®", "<A-r>", symbol_key_opts)
map("n", "†", "<A-t>", symbol_key_opts)
map("n", "Ú", "<A-y>", symbol_key_opts)
map("n", "º", "<A-u>", symbol_key_opts)
map("n", "î", "<A-i>", symbol_key_opts)
map("n", "œ", "<A-o>", symbol_key_opts)
map("n", "π", "<A-p>", symbol_key_opts)
map("n", "‡", "<A-q>", symbol_key_opts)
map("n", "Ò", "<A-s>", symbol_key_opts)
map("n", "∂", "<A-d>", symbol_key_opts)
map("n", "ƒ", "<A-f>", symbol_key_opts)
map("n", "ﬁ", "<A-g>", symbol_key_opts)
map("n", "Ì", "<A-h>", symbol_key_opts)
map("n", "Ï", "<A-j>", symbol_key_opts)
map("n", "È", "<A-k>", symbol_key_opts)
map("n", "¬", "<A-l>", symbol_key_opts)
map("n", "µ", "<A-m>", symbol_key_opts)
map("n", "‹", "<A-w>", symbol_key_opts)
map("n", "≈", "<A-x>", symbol_key_opts)
map("n", "©", "<A-c>", symbol_key_opts)
map("n", "◊", "<A-v>", symbol_key_opts)
map("n", "ß", "<A-b>", symbol_key_opts)
-- map("n", "~", "<A-n>") -- don't want to remap this one
map("n", "Æ", "<S-A-a>", symbol_key_opts)
map("n", "Å", "<S-A-z>", symbol_key_opts)
map("n", "Ê", "<S-A-e>", symbol_key_opts)
map("n", "‚", "<S-A-r>", symbol_key_opts)
map("n", "™", "<S-A-t>", symbol_key_opts)
map("n", "ª", "<S-A-u>", symbol_key_opts)
map("n", "ï", "<S-A-i>", symbol_key_opts)
map("n", "Œ", "<S-A-o>", symbol_key_opts)
map("n", "∏", "<S-A-p>", symbol_key_opts)
map("n", "Ÿ", "<S-A-y>", symbol_key_opts)
map("n", "Ω", "<S-A-q>", symbol_key_opts)
map("n", "∑", "<S-A-s>", symbol_key_opts)
map("n", "∆", "<S-A-d>", symbol_key_opts)
map("n", "·", "<S-A-f>", symbol_key_opts)
map("n", "ﬂ", "<S-A-g>", symbol_key_opts)
map("n", "Î", "<S-A-h>", symbol_key_opts)
map("n", "Í", "<S-A-j>", symbol_key_opts)
map("n", "Ë", "<S-A-k>", symbol_key_opts)
-- map("n", "|", "<S-A-l>") -- make conflicts I think cause it's a coditional key
map("n", "Ó", "<S-A-m>", symbol_key_opts)
map("n", "›", "<S-A-w>", symbol_key_opts)
map("n", "⁄", "<S-A-x>", symbol_key_opts)
map("n", "¢", "<S-A-c>", symbol_key_opts)
map("n", "√", "<S-A-v>", symbol_key_opts)
map("n", "∫", "<S-A-b>", symbol_key_opts)
map("n", "ı", "<S-A-n>", symbol_key_opts)
-- END Keyboard remap for Mac fr

-- local symbol_keys = {
--   "æ",
--   "Â",
--   "ê",
--   "®",
--   "†",
--   "Ú",
--   "º",
--   "î",
--   "œ",
--   "π",
--   "‡",
--   "Ò",
--   "∂",
--   "ƒ",
--   "ﬁ",
--   "Ì",
--   "Ï",
--   "È",
--   "¬",
--   "µ",
--   "‹",
--   "≈",
--   "©",
--   "◊",
--   "ß",
--   "Æ",
--   "Å",
--   "Ê",
--   "‚",
--   "™",
--   "ª",
--   "ï",
--   "Œ",
--   "∏",
--   "Ÿ",
--   "Ω",
--   "∑",
--   "∆",
--   "·",
--   "ﬂ",
--   "Î",
--   "Í",
--   "Ë",
--   "Ó",
--   "›",
--   "⁄",
--   "¢",
--   "√",
--   "∫",
--   "ı",
-- }

-- for _, key in ipairs(symbol_keys) do
--   map("n", "<A-" .. key .. ">", "<cmd>WhichKey '<A-" .. key .. ">'<cr>", { desc = "which_key_ignore" })
--   map("n", "<S-A-" .. key .. ">", "<cmd>WhichKey '<S-A-" .. key .. ">'<cr>", { desc = "which_key_ignore" })
-- end

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>", opts)
map("n", "<leader>ft", ":Telescope live_grep<CR>", opts)
map("n", "<leader>fp", ":Telescope projects<CR>", opts)
map("n", "<leader>fb", ":Telescope buffers<CR>", opts)
map("n", "<leader>fk", ":Telescope keymaps<CR>", opts)

local MiniExtra = require("mini.extra")
-- map("n", "<leader>ft", function()
--   MiniExtra.pickers.git_files()
-- end, opts)
map("n", "<leader>fm", function()
  MiniExtra.pickers.git_files({ scope = "modified" })
end, opts)
map("n", "<leader>fu", function()
  MiniExtra.pickers.git_files({ scope = "untracked" })
end, opts)
map("n", "<leader>fd", function()
  MiniExtra.pickers.diagnostic()
end, opts)

-- require("telescope").load_extension("project")
-- map("n", "<leader>fw", ":lua  require('telescope').extensions.project.project({})", { noremap = true, silent = true })

-- Git
map("n", "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", opts)

-- stylua: ignore start

-- toggle options
map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)
map("n", "<leader>uf", require("lazyvim.util").format.toggle, { desc = "Toggle format on Save" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function() lazy_util.toggle("conceallevel", false, { 0, conceallevel }) end,
  { desc = "Toggle Conceal" })
if vim.lsp.inlay_hint then
  map("n", "<leader>uh", function() vim.lsp.inlay_hint(0, nil) end, { desc = "Toggle Inlay Hints" })
end

-- lazygit
map("n", "<leader>gg",
  function() lazy_util.terminal.open({ "lazygit" }, { cwd = lazy_util.root.get(), esc_esc = false, ctrl_hjkl = false }) end,
  { desc = "Lazygit (root dir)" })
map("n", "<leader>gG", function() lazy_util.terminal.open({ "lazygit" }, { esc_esc = false, ctrl_hjkl = false }) end,
  { desc = "Lazygit (cwd)" })

-- highlights under cursor
if vim.fn.has("nvim-0.9.0") == 1 then
  map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
end
-- floating terminal
local lazyterm = function() lazy_util.terminal.open(nil, { cwd = lazy_util.root.get() }) end
map("n", "<leader>fR", lazyterm, { desc = "Terminal (root dir)" })
map("n", "<leader>fT", function() lazy_util.terminal.open() end, { desc = "Terminal (cwd)" })
-- map("n", "<ce/>", lazyterm, { desc = "Terminal (root dir)" })
map("n", "<c-_>", lazyterm, { desc = "which_key_ignore" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move to window using the <ctrl> hjkl keys
-- map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
-- map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
-- map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
-- map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Terminal Mappings
-- Disabled while plugins are lazy loaded
-- map('n', '<C-h>', '<Cmd>NvimTmuxNavigateLeft<CR>', { noremap = true, desc = "Go to left window", silent = true })
-- map('n', '<C-j>', '<Cmd>NvimTmuxNavigateDown<CR>', { noremap = true, desc = "Go to lower window", silent = true })
-- map('n', '<C-k>', '<Cmd>NvimTmuxNavigateUp<CR>', { noremap = true, desc = "Go to upper window", silent = true })
-- map('n', '<C-l>', '<Cmd>NvimTmuxNavigateRight<CR>', { noremap = true, desc = "Go to right window", silent = true })
-- map('n', '<C-\\>', '<Cmd>NvimTmuxNavigateLastActive<CR>', { silent = true })
-- map('n', '<C-Space>', '<Cmd>NvimTmuxNavigateNext<CR>', { silent = true })

-- map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
-- map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
-- map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
-- map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
map("t", "<C-/>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<c-_>", "<cmd>close<cr>", { desc = "which_key_ignore" })

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
map("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<leader><tab>-", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })

-- custom
--
map("n", "<C-j>", "cw<C-r>0<ESC>", { desc = "Change word under cursor with register 0" })

map('n', '<leader>fo', ':!open ' .. vim.fn.expand('%:p:h') .. '<cr>', { noremap = true, silent = true })
map('n', '<leader>wk', '<cmd>WhichKey<cr>', { noremap = true, silent = true })
-- WhichKey = require('which-key')
map('n', '<leader>wK', ':lua WhichKey<cr>', { noremap = true, silent = true })

-- require("luasnip.loaders.from_lua").lazy_load()
-- set keybinds for both INSERT and VISUAL.
map("i", "<C-n>", "<plug>luasnip-next-choice", {})
map("s", "<C-n>", "<plug>luasnip-next-choice", {})
map("i", "<C-p>", "<plug>luasnip-prev-choice", {})
map("s", "<C-p>", "<plug>luasnip-prev-choice", {})

map('n', '<leader>r', K.find_and_replace, { noremap = true, silent = true })
map('n', '<leader>rl', K.find_and_replace_within_lines, { silent = true })


map('n', '<leader>cr', ':lua vim.cmd("source ~/.config/nvim/init.lua")<CR>', { noremap = true })

map("n", "dm", K.delete_mark, { noremap = true })
map("n", "dM", function() vim.cmd("delmarks a-z0-9") end, { noremap = true })

-- Web search & URL handling
map("v", "<leader>gs", K.search_google, { noremap = true, silent = true })
map("n", "<leader>gl", K.open_url, { noremap = true, silent = true })

map("v", "<leader>gl", K.v_open_url, { noremap = true, silent = true })
-- map('gx', [[:execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>]]})

-- Copilot
map('n', ',c', function() require("copilot.panel").open({ "bottom", 0.25 }) end,
  { noremap = true, desc = "Pick a window" })

map('n', '<leader>uS', function() K.toggle_vim_g_variable('enable_leap_lightspeed_mode') end, { noremap = true })
--
-- vim.keymap.set("x", "<leader>re", ":Refactor extract ")
-- vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")
--
-- vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")
--
-- vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")
--
-- vim.keymap.set( "n", "<leader>rI", ":Refactor inline_func")
--
-- vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
-- vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")
--

map('n', '<leader>rx', function() K.clear_all_registers() end, { noremap = true, desc = "Clear all registers" })

map("n", "<space>m", "<cmd>Telescope macros<cr>", { desc = "Telescope Macros" })

map(
  'n',
  'leader>zx',
  function()
    vim.api.nvim_echo(
      {
        vim.api.nvim_buf_get_name(vim.fn.bufnr()),
        'none'
      },
      false
    )
  end,
  { noremap = true, desc = "Show current buffer name" }
)
-- vim.api.nvim_echo({{vim.api.nvim_buf_get_name(vim.fn.bufnr()), "none"}},false, {})
-- vim.api.nvim_echo({{table.concat(msg, linesep), "ErrorMsg"}}, true, {})

map("v", "<C-a>", "^", { noremap = true })
map("v", "<C-e>", "$", { noremap = true })
map("v", "<Tab>", "$", { noremap = true })
map("v", "<S>", "^", { noremap = true })

-- write a method that calls the user method rendermarkdown and returns the result
map("n", "<leader>bm", function() K.render_markdown() end, { noremap = true })

local function spell_reload()
  -- vim.cmd("set nospell")
  -- vim.cmd("mkspell ~/.config/nvim/spell/sugg")
  vim.cmd(":mkspell! %")
end
map("n", "zR", spell_reload, { noremap = true, silent = true })
--
--
--
--
--
--
--
--
--
--
--
--
------------------------------------------------------------

local current = 2
-- WhichKey setup
-- local LazyMod = require("config.user.lazy_mods")
wk.register({
  -- ["<S-Right>"] = { "<cmd>AerialNext<cr>", "Next" },
  -- ["<S-Left>"] = { "<cmd>AerialPrev<cr>", "Prev" },
  ["<leader>"] = {
    --   a = {
    --     name = 'Aerial',
    --     a = { "<cmd>AerialNavOpen<cr>", "Open Nav" },
    --     o = { "<cmd>AerialOpen<cr>", "Open" },
    --   },
    r = {
      s = { K.find_and_replace, "Find and Replace", mode = "v" },
      r = { "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", "Select refactor..." }
    },
    b = {
      -- a = { function() require("harpoon"):list():append() end, "Harpoon->Append" },
      c = { K.baleia_colorize, "Colorize" },
    },
    -- C = {
    --   name = "OGPT",
    --   e = { "<cmd>OGPTRun edit_with_instructions<CR>", "Edit with instruction", mode = { "n", "v" } },
    --   c = { "<cmd>OGPTRun edit_code_with_instructions<CR>", "Edit code with instruction", mode = { "n", "v" } },
    --   h = { "<cmd>OGPTRun edit_code_with_instructions2<CR>", "Edit code with instruction 2", mode = { "n", "v" } },
    --   g = { "<cmd>OGPTRun grammar_correction<CR>", "Grammar Correction", mode = { "n", "v" } },
    --   t = { "<cmd>OGPTRun translate<CR>", "Translate", mode = { "n", "v" } },
    --   k = { "<cmd>OGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
    --   d = { "<cmd>OGPTRun docstring<CR>", "Docstring", mode = { "n", "v" } },
    --   a = { "<cmd>OGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
    --   o = { "<cmd>OGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
    --   s = { "<cmd>OGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
    --   f = { "<cmd>OGPTRun fix_bugs<CR>", "Fix Bugs", mode = { "n", "v" } },
    --   x = { "<cmd>OGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
    --   r = { "<cmd>OGPTRun roxygen_edit<CR>", "Roxygen Edit", mode = { "n", "v" } },
    --   l = { "<cmd>OGPTRun code_readability_analysis<CR>", "Code Readability Analysis", mode = { "n", "v" } },
    -- },
    C = {
      name = "ChatGPT",
      e = { "<cmd>ChatGPTEditWithInstructions<CR>", "Edit code with instructions", mode = { "n", "v" } },
      c = { "<cmd>ChatGPTEditWithInstructions<CR>", "Edit code with instructions", mode = { "n", "v" } },
      g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction", mode = { "n", "v" } },
      t = { "<cmd>ChatGPTRun translate<CR>", "Translate", mode = { "n", "v" } },
      k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
      d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring", mode = { "n", "v" } },
      a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
      o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
      s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
      f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs", mode = { "n", "v" } },
      x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
      r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit", mode = { "n", "v" } },
      l = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis", mode = { "n", "v" } },
    },
    c = {
      c = {
        name = "Copy/Reload",
        c = { K.copy_to_pbcopy, "Copy to clipboard", { noremap = true, silent = true } },
        p = {
          function()
            vim.api.nvim_call_function("setreg", { "+", vim.fn.fnamemodify(vim.fn.expand("%"), ":.") })
          end,
          "Copy file path to clipboard"
        },
        r = { "<cmd>lua vim.cmd('source ~/.config/nvim/init.lua')<CR>", "Reload config" },
      }
    },
    d = {
      S = { "<cmd>lua require('osv').launch({port=8086})<cr>", "Start OSV (port 8086)" },
    },
    n = {
      t = { "<cmd>NoiceTelescope<cr>", "Noice", { noremap = true } },
      n = { "<cmd>Telescope notify<cr>", "Telescope notify" },
      b = { "<cmd>Telescope buffers<cr>", "Buffers" },
      B = { "<cmd>Telescope bookmarks list<cr>", "Bookmarks" },
      c = { "<cmd>Telescope commands<cr>", "Commands" },
      C = { "<cmd>Telescope command_history<cr>", "command history" },
      e = { "<cmd>NoiceErrors<cr>" },
      f = { "<cmd>Telescope file_browser<cr>", "file browser" },
      g = { "<cmd>Telescope git_status<cr>", "Git Status" },
      G = { "<cmd>Telescope git_commits<cr>", "Git Commits" },
      h = { "<cmd>Telescope help_tags<cr>", "Help Tags" },
      j = { "<cmd>Telescope jump_list<cr>", "Jump List" },
      l = { "<cmd>Telescope current_buffer_fuzzy_find<cr>", "Current Buffer Fuzzy Find" },
      m = { "<cmd>Telescope macros<cr>", "Macros" },
      M = {
        name = "Mark/Msg/Man",
        a = { "<cmd>Telescope marks<cr>", "Marks" },
        e = { "<cmd>Telescope messages<cr>", "Messages" },
        p = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
      },
      r = { "<cmd>Telescope registers<cr>", "Registers" },
      -- s = { "<cmd>Telescope spell_suggest<cr>", "Spell Suggest"},
      S = { "<cmd>Telescope session<cr>", "Session" },
      T = { "<cmd>Telescope treesitter<cr>", "Treesitter" },
      y = { "<cmd>Telescope yank_history<cr>" }
    },
    g = {
      s = { "<cmd>lua search_google()<CR>", "Search Google" },
      d = { "<cmd>Telescope lsp_definitions<cr>", "Go to definition" },
      -- s = { "<cmd>Telescope lsp_document_symbols<cr>", "Go to symbol" },
      -- s = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Go to workspace symbol" },
    },
    f = {
      o = { ":!open .. vim.fn.expand('%:p:h') .. <cr>", "Reveal in finder" }
    },
    u = {
      -- d = { LazyMod.toggle.diagnostics, "Toggle Diagnostics*" },
      S = { function() K.toggle_vim_g_variable("enable_leap_lightspeed_mode") end, "Enable leap lightspeed mode" },
      q = { "<Cmd>Trouble<cr>", "Show Trouble" },
    },
    k = {
      --   r = {
      --     x = { clear_all_registers, "Clear all registers" },
      --   },
      k = {
        X = { K.clear_all_registers, "Clear all registers" },
      },
    },
    -- p = {
    --   name = "OGPT",
    --   e = {
    --       function()
    --           require("ogpt").edit_with_instructions()
    --       end,
    --       "Edit with instructions",
    --   },
    --   a = {
    --       function()
    --         require("ogpt").act_with_instructions()
    --       end,
    --       "Edit code with instructions",
    --   },
    -- },
    -- t = {
    --   n = {
    --     function()
    --       local betterTerm = require("betterTerm")
    --       betterTerm.open(current)
    --       current = current + 1
    --     end,
    --     "New terminal",
    --   },
    -- },
    w = {
      h = { K.switch_to_highest_window, "Switch to highest window" },
      q = { K.close_all_floating_windows, "Close all floating windows" },
    },
    z = {
      x = {
        function() vim.api.nvim_echo({ vim.api.nvim_buf_get_name(vim.fn.bufnr()), 'none' }, false) end,
        "Show current buffer name"
      },
    },
  },
})

-- Unused

-- local bm = require "bookmarks"
-- map('n', '<leader>Bm', function() bm.bookmark_toggle() end, { noremap = true}) -- add or remove bookmark at current line
-- map('n', '<leader>Bi', function() bm.bookmark_ann()    end, { noremap = true})  -- add or edit mark annotation at current line
-- map('n', '<leader>Bc', function() bm.bookmark_clean()  end, { noremap = true})  -- clean all marks in local buffer
-- map('n', '<leader>Bn', function() bm.bookmark_next()   end, { noremap = true})  -- jump to next mark in local buffer
-- map('n', '<leader>Bp', function() bm.bookmark_prev()   end, { noremap = true})  -- jump to previous mark in local buffer
-- map('n', '<leader>Bl', function() bm.bookmark_list()   end, { noremap = true})  -- show marked file list in quickfix window

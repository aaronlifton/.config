-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local o = vim.opt
local lazyutil = require("lazy.util")

map({ "n", "i", "v", "x" }, "<C-7>", "<cmd>WhichKey<cr>", { desc = "WhichKey" })
-- Buffers
map("n", "<leader>bf", "<cmd>bfirst<cr>", { desc = "First Buffer" })
map("n", "<leader>ba", "<cmd>blast<cr>", { desc = "Last Buffer" })
map("n", "<S-q>", "<cmd>bdelete!<CR>", { silent = true })

-- Toggle statusline
map("n", "<leader>uS", function()
  if o.laststatus:get() == 0 then
    o.laststatus = 3
  else
    o.laststatus = 0
  end
end, { desc = "Toggle Statusline" })

-- Toggle tabline
map("n", "<leader>u<tab>", function()
  if o.showtabline:get() == 0 then
    o.showtabline = 2
  else
    o.showtabline = 0
  end
end, { desc = "Toggle Tabline" })

-- toggle colorcolumn
map("n", "<leader>um", function()
  if o.colorcolumn == "" then
    o.colorcolumn = "81"
  else
    o.colorcolumn = ""
  end
end, { desc = "Toggle colorcolumn" })

-- toggle formatexpr
map("n", "<leader>uM", function()
  if o.formatexpr == "" then
    -- o.formatexpr = "v:lua.require'lazyvim.util'.format.formatexpr()"
    -- o.formatexpr = "v:lua.vim.lsp.formatexpr()"
    o.formatexpr = lazyutil.formatexpr()
  else
    o.formatexpr = ""
  end
  if o.formatexpr == "" then
    LazyVim.info("Disabled formatexpr")
  else
    LazyVim.info("Reset formatexpr")
  end
end, { desc = "Toggle formatexpr" })

-- Cursor navigation on insert mode
map("i", "<M-h>", "<left>", { desc = "Move cursor left" })
map("i", "<M-l>", "<right>", { desc = "Move cursor left" })
map("i", "<M-j>", "<down>", { desc = "Move cursor left" })
map("i", "<M-k>", "<up>", { desc = "Move cursor left" })

-- End of the word backwards
map("n", "E", "ge")

-- Increment/decrement
map("n", "+", "<C-a>")
map("n", "-", "<C-x>")

-- Tabs
map("n", "<tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<s-tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
for i = 1, 9 do
  map("n", "<leader><tab>" .. i, "<cmd>tabn " .. i .. "<cr>", { desc = "Tab " .. i })
end
map("n", "<leader><tab>-", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })

map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- Indentation
map("n", "<", "<<", { desc = "Deindent" })
map("n", ">", ">>", { desc = "Indent" })

-- CMD keys
map({ "n", "v", "s", "i" }, "<D-s>", "<cmd>w<cr>", { noremap = true })

-- map({ "n", "v", "s", "i" }, "<D-v>", "<cmd>norm gpa<cr>", { noremap = true })
-- map({ "s", "i" }, "<D-v>", "<cmd>norm gpa<cr>", { noremap = true })
map({ "i", "t" }, "<D-v>", '<C-r>"', { desc = "Paste on insert mode" })
map("v", "<D-v>", '"+P', { noremap = true })
map("n", "<D-v>", "<cmd>norm gpa<cr>", { noremap = true })
map("c", "<D-v>", "<C-R>+", { noremap = true }) -- Paste command mode, add a hack to force render it
map("v", "<D-c>", '"+y', { noremap = true }) -- Copy

-- Paste options
map("v", "p", '"_dP', { desc = "Paste without overwriting" })

-- Copy whole text to clipboard
map("n", "<C-c>", ":%y+<CR>", { desc = "Copy whole text to clipboard", silent = true })

-- Motion
map("c", "<C-a>", "<C-b>", { desc = "Start Of Line" })
map("i", "<C-a>", "<Home>", { desc = "Start Of Line" })
map("i", "<C-e>", "<End>", { desc = "End Of Line" })

-- Check this
map("n", "<M-v>", "cw<C-r>0<ESC>", { desc = "Change word under cursor with register 0" })

-- Move to beginning/end of line
map("n", "<M-l>", "$", { desc = "LAST CHARACTER OF LINE", noremap = true })
map("n", "<M-h>", "_", { desc = "First character of Line" })

-- Delete and change without yanking
map({ "n", "x" }, "<M-d>", '"_d', { desc = "Delete without yanking" })
map({ "n", "x" }, "<M-c>", '"_c', { desc = "Change without yanking" })

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
map("i", "jk", "<ESC>", { silent = true })

-- Dashboard
map("n", "<leader>fd", function()
  if LazyVim.has("alpha-nvim") then
    require("alpha").start(true)
  elseif LazyVim.has("dashboard-nvim") then
    vim.cmd("Dashboard")
  end
end, { desc = "Dashboard" })

-- Open in finder
map("n", "<leader>fo", ":!open " .. vim.fn.expand("%:p:h") .. "<cr>", { noremap = true, silent = true })

-- Reload spelling dictionary
local function spell_reload()
  vim.cmd(":mkspell! %")
end

map("n", "zR", spell_reload, { noremap = true, silent = true })

if LazyVim.has("baleia.nvim") then
  map("n", "<leader>buc", function()
    local bufname = vim.api.nvim_buf_get_name(vim.fn.bufnr())
    if bufname == "LazyTerm" then
      return
    end
    require("baleia").automatically(vim.fn.bufnr())
  end)
end

function GetDiags()
  local diagnostics = vim.diagnostic.get(0)
  local json = vim.fn.json_encode(diagnostics)
  vim.fn.mkdir(vim.fn.stdpath("data") .. "/diagjson", "p")
  local path = vim.fn.stdpath("data") .. "/diagnostics.json"
  vim.fn.writefile({ json }, path)
  vim.notify("Saved diagnostics to " .. path, vim.log.levels.INFO, { title = "Diagnostics" })
end
vim.api.nvim_command("command! SaveJsonDiags lua GetDiags()")

-- Lazy options
map("n", "<leader>l", "<Nop>")
map("n", "<leader>L", "<Nop>")
map("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy" })

map("n", "<leader>ld", function()
  vim.fn.system({ "xdg-open", "https://lazyvim.org" })
end, { desc = "LazyVim Docs" })
map("n", "<leader>lr", function()
  vim.fn.system({ "xdg-open", "https://github.com/LazyVim/LazyVim" })
end, { desc = "LazyVim Repo" })
map("n", "<leader>lr", function()
  vim.fn.system({ "xdg-open", "https://github.com/folke/lazy.nvim" })
end, { desc = "lazy.nvim Repo" })

map("n", "<leader>lx", "<cmd>LazyExtras<cr>", { desc = "Extras" })
map("n", "<leader>lc", function()
  LazyVim.news.changelog()
end, { desc = "LazyVim Changelog" })
map("n", "<leader>lu", function()
  lazy.update()
end, { desc = "Lazy Update" })
map("n", "<leader>lC", function()
  lazy.check()
end, { desc = "Lazy Check" })
map("n", "<leader>ls", function()
  lazy.sync()
end, { desc = "Lazy Sync" })

map("n", "<leader>cif", "<cmd>LazyFormatInfo<cr>", { desc = "Formatting" })
map("n", "<leader>cic", "<cmd>ConformInfo<cr>", { desc = "Conform" })
local linters = function()
  local linters_attached = require("lint").linters_by_ft[vim.bo.filetype]
  local buf_linters = {}

  if LazyVim.has("none-ls.nvim") then
    local nls_lsp_util = require("util.none_ls_lsp")
    for _, linter in pairs(nls_lsp_util.get_linters()) do
      table.insert(linters_attached, ("%s (NLS)"):format(linter))
    end
  end

  if not linters_attached then
    vim.notify("No linters attached", vim.log.levels.WARN, { title = "Linter" })
    return
  end

  for _, linter in pairs(linters_attached) do
    table.insert(buf_linters, linter)
  end

  local unique_client_names = table.concat(buf_linters, ", ")
  local linters = string.format("%s", unique_client_names)

  vim.notify(linters, vim.log.levels.INFO, { title = "Linter" })
end
map("n", "<leader>ciL", linters, { desc = "Lint" })
map("n", "<leader>cir", "<cmd>LazyRoot<cr>", { desc = "Root" })

--- Neotree
map("n", "<M-e>", function()
  local reveal_file = vim.fn.expand("%:p")
  if reveal_file == "" then
    reveal_file = vim.fn.getcwd()
  else
    local f = io.open(reveal_file, "r")
    if f then
      f.close(f)
    else
      reveal_file = vim.fn.getcwd()
    end
  end
  require("neo-tree.command").execute({
    action = "focus", -- OPTIONAL, this is the default value
    source = "filesystem", -- OPTIONAL, this is the default value
    position = "left", -- OPTIONAL, this is the default value
    reveal_file = reveal_file, -- path to file or folder to reveal
    reveal_force_cwd = true, -- change cwd without asking if needed
  })
end, { desc = "Open neo-tree at current file or working directory" })

map("n", "<M-E>", "<cmd>Neotree reveal_force_cwd<cr>", { desc = "Reveal in neo-tree at cwd" })

map("n", "<leader>sO", "<cmd>Telescope oldfiles<cr>", { desc = "Oldfiles" })

map("n", "<leader>wb", function()
  if vim.g.last_winid ~= nil then
    local last_winid_dup = vim.g.last_winid
    vim.g.last_winid = vim.fn.bufnr()
    vim.nvim_echo({ { last_winid_dup, "Normal" } }, false, {})
    vim.fn.win_gotoid(last_winid_dup)
  end
end, { desc = "Last Window" })

map(
  "n",
  "<leader>rr",
  "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>",
  { desc = "Select refactor..." }
)

map("n", "<leader>ccp", ":let @+=expand('%:p') .. <cr>", { desc = "Copy path to clipboard" })

map("n", "<leader>cq", function()
  vim.diagnostic.open_float(nil, { source = true })
end, { desc = "Line Diagnostics (Source)" })

-- Custom Telescope finders
local T = require("util.custom_telescope_finders")
map("n", "<leader>flg", function()
  T.grep_lazyvim_files()
end, { desc = "Grep lazyvim files" })
map("n", "<leader>fll", function()
  T.find_lazyvim_files()
end, { desc = "Find lazyvim files" })
map("n", "<leader>fla", function()
  T.grep_dir("astrovim", {})
end, { desc = "Grep astrovim files" })
map("n", "<leader>flm", function()
  T.grep_config_files({})
end, { desc = "Grep config files" })
map("n", "<leader>flM", function()
  T.find_config_files({})
end, { desc = "Find config files" })
map("n", "<leader>flI", function()
  T.grep_inspiration_files({ layout_strategy = "center" })
end)
-- m = {
--   function()
--     t.grep_config_files({})
--   end,
--   "grep [m]y config files",
-- },
-- m = {
--   function()
--     t.find_config_files({})
--   end,
--   "find [m]y config files",
-- },
-- p = {
--   function()
--     t.find_project_files()
--   end,
--   "find project files",
-- },
-- i = {
--   name = "inspiration",
--   i = {
--     function()
--       t.grep_inspiration_files({})
--     end,
--     "grep all ~inspiration~ files",
--   },
--   l = {
--     function()
--       t.grep_dir("lvim", {})
--     end,
--     "grep lunarvim files",
--   },
--   d = {
--     function()
--       t.grep_dir("doom", {})
--     end,
--     "grep doomnvim files",
--   },
--   f = {
--     function()
--       t.grep_dir("ftw", {})
--     end,
--     "grep ftw files",
--   },
--   n = {
--     function()
--       t.grep_dir("nyoom", {})
--     end,
--     "grep nyoom files",
--   },
--   n = {
--     function()
--       t.grep_dir("nicoalbanese", {})
--     end,
--     "grep nicoalbanese files",
--   },
--   m = {
--     function()
--       t.grep_dir("modern", {})
--     end,
--     "grep modern-neovim files",
--   },
--   p = {
--     function()
--       t.grep_dir("pde", {})
--     end,
--     "grep neovim-pde files",
--   },
--   f = {
--     function()
--       t.grep_dir("folke", {})
--     end,
--     "grep folke files",
--   },
--   k = {
--     function()
--       vim.cmd("e /users/aaron/.local/share/nvim/lazy/lazyvim/lua/lazyvim/config/keymaps.lua")
--     end,
--     "view lazyvim keymap",
--   },
--   d = {
--     function()
--       t.grep_dir("dots", {})
--     end,
--     "grep nvimdots files",
--   },
--   x = {
--     t.find_config_files_cursor,
--     "find [x] config files",
--   },
-- },

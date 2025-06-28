-- [[ Basic Keymaps ]]
--  See `:help map()`

local map = vim.keymap.set
local o = vim.opt

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to Left Window", remap = true })
map("n", "<C-j>", "<C-w>j", { desc = "Go to Lower Window", remap = true })
map("n", "<C-k>", "<C-w>k", { desc = "Go to Upper Window", remap = true })
map("n", "<C-l>", "<C-w>l", { desc = "Go to Right Window", remap = true })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })

-- Move Lines
map("n", "<A-j>", "<cmd>execute 'move .+' . v:count1<cr>==", { desc = "Move Down" })
map("n", "<A-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==", { desc = "Move Up" })
map("i", "<A-j>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move Down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move Up" })
map("v", "<A-j>", ":<C-u>execute \"'<,'>move '>+\" . v:count1<cr>gv=gv", { desc = "Move Down" })
map("v", "<A-k>", ":<C-u>execute \"'<,'>move '<-\" . (v:count1 + 1)<cr>gv=gv", { desc = "Move Up" })

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "]b", "<cmd>bnext<cr>", { desc = "Next Buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>`", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })
map("n", "<leader>bd", function()
  Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function()
  Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- Clear search and stop snippet on escape
-- map({ "i", "n", "s" }, "<esc>", function()
--   vim.cmd("noh")
--   Util.lazy.cmp.actions.snippet_stop()
--   return "<esc>"
-- end, { expr = true, desc = "Escape and Clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
  "n",
  "<leader>ur",
  "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
  { desc = "Redraw / Clear hlsearch / Diff Update" }
)

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")

-- save file
map({ "i", "x", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

--keywordprg
map("n", "<leader>K", "<cmd>norm! K<cr>", { desc = "Keywordprg" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- lazy
map("n", "<leader>l", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- location list
map("n", "<leader>xl", function()
  local success, err = pcall(vim.fn.getloclist(0, { winid = 0 }).winid ~= 0 and vim.cmd.lclose or vim.cmd.lopen)
  if not success and err then vim.notify(err, vim.log.levels.ERROR) end
end, { desc = "Location List" })

-- quickfix list
map("n", "<leader>xq", function()
  local success, err = pcall(vim.fn.getqflist({ winid = 0 }).winid ~= 0 and vim.cmd.cclose or vim.cmd.copen)
  if not success and err then vim.notify(err, vim.log.levels.ERROR) end
end, { desc = "Quickfix List" })

map("n", "[q", vim.cmd.cprev, { desc = "Previous Quickfix" })
map("n", "]q", vim.cmd.cnext, { desc = "Next Quickfix" })

-- formatting
-- map({ "n", "v" }, "<leader>cf", function()
--   Util.lazy.format({ force = true })
-- end, { desc = "Format" })

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
map("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
map("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
map("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
map("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
map("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
map("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
map("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

-- quit
map("n", "<leader>qq", "<cmd>qa<cr>", { desc = "Quit All" })

-- highlights under cursor
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })
map("n", "<leader>uI", function()
  vim.treesitter.inspect_tree()
  vim.api.nvim_input("I")
end, { desc = "Inspect Tree" })

-- Util.lazy Changelog
-- map("n", "<leader>L", function() Util.lazy.news.changelog() end, { desc = "Util.lazy Changelog" })

-- windows
map("n", "<leader>-", "<C-W>s", { desc = "Split Window Below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split Window Right", remap = true })
map("n", "<leader>wd", "<C-W>c", { desc = "Delete Window", remap = true })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>o", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- native snippets. only needed on < 0.11, as 0.11 creates these by default
if vim.fn.has("nvim-0.11") == 0 then
  map("s", "<Tab>", function()
    return vim.snippet.active({ direction = 1 }) and "<cmd>lua vim.snippet.jump(1)<cr>" or "<Tab>"
  end, { expr = true, desc = "Jump Next" })
  map({ "i", "s" }, "<S-Tab>", function()
    return vim.snippet.active({ direction = -1 }) and "<cmd>lua vim.snippet.jump(-1)<cr>" or "<S-Tab>"
  end, { expr = true, desc = "Jump Previous" })
end

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Diagnostic keymaps
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- Cmd key
map({ "n", "v", "s", "i" }, "<D-s>", "<cmd>w<cr>", { noremap = true })

-- map({ "n", "v", "s", "i" }, "<D-v>", "<cmd>norm gpa<cr>", { noremap = true })
-- map({ "s", "i" }, "<D-v>", "<cmd>norm gpa<cr>", { noremap = true })
map("i", "<D-v>", '<C-r>"', { desc = "Paste on insert mode" })
map({ "v", "t" }, "<D-v>", '"+P', { noremap = true })
map("n", "<D-v>", "<cmd>norm gpa<cr>", { noremap = true })
map("c", "<D-v>", "<C-R>+", { noremap = true }) -- Paste command mode, add a hack to force render it
map("v", "<D-c>", '"+y', { noremap = true }) -- Copy

-- Paste options
map("v", "p", '"_dP', { desc = "Paste without overwriting" }, { silent = true })

-- Copy whole text to clipboard
map("n", "<leader><C-c>", ":%y+<CR>", { desc = "Copy whole text to clipboard", silent = true })

-- Motion
map("c", "<C-a>", "<C-b>", { desc = "Start Of Line" })
map("i", "<C-a>", "<Home>", { desc = "Start Of Line" })
map("i", "<C-e>", "<End>", { desc = "End Of Line" })

-- Check this
map("n", "<M-v>", "cw<C-r>0<ESC>", { desc = "Change word under cursor with register 0" })

-- Move to beginning/end of line
map({ "n", "x", "o" }, "<M-l>", "$", { desc = "Last Character of Line", noremap = true })
map({ "n", "x", "o" }, "<M-h>", "_", { desc = "First character of Line" })
map({ "n", "x", "o" }, "<M-b>", "b", { desc = "Previous Word", noremap = true })
map({ "n", "x", "o" }, "<M-w>", "w", { desc = "Next Word", noremap = true })

-- Delete and change without yanking (from Helix)
map({ "n", "x" }, "<M-d>", '"_d', { desc = "Delete without yanking" })
map({ "n", "x" }, "<M-c>", '"_c', { desc = "Change without yanking" })
map({ "n", "x" }, "<C-c>", '"_ciw', { desc = "Change word without yanking" })

-- TIP: Disable arrow keys in normal mode
-- map('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- map('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- map('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- map('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- NOTE: Some terminals have colliding keymaps or are not able to send distinct keycodes
-- map("n", "<C-S-h>", "<C-w>H", { desc = "Move window to the left" })
-- map("n", "<C-S-l>", "<C-w>L", { desc = "Move window to the right" })
-- map("n", "<C-S-j>", "<C-w>J", { desc = "Move window to the lower" })
-- map("n", "<C-S-k>", "<C-w>K", { desc = "Move window to the upper" })

-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.hl.on_yank()`
local ac = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup
ac("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})
ac("User", {
  pattern = "LazyLoad",
  desc = "Initialize Util module",
  callback = function(args)
    require("util")
  end,
})
-- Load Snacks statuscolumn after nvim-treesitter loads. Crashes when set in options.lua
-- HACK: This requires a restart but at least prevents Neovim from crashing due to missing nvim-treesitter
ac("User", {
  pattern = "nvim-treesitter",
  callback = function()
    vim.opt.statuscolumn = [[%!v:lua.require'snacks.statuscolumn'.get()]]
  end,
})

map("i", "<M-h>", "<left>", { desc = "Move cursor left" })
map("i", "<M-l>", "<right>", { desc = "Move cursor left" })
map("i", "<M-j>", "<down>", { desc = "Move cursor left" })
map("i", "<M-k>", "<up>", { desc = "Move cursor left" })

-- End of the word backwards
map("n", "E", "ge")

-- Increment/decrement
-- map("n", "+", "<C-a>")
-- map("n", "-", "<C-x>")

-- Tabs
map("n", "<tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<s-tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
for i = 1, 9 do
  map("n", "<leader><tab>" .. i, "<cmd>tabn " .. i .. "<cr>", { desc = "Tab " .. i })
end
map("n", "<leader>f<tab>", function()
  vim.ui.select(vim.api.nvim_list_tabpages(), {
    prompt = "Select Tab:",
    format_item = function(tabid)
      local wins = vim.api.nvim_tabpage_list_wins(tabid)
      local not_floating_win = function(winid)
        return vim.api.nvim_win_get_config(winid).relative == ""
      end
      wins = vim.tbl_filter(not_floating_win, wins)
      local bufs = {}
      for _, win in ipairs(wins) do
        local buf = vim.api.nvim_win_get_buf(win)
        local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })
        if buftype ~= "nofile" then
          local fname = vim.api.nvim_buf_get_name(buf)
          table.insert(bufs, vim.fn.fnamemodify(fname, ":t"))
        end
      end
      local tabnr = vim.api.nvim_tabpage_get_number(tabid)
      local cwd = string.format(" %8s: ", vim.fn.fnamemodify(vim.fn.getcwd(-1, tabnr), ":t"))
      local is_current = vim.api.nvim_tabpage_get_number(0) == tabnr and "✸" or " "
      return tabnr .. is_current .. cwd .. table.concat(bufs, ", ")
    end,
  }, function(tabid)
    if tabid ~= nil then vim.cmd(tabid .. "tabnext") end
  end)
end, { desc = "Tabs" })

map({ "n", "v", "s", "i" }, "<D-s>", "<cmd>w<cr>", { noremap = true })
map("n", "<leader><tab>\\", "<C-w>g<Tab>", { desc = "Alt Tab", remap = true })
-- vim: ts=2 sts=2 sw=2 et

map("n", "dd", function()
  local is_empty_line = vim.api.nvim_get_current_line():match("^%s*$")
  if is_empty_line then
    return '"_dd'
  else
    return "dd"
  end
end, { noremap = true, expr = true, desc = "Don't yank empty line to clipboard" })

-- Search inside visually highlighted text
map("x", "g/", "<esc>/\\%V", { silent = false, desc = "Search Inside Visual Selection" })

-- Search visually selected text (slightly better than builtins in Neovim>=0.8)
map("x", "*", [[y/\V<C-R>=escape(@", '/\')<CR><CR>]], { desc = "Search Selected Text", silent = true })
map("x", "#", [[y?\V<C-R>=escape(@", '?\')<CR><CR>]], { desc = "Search Selected Text (Backwards)", silent = true })

-- Currently set by better-escape.nvim
-- Press jk fast to enter
-- map("i", "jk", "<ESC>", { silent = true })

-- commenting (override Util.lazy keymap to save to unnamed register)
map("n", "gco", 'o<esc>V"_cx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = "Add Comment Below" })
map("n", "gcO", 'O<esc>V"_cx<esc><cmd>normal gcc<cr>fxa<bs>', { desc = "Add Comment Above" })

-- Open in finder
map("n", "<leader>fo", ":!open " .. vim.fn.expand("%:p:h") .. "<cr>", { noremap = true, silent = true })

map("n", "<leader>ll", "<cmd>Lazy<cr>") -- Lazy
map("n", "<leader>li", "<cmd>Lazy install<cr>") -- Lazy
map("n", "<leader>lp", "<cmd>Lazy profile<cr>") -- Lazy

-- stylua: ignore start
map("n", "<leader>ld", function() vim.fn.system({ "xdg-open", "https://lazyvim.org" }) end, { desc = "Util.lazy Docs" })
map("n", "<leader>lr", function() vim.fn.system({ "xdg-open", "https://github.com/Util.lazy/Util.lazy" }) end, { desc = "Util.lazy Repo" })
map("n", "<leader>lr", function() vim.fn.system({ "xdg-open", "https://github.com/folke/lazy.nvim" }) end, { desc = "lazy.nvim Repo" })
map("n", "<leader>lu", function() require("lazy").update() end, { desc = "Lazy Update" })
map("n", "<leader>lC", function() require("lazy").check() end, { desc = "Lazy Check" })
map("n", "<leader>ls", function() require("lazy").sync() end, { desc = "Lazy Sync" })
-- stylua: ignore end

-- Linter and formatter info
map("n", "<leader>cif", "<cmd>LazyFormatInfo<cr>", { desc = "Formatting" })
map("n", "<leader>cic", "<cmd>ConformInfo<cr>", { desc = "Conform" })

local linters = function()
  local buf = vim.api.nvim_get_current_buf()
  local linters_attached = require("lint").get_running(buf)

  if #linters_attached == 0 then
    vim.notify("No linters attached", vim.log.levels.WARN, { title = "Linter" })
    return
  end

  local unique_client_names = table.concat(linters_attached, ", ")

  vim.notify(string.format("%s", unique_client_names), vim.log.levels.INFO, { title = "Linter" })
end
map("n", "<leader>ciL", linters, { desc = "Lint" })
map("n", "<leader>cir", "<cmd>LazyRoot<cr>", { desc = "Root" })

map("n", "<leader>wD", function()
  require("util.diff").toggle_compare_windows()
end, { desc = "Toggle Diff Windows" })

-- LSP vsplit
-- Goto in vsplit
map(
  "n",
  "<C-w><C-f>",
  "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>",
  { desc = "Goto Definition (vsplit)", silent = true }
)
map(
  "n",
  "<C-w><C-y>",
  "<cmd>vsplit | lua vim.lsp.buf.type_definition()<cr>",
  { desc = "Goto Type Definition (vsplit)", silent = true }
)
map(
  "n",
  "<C-w><C-i>",
  "<cmd>tab split | lua vim.lsp.buf.implementation()<cr>",
  { desc = "Goto Implementation (vsplit)", silent = true }
)

-- Goto in new tab
map(
  "n",
  "<C-w>gt",
  "<cmd>tab split | lua vim.lsp.buf.definition()<cr>",
  { desc = "Goto Definition (tab)", silent = true }
)
map(
  "n",
  "<C-w>gy",
  "<cmd>tab split | lua vim.lsp.buf.type_definition()<cr>",
  { desc = "Goto Type Definition (tab)", silent = true }
)

map("n", "<C-w><C-i>", function()
  local params = vim.lsp.util.make_position_params(0, "utf-8")
  vim.lsp.buf_request(0, "textDocument/implementation", params, function(err, result, ctx, config)
    if err or not result or vim.tbl_isempty(result) then
      vim.notify("No implementations found", vim.log.levels.ERROR)
      return
    end

    if #result == 1 then
      -- Single implementation - open in vsplit
      vim.cmd("vsplit")
      vim.lsp.util.show_document(result[1], "utf-8", { focus = true })
    else
      local items = vim.lsp.util.locations_to_items(result, "utf-8")
      vim.fn.setqflist(items)
      -- Make a picker if more than 2?
      -- local all_filepaths = vim
      --   .iter(items)
      --   :map(function(item)
      --     return item.filename
      --   end)
      --   :join("\n")

      vim.cmd("vsplit | cfirst | normal! zz")
    end
  end)
end, { desc = "Goto implementation (vsplit)", silent = true })

-- Goto file in vsplit
-- map("n", "<C-w><C-v>", "vs | gf", { desc = "Goto File (vsplit)", silent = true })
map("n", "<C-w><C-v>", function()
  vim.cmd([[ vsplit ]])
  if vim.bo.filetype == "ruby" then
    local cfile = vim.fn["rails#ruby_cfile"]()
    vim.cmd(":find " .. cfile)
  else
    vim.cmd([[normal! gf]])
  end
end, { desc = "Goto File (vsplit)", silent = true })

local path_util = require("util.path")
-- map("n", "<leader>ccp", ":let @+=expand('%:p')<cr>", { desc = "Copy path to clipboard" })
map("n", "<leader>cpp", function()
  -- -- ":let @+=expand('%:p')<cr>"
  -- local current_path = vim.fn.expand("%:p")
  -- vim.api.nvim_echo({ { current_path, "Normal" } }, false, {})
  -- vim.cmd("let @+=expand('%:p')")
  -- -- vim.api.nvim_call_function('setreg', {'+', "test"})
  path_util.copy_abs_path()
end, { desc = "Copy path to clipboard", silent = true })
map("n", "<leader>cpr", function()
  path_util.copy_rel_path()
end, { desc = "Copy relative path to clipboard", silent = true })
map("n", "<leader>cpl", function()
  path_util.copy_rel_file_line()
end, { desc = "Copy relative path:line to clipboard", silent = true })
map("n", "<leader>cpP", function()
  path_util.copy_rel_pwd_rg_glob()
end, { desc = "Copy pwd rg glob to clipboard", silent = true })
map("n", "<leader>cpL", function()
  path_util.copy_abs_file_line()
end, { desc = "Copy absolute path:line to clipboard", silent = true })
map("v", "<leader>cpm", function()
  local clipboard = require("util.clipboard")
  clipboard.set_clipboard(require("util.selection").markdown_code_fence())
end, { desc = "Copy markdown code fence" })

map("n", "dm", function()
  local cur_line = vim.fn.line(".")
  -- Delete buffer local mark
  for _, mark in ipairs(vim.fn.getmarklist("%")) do
    if mark.pos[2] == cur_line and mark.mark:match("[a-zA-Z]") then
      vim.api.nvim_buf_del_mark(0, string.sub(mark.mark, 2, #mark.mark))
      return
    end
  end
  -- Delete global marks
  local cur_buf = vim.api.nvim_win_get_buf(vim.api.nvim_get_current_win())
  for _, mark in ipairs(vim.fn.getmarklist()) do
    if mark.pos[1] == cur_buf and mark.pos[2] == cur_line and mark.mark:match("[a-zA-Z]") then
      vim.api.nvim_buf_del_mark(0, string.sub(mark.mark, 2, #mark.mark))
      return
    end
  end
end, { noremap = true, desc = "Mark on Current Line" })

-- Empty Line
map("n", "gO", "<Cmd>call append(line('.') - 1, repeat([''], v:count1))<CR>", { desc = "Empty Line Above" })
map("n", "go", "<Cmd>call append(line('.'), repeat([''], v:count1))<CR>", { desc = "Empty Line Below" })

-- Insert Mode
map({ "c", "i", "t" }, "<M-BS>", "<C-w>", { desc = "Delete Word" })

-- map("n", "zF", ":norm z=1<cr>", { desc = "Choose first spelling suggestion" })
map("n", "zF", "z=1<cr>", { noremap = true, desc = "Choose first spelling suggestion" })

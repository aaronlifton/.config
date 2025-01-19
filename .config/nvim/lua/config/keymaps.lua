-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = vim.keymap.set
local o = vim.opt
local lazyutil = require("lazy.util")
local git_util = require("util.git")

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

-- toggle colorcolumn
map("n", "<leader>u|", function()
  local col = vim.o.colorcolumn
  if col == "" then
    vim.o.colorcolumn = "81"
  else
    vim.o.colorcolumn = ""
  end
end, { desc = "Toggle colorcolumn" })

map("n", "<leader>u<PageUp>", function()
  local col = vim.o.colorcolumn
  if col == "" then
    vim.o.colorcolumn = "101"
  else
    vim.o.colorcolumn = ""
  end
end, { desc = "Toggle colorcolumn" })

-- toggle formatexpr to format paragraphs
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

-- Replaced by default keymap <C-w>g<Tab>
map("n", "<leader><tab>\\", "<C-w>g<Tab>", { desc = "Alt Tab", remap = true })
-- map("n", "<leader><tab>\\", function()
--   if vim.g.last_tabpage == nil then return end
--   local tabpages = vim.api.nvim_list_tabpages()
--   for _, tab in ipairs(tabpages) do
--     if tab == vim.g.last_tabpage then return vim.api.nvim_set_current_tabpage(vim.g.last_tabpage) end
--   end
--   vim.g.last_tabpage = nil
-- end, { desc = "Alt Tab" })

map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- Indentation
-- map("n", "<", "<<", { desc = "Deindent" })
-- map("n", ">", ">>", { desc = "Indent" })

-- CMD keys
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

-- Delete and change without yanking
map({ "n", "x" }, "<M-d>", '"_d', { desc = "Delete without yanking" })
map({ "n", "x" }, "<M-c>", '"_c', { desc = "Change without yanking" })
map({ "n", "x" }, "<C-c>", '"_ciw', { desc = "Change word without yanking" })

-- Enable delete to end of line in NUI inputs. Gets overriden by LSP keymap
-- otherwise.
-- map("i", "<C-k>", "<C-o>dd", { desc = "Delete line" })
map("i", "<C-k>", "<C-o>D", { desc = "Delete to end of line", noremap = true })

-- Deleting without yanking empty line
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

-- Press jk fast to enter
map("i", "jk", "<ESC>", { silent = true })

-- Dashboard
map("n", "<leader>fd", function()
  Snacks.dashboard.open()
end, { desc = "Dashboard" })

-- Open in finder
map("n", "<leader>fo", ":!open " .. vim.fn.expand("%:p:h") .. "<cr>", { noremap = true, silent = true })

-- Reload spelling dictionary
local function spell_reload()
  vim.cmd(":mkspell! %")
end
map("n", "zR", spell_reload, { noremap = true, silent = true })

-- if LazyVim.has("baleia.nvim") then
--   map("n", "<leader>buc", function()
--     local bufname = vim.api.nvim_buf_get_name(vim.fn.bufnr())
--     if bufname == "LazyTerm" then
--       return
--     end
--     require("baleia").automatically(vim.fn.bufnr())
--   end)
-- end

function GetDiags()
  local diagnostics = vim.diagnostic.get(0)
  local json = vim.fn.json_encode(diagnostics)
  vim.fn.mkdir(vim.fn.stdpath("data") .. "/diagjson", "p")
  local path = vim.fn.stdpath("data") .. "/diagnostics.json"
  vim.fn.writefile({ json }, path)
  vim.notify("Saved diagnostics to " .. path, vim.log.levels.INFO, { title = "Diagnostics" })
end
vim.api.nvim_command("command! SaveJsonDiags lua GetDiags()")

-- Comment box
map("n", "]/", "/\\S\\zs\\s*╭<CR>zt", { desc = "Next Block Comment" })
map("n", "[/", "?\\S\\zs\\s*╭<CR>zt", { desc = "Prev Block Comment" })

-- Lazy options
map("n", "<leader>l", "<Nop>") -- Lazy
map("n", "<leader>L", "<Nop>") -- Changeloog
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

-- Linter and formatter info
map("n", "<leader>cif", "<cmd>LazyFormatInfo<cr>", { desc = "Formatting" })
map("n", "<leader>cic", "<cmd>ConformInfo<cr>", { desc = "Conform" })
map("n", "<leader>ciF", function()
  local format_util = require("lazyvim.util.format")
  local str = ""
  local buf = vim.api.nvim_get_current_buf()
  for _, formatter in ipairs(format_util.resolve(buf)) do
    if formatter.active then
      for _, line in ipairs(formatter.resolved) do
        str = str .. " " .. formatter.name .. "[" .. line .. "]\n"
      end
    end
  end
  vim.api.nvim_echo({ { str, "Normal" } }, true, {})
end, { desc = "Formatting 2" })
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
-- map("n", "<M-e>", function()
--   local reveal_file = vim.fn.expand("%:p")
--   if reveal_file == "" then
--     reveal_file = vim.fn.getcwd()
--   else
--     local f = io.open(reveal_file, "r")
--     if f then
--       f.close(f)
--     else
--       reveal_file = vim.fn.getcwd()
--     end
--   end
--   require("neo-tree.command").execute({
--     action = "focus", -- OPTIONAL, this is the default value
--     source = "filesystem", -- OPTIONAL, this is the default value
--     position = "left", -- OPTIONAL, this is the default value
--     reveal_file = reveal_file, -- path to file or folder to reveal
--     reveal_force_cwd = true, -- change cwd without asking if needed
--   })
-- end, { desc = "Reveal in neo-tree" })

map("n", "<M-e>", "<cmd>Neotree reveal_force_cwd<cr>", { desc = "Reveal current file in neo-tree at cwd" })

map("n", "<leader>wh", function()
  require("util.win").switch_to_highest_window()
end)

-- Disabled in favor of Avante/Parrot
-- map("n", "<M-->", "<cmd>ChatGPT<CR>", { desc = "ChatGPT" })

-- Path utils
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
map("n", "<leader>cpL", function()
  path_util.copy_abs_file_line()
end, { desc = "Copy absolute path:line to clipboard", silent = true })
map("v", "<leader>cpm", function()
  local clipboard = require("util.clipboard")
  clipboard.set_clipboard(require("util.selection").markdown_code_fence())
end, { desc = "Copy markdown code fence" })
map("n", "g<C-r>m", function()
  local start_pos = vim.fn.getpos("'[")
  local end_pos = vim.fn.getpos("']")

  -- Insert code fences
  vim.api.nvim_buf_set_lines(0, start_pos[2] - 1, start_pos[2] - 1, false, { "```" })
  vim.api.nvim_buf_set_lines(0, end_pos[2] + 1, end_pos[2] + 1, false, { "```" })
end, { desc = "Surround with markdown code fence" })

map("n", "<leader>cq", function()
  vim.diagnostic.open_float(nil, { source = true })
end, { desc = "Line Diagnostics (Source)" })

-- stylua: ignore start

map({"n", "x" }, "<leader>g<C-y>", function()
  Snacks.gitbrowse({
    open = function(url) vim.fn.setreg("+", url) end,
    branch = "main",
    notify = false,
  })
end, { desc = "Git Browse (copy - main)" })

map({"n", "x" }, "<leader>g<M-y>", function()
  Snacks.gitbrowse({
    open = function(url) vim.fn.setreg("+", url) end,
    branch = "main",
    notify = false,
  })
end, { desc = "Git Browse (copy - master)" })

map({"n", "x" }, "<leader>g<C-f>", function()
  Snacks.gitbrowse({
    open = function(url)
      vim.fn.setreg("+", url:gsub("#L%d+%-?L?%d*", ""))
    end,
    notify = false,
  })
end, { desc = "Git Browse (copy file)" })

-- map({"n", "x" }, "<leader>g<M-f>", function()
--   vim.ui.select(require("util.git").mru_branches(), { prompt = "Branch: " }, function(branch)
--     Snacks.gitbrowse({
--       open = function(url) vim.fn.setreg("+", url) end,
--       branch = branch,
--       notify = false,
--     })
--   end)
-- end, { desc = "Git Browse (copy - pick)" })
-- stylua: ignore end

-- Terminals
map("n", "<M-S-Bslash>", function()
  local buf = vim.api.nvim_get_current_buf()
  local bufname = vim.api.nvim_buf_get_name(buf)
  if bufname:match("^term://.*yazi$") then
    vim.cmd("q")
    return
  end

  local cwd = vim.fn.getcwd()
  if bufname then
    local path = vim.uv.fs_realpath(bufname)
    cwd = vim.fn.fnamemodify(path, ":h")
  end

  Snacks.terminal("yazi", { cwd = cwd })
end, { desc = "Yazi" })

-- Custom leap functions
map("n", "<leader>j", function()
  require("util.leap.treesitter").leap_ts_parents()
end, { desc = "Leap AST Parents" })

-- Custom AI chat
-- map("n", "<leader>aN", function()
--   require("util.ai").toggle(true)
-- end, { desc = "Alpha2Pi - ChatGPT" })

-- Custom notepad
map("n", "<leader>Ln", function()
  require("util.notepad").launch_notepad()
end, { desc = "Toggle Notepad" })

-- Spelling
-- map("n", "<leader>!", "zg", { desc = "Add Word to Dictionary" })
-- map("n", "<leader>@", "zug", { desc = "Remove Word from Dictionary" })
map("n", "zV", function()
  require("util.spell_dictionary").add_to_vale_dictionary()
end, { desc = "Add to Vale dictionary" })

-- TreeSJ
map("n", "gJ", function()
  require("treesj").toggle({ split = { recursive = false } })
end, { desc = "SplitJoin" })
map("n", "g<C-s>", function()
  require("treesj").toggle({ split = { recursive = true } })
end, { desc = "SplitJoin (Recursive)" })
-- map("n", "gJ", function()
--   require("treesj").join()
-- end, { desc = "Join" })

-- Git modified date
map("n", "<leader>gT", function()
  local filename = vim.fn.expand("%")
  local modified_date = vim.fn.getftime(filename)
  local modified_date_str = vim.fn.strftime("%c", modified_date)
  --- @type string
  local date
  if git_util.is_git_repo() then
    local commit_date = vim.fn.system("git log -1 --format=%cd --date=unix " .. filename)
    local commit_date_str = vim.fn.strftime("%c", commit_date)
    if commit_date ~= "" then date = commit_date_str .. " (Commit Time)" end
  end
  date = date or modified_date_str .. " (Modified Time)"
  vim.api.nvim_echo({ { date, "Title" } }, true, {})
end, { desc = "Last Modified" })

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

-- Goto definition in vsplit
map(
  "n",
  "<C-w><C-f>",
  "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>",
  { desc = "Goto Definition (vsplit)", silent = true }
)
-- Goto definition in new tab
map(
  "n",
  "<C-w>gt",
  "<cmd>tab split | lua vim.lsp.buf.definition()<cr>",
  { desc = "Goto Definition (tab)", silent = true }
)
-- local wk = require("which-key")
-- wk.add({
--   mode = "n",
--   { "<C-w>gt", "<cmd>tab split | lua vim.lsp.buf.definition()<cr>", desc = "Goto Definition (tab)", silent = true },
-- })

-- map("n", "<leader>ct", function()
--   vim.lsp.buf.typehierarchy("subtypes")
-- end, { desc = "Show subtypes" })
-- map("n", "<leader>cT", function()
--   vim.lsp.buf.typehierarchy("supertypes")
-- end, { desc = "Show supertypes" })

-- see if can get used to <C-w>T instead of this
map("n", "<C-w><C-t>", "<C-w>T", { desc = "Break out into a new tab", remap = true })

-- Not needed, default keymap <C-w>T
-- map("n", "<C-w><C-t>", function()
--   local buf = vim.api.nvim_get_current_buf()
--   local win = vim.api.nvim_get_current_win()
--
--   vim.cmd(":tabnew")
--
--   local new_win = vim.api.nvim_get_current_win()
--
--   vim.api.nvim_win_set_buf(new_win, buf)
--
--   vim.api.nvim_win_close(win, false)
-- end, { desc = "Move window to new tab", silent = true })

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

-- Codeium is <leader>cI2
map("n", "<leader>cI1", "<cmd>Copilot toggle<cr>", { desc = "Toggle Copilot" })
map("n", "<leader>cI3", function()
  vim.api.nvim_command("CodeiumDisable")
  require("copilot").disable()
  vim.api.nvim_command("LLMToggleAutoSuggest")
end, { desc = "Toggle Copilot/Codeium to HFCC" })
map("n", "<leader>cI3", "Copilot enable", { desc = "Enable Copilot" })
map("n", "<leader>cId", function()
  vim.api.nvim_command("CodeiumDisable")
  vim.api.nvim_command("Copilot disable")
  vim.api.nvim_echo({
    { "Disabled AI\n\n", "Title" },
    { "Copilot ", "Type" },
    { "Disabled\n", "Comment" },
    { "Codeium ", "Type" },
    { "Disabled", "Comment" },
  }, true, {})
end, { desc = "Turn off all AI" })

map("n", "zF", ":norm z=1<cr>", { desc = "Choose first spelling suggestion" })

-- Windows Split
-- map("n", "<leader>_", "<C-W>s", { desc = "Split Window Below", remap = true })
-- map("n", "<leader>\\", "<C-W>v", { desc = "Split Window Right", remap = true })

-- Kittens
local kitten = require("util.kitty").kitten
map("n", "<leader>tk", function()
  local current_file_ext = vim.fn.expand("%:e")
  if current_file_ext == "rb" then
    kitten("kittens/side_command.kitten.py", { "bundle exec rspec", file_line() })
  else
    kitten(
      "kittens/side_command.kitten.py",
      { "npx jest --projects src/jest.config.rtl.js --colors --watch", vim.fn.expand("%:p") }
      -- { env = { APP_ENV = "development", TZ = "utc" } }
    )
  end
end, { desc = "Run RSpec (Kitten)" })
map("n", "<C-w><M-v>", function()
  kitten("kittens/side_command.kitten.py")
end, { desc = "Split window vertically (Kitten)" })
map("n", "<M-C-S-Right>", function()
  kitten("kittens/resize_window.kitten.py", { "right" })
end, { desc = "Kitten - Resize Wider" })
map("n", "<M-C-S-Left>", function()
  kitten("kittens/resize_window.kitten.py", { "left" })
end, { desc = "Kitten - Resize Narrower" })

-- Finders
map("n", "<leader>fm", function()
  local module = vim.fn.input("Module: ")
  vim.cmd("Neotree focus filesystem left")
  vim.cmd("Neotree node_modules/" .. module)
end, { desc = "Explorer (node_modules)" })

map("n", "<leader>xC", function()
  vim.fn.setqflist({})
end, { desc = "Clear Quickfix" })

-- Neotest
map("n", "[X", function()
  require("neotest").jump.prev({ status = "failed" })
end, { silent = true, desc = "Prev Test Failure" })
map("n", "]X", function()
  require("neotest").jump.next({ status = "failed" })
end, { silent = true, desc = "Next Test Failure" })
map("n", "[S", function()
  require("neotest").jump.prev({ status = "passed" })
end, { silent = true, desc = "Prev Test Success" })
map("n", "]S", function()
  require("neotest").jump.next({ status = "passed" })
end, { silent = true, desc = "Next Test Success" })

-- Trouble shortcuts
map("n", "<leader>x1", function()
  local items = require("trouble").get_items("last")
  local first = items[1]
  require("trouble.view"):jump(fist)
end, { desc = "Jump to item 1" })

-- Custom finders
local T = require("util.fzf.finders")
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
-- map("n", "<leader>flI", function()
--   T.grep_inspiration_files({ layout_strategy = "center" })
-- end)

-- Diff utils
map("n", "<leader>wD", function()
  require("util.diff").toggle_compare_windows()
end, { desc = "Toggle Diff Windows" })

map({ "n", "v" }, "<leader>13", function()
  local selection = require("util.selection").get_selection3()
  local lines = require("model.util").buf.text(selection)
  vim.api.nvim_echo({ { vim.inspect({ selection = selection, lines = lines }), "Normal" } }, true, {})
end, { desc = "Test fn" })

map("n", "<leader>rl", function()
  local buf = vim.api.nvim_get_current_buf()
  local word = vim.fn.expand("<cword>")
  local filetype = vim.bo.filetype
  local new_row
  if filetype == "lua" then
    new_row = ('vim.api.nvim_echo({{ "%s\\n", "Title"}, { vim.inspect(%s), "Normal" } }, true, {})'):format(word, word)
  elseif filetype == "javascript" then
    new_row = ("console.log('### %s: ', { %s })"):format(word, word)
  elseif filetype == "ruby" then
    new_row = ('Rails.logger.info("%s")'):format(word)
  else
    vim.notify("Unsupported filetype", vim.log.levels.INFO, { title = "Debug Print" })
    return
  end

  local pos = vim.api.nvim_win_get_cursor(0)
  local row = pos[1]
  local col = pos[2]
  local scope = Snacks.scope.get({
    buf = buf,
    pos = {
      row,
      col,
    },
    treesitter = {
      enabled = true,
      blocks = {
        "function_declaration",
        "function_definition",
        "method_declaration",
        "method_definition",
        "class_declaration",
        "class_definition",
        "do_statement",
        "while_statement",
        "repeat_statement",
        "if_statement",
        "for_statement",
      },
    },
  })
  local indent = scope and (scope.indent + vim.bo.shiftwidth) or 0
  new_row = string.rep(" ", indent) .. new_row
  vim.api.nvim_buf_set_lines(0, row, row, false, { new_row })
end, { desc = "Debug Print (console.log)", silent = true })

-- map("n", "<C-S-P>", "[h<esc>zz", { desc = "Previous hunk", remap = true })
-- map("n", "<C-S-N>", "]h<esc>zz", { desc = "Next hunk", remap = true })
-- map("n", "<C-S-P>", "[h<esc><esc>", { desc = "Previous hunk", remap = true })
--
-- map("n", "<C-S-N>", "]h", { desc = "Next hunk", remap = true })
-- map("n", "<C-S-P>", "[h", { desc = "Previous hunk", noremap = true })
-- map("n", "<M-N>", "]h", { desc = "Next hunk", remap = true })
-- map("n", "<M-P>", "[h", { desc = "Previous hunk", remap = true })

-- map("n", "<C-S-P>", "<Cmd>lua MiniDiff.goto_hunk('prev')<CR>", { desc = "Previous hunk" })
map("n", "<C-S-P>", function()
  MiniDiff.goto_hunk("prev")
  vim.cmd("normal! zz")
end, { desc = "Previous hunk" })
-- map("n", "<C-S-N>", "<Cmd>lua MiniDiff.goto_hunk('next')<CR>", { desc = "Next hunk" })
map("n", "<C-S-N>", function()
  MiniDiff.goto_hunk("next")
  vim.cmd("normal! zz")
end, { desc = "Next hunk" })
-- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)

-- /Users/alifton/.asdf/installs/ruby/3.3.2/lib/ruby/gems/3.3.0/gems/devise-4.8.1/lib/devise/test/controller_helpers.rb:128
local function resolve_github_url_from_text(text)
  local url = require("util.git.github").resolve_github_url_from_gem_path(text)
  if not url then
    vim.notify("Could not resolve github url", vim.log.levels.INFO, { title = "Github" })
    return
  end
  return url
end

map("v", "<leader>gU", function()
  local selected_text = require("util.selection").get_selection2().selection
  local url = resolve_github_url_from_text(selected_text)
  if not url then return end
  vim.notify("Opening: " .. url, vim.log.levels.INFO, { title = "Github" })
  vim.ui.open(url)
end, { desc = "Resolve github url from path" })

map("n", "<leader>g<C-r>", function()
  local path_with_line = path_util.abs_file_line()
  local url = resolve_github_url_from_text(path_with_line)
  if not url then return end
  vim.notify("Opening: " .. url, vim.log.levels.INFO, { title = "Github" })
  vim.ui.open(url)
end, { desc = "Open github url from current path" })

-- map("v", "gzaU", function()
--   vim.cmd([[exe "normal gza]f]a(\<esc>l" | startinsert]])
-- end, { desc = "Convert to markdown url" })

map("n", "g<C-h>", function()
  local cword = vim.fn.expand("<cword>")
  vim.cmd("help " .. cword)
end, { desc = "Open help file" })

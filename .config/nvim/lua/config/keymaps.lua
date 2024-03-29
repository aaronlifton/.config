-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set:
-- https://github.com/LazyVim/LazyVim/blob/main/lua/lazetyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Default keymaps
local util = require("util")
local k = util.keymap
local w = util.window
-- local Wez = require("config.keymaps.wezterm")
local map = k.map
local opts = { silent = true }
local wk = require("which-key")
local o = vim.opt
wk.setup()

require("config.keymaps.base")
require("config.keymaps.windows")

-- --- Monkey-patch codelens refresh, which happens to also trigger inlay hints visibility
-- local original_codelens_refresh = vim.lsp.codelens.refresh
-- local toggle_codelens_original = function()
--   if vim.g.is_original_codelens_refresh then
--     vim.cmd("echo 'patching codelens refresh'")
--     ---@diagnostic disable-next-line:duplicate-set-field,redefined-local
--     vim.lsp.codelens.refresh = function(opts)
--       vim.cmd("echo 'disabling inlay hints from overridden codelens refresh'")
--       original_codelens_refresh(opts)
--
--       LazyVim.toggle.inlay_hints(nil, false)
--     end
--     vim.g.is_original_codelens_refresh = false
--     vim.lsp.codelens.refresh()
--   else
--     vim.cmd("echo 'restoring original codelens refresh'")
--     vim.lsp.codelens.refresh = original_codelens_refresh
--     vim.g.is_original_codelens_refresh = true
--     vim.lsp.codelens.refresh()
--   end
-- end
-- map("n", "<leader>_l", toggle_codelens_original, { noremap = true, silent = true })
-- -- map("n", "<leader>uh", toggle_codelens_original, { noremap = true, silent = true })
-- toggle_codelens_original()

-- Disabling since using kitty now
-- Handle wezterm navigation
-- local nav = {
--   h = "Left",
--   j = "Down",
--   k = "Up",
--   l = "Right",
-- }
--
-- local function navigate(dir)
--   return function()
--     local win = vim.api.nvim_get_current_win()
--     vim.cmd.wincmd(dir)
--     local pane = vim.env.WEZTERM_PANE
--     if pane and win == vim.api.nvim_get_current_win() then
--       local pane_dir = nav[dir]
--       vim.system({ "wezterm", "cli", "activate-pane-direction", pane_dir }, { text = true }, function(p)
--         if p.code ~= 0 then
--           vim.notify(
--             "Failed to move to pane " .. pane_dir .. "\n" .. p.stderr,
--             vim.log.levels.ERROR,
--             { title = "Wezterm" }
--           )
--         end
--       end)
--     end
--   end
-- end
--
util.set_user_var("IS_NVIM", true)

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move Lines
map("n", "<A-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-j>", "<esc><cy md>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

map("n", "<M-j>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<M-k>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<M-j>", "<esc><cy md>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<M-k>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<M-j>", ":m '>+1<cr>gv=gv", { desc = "Move down" })
map("v", "<M-k>", ":m '<-2<cr>gv=gv", { desc = "Move up" })

-- Buffers
map("n", "<leader>bf", "<cmd>bfirst<cr>", { desc = "First Buffer" })
map("n", "<leader>ba", "<cmd>blast<cr>", { desc = "Last Buffer" })
map("n", "<S-q>", "<cmd>bdelete!<CR>", { silent = true })

-- Center the screen automatically
-- map("n", "n", "nzzzv")
-- map("n", "N", "Nzzzv")

-- map("n", "n", function()
--   local bt = vim.bo.buftype
--   if bt == "nofile" then
--     vim.cmd("normal nzzzv")
--   else
--     vim.cmd("normal n")
--   end
-- end, { noremap = true })
-- map("n", "N", function()
--   local bt = vim.bo.buftype
--   if bt == "nofile" then
--     vim.cmd("normal Nzzzv")
--   else
--     vim.cmd("normal N")
--   end
-- end, { noremap = true })
--
-- Toggle statuslingkgkgkllle
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
map("n", "]<tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "[<tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
map("n", "<tab>", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<s-tab>", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })
for i = 1, 9 do
  map("n", "<leader><tab>" .. i, "<cmd>tabn " .. i .. "<cr>", { desc = "Tab " .. i })
end

map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
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
map({ "i", "v", "n", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file", remap = true })

-- Indentation
map("n", "<", "<<", { desc = "Deindent" })
map("n", ">", ">>", { desc = "Indent" })

-- Comment
map("n", "<leader>\\", "<cmd>lua require('Comment.api').toggle.linewise.current()<CR>", opts)
map("x", "<leader>/", "<esc><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", opts)
map("x", "<leader>H", function()
  vim.cmd("help " .. vim.fn.expand("<cword>"))
end, { noremap = true })

-- CMD keys
map({ "n", "v", "s", "i" }, "<D-s>", "<cmd>w<cr>", { noremap = true })
map({ "n", "v", "s", "i" }, "<D-v>", "<cmd>norm gpa<cr>", { noremap = true })

-- change word with <c-c
-- vim.keymap.set("n", "<C-c>", "<cmd>normal! ciw;<cr>")
-- map("n", "<M-S-j>", "cw<C-r>0<ESC>", { desc = "Change word under cursor with register 0" })

-- Copy whole text to clipboard
map("n", "<C-c>", ":%y+<CR>", { desc = "Copy whole text to clipboard", silent = true })

-- Motion
map("c", "<C-a>", "<C-b>", { desc = "Start Of Line" })
map("i", "<C-a>", "<Home>", { desc = "Start Of Line" })
map("i", "<C-e>", "<End>", { desc = "End Of Line" })

-- Select all text
map("n", "<D-a>", "gg<S-V>G", { desc = "Select all text", silent = true, noremap = true })
map("n", "<D-E>", ":Neotree reveal_force_cwd", { desc = "Reveal neotree", silent = true, noremap = true })
map("n", "<D-O>", ":Telescope find_files", { desc = "Telescope find files", silent = true, noremap = true })

-- Paste options
map({ "i", "t" }, "<D-v>", '<C-r>"', { desc = "Paste on insert mode" })
map("v", "p", '"_dP', { desc = "Paste without overwriting" })

-- Move to beginning/end of line
map("n", "<M-l>", "$", { desc = "LAST CHARACTER OF LINE", noremap = true })
map("n", "<M-h>", "_", { desc = "First character of Line" })
-- set current buf

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
map("i", "jk", "<ESC>", opts)

-- toggle options
-- map("n", "<leader>lf", "<cmd>lua vim.lsp.buf.format{ async = true }<cr>", opts)

-- Dashboard
map("n", "<leader>fd", function()
  if LazyVim.has("alpha-nvim") then
    require("alpha").start(true)
  elseif LazyVim.has("dashboard-nvim") then
    vim.cmd("Dashboard")
  end
end, { desc = "Dashboard" })

-- lazy terminal
-- local lazyterm = function()

-- end
-- map("n", "<leader>fR", lazyterm, { desc = "Terminal (root dir)" }) -- was ft
-- map("n", "<ce/>", lazyterm, { desc = "Terminal (root dir)" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- tabs
map("n", "<leader><tab>-", "<cmd>tabonly<cr>", { desc = "Close Other Tabs" })

-- custom
map("n", "<leader>fo", ":!open " .. vim.fn.expand("%:p:h") .. "<cr>", { noremap = true, silent = true })
map("n", "<leader>wk", "<cmd>WhichKey<cr>", { noremap = true, silent = true })
-- map('n', '<leader>wK', ':lua WhichKey<cr>', { noremap = true, silent = true })

-- require("luasnip.loaders.from_lua").lazy_load()
-- set keybinds for both INSERT and VISUAL.
if not vim.g.native_snippets_enabled then
  map("i", "<C-n>", "<plug>luasnip-next-choice", {})
  map("s", "<C-n>", "<plug>luasnip-next-choice", {})
  map("i", "<C-p>", "<plug>luasnip-prev-choice", {})
  map("s", "<C-p>", "<plug>luasnip-prev-choice", {})
end

map("n", "<leader>rw", util.editor.find_and_replace, { noremap = true, silent = true })
map("n", "<leader>rl", util.editor.find_and_replace_within_lines, { silent = true })

-- map('n', '<leader>LR', ':lua vim.cmd("source ~/.config/nvim/init.lua")<CR>', { noremap = true })
local function delete_mark()
  local err, mark = pcall(function()
    vim.cmd("echo 'Enter mark to delete: '")
    return string.char(vim.fn.getchar())
  end)
  if not err or not mark then return end
  vim.cmd(":delmark " .. mark)
end

map("n", "dm", delete_mark, { noremap = true })
map("n", "dM", function()
  vim.cmd("delmarks a-z0-9")
end, { noremap = true })

-- Web search & URL handling
map("v", "<leader>gs", util.search_google, { noremap = true, silent = true })
map("n", "<leader>gu", util.open_url, { noremap = true, silent = true })
map("v", "<leader>gu", util.v_open_url, { noremap = true, silent = true })
-- map('gx', [[:execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>]]})

map("n", "<leader>uS", function()
  util.toggle_vim_g_variable("enable_leap_lightspeed_mode")
end, { noremap = true })

map("n", "<leader>rx", function()
  util.clear_all_registers()
end, { noremap = true, desc = "Clear all registers" })

map("n", "<leader>_b", function()
  vim.api.nvim_echo({ { vim.api.nvim_buf_get_name(vim.fn.bufnr()), "none" } }, false, {})
end, { noremap = true, desc = "Show current buffer name" })
-- vim.api.nvim_echo({{vim.api.nvim_buf_get_name(vim.fn.bufnr()), "none"}},false, {})
-- vim.api.nvim_echo({{table.concat(msg, linesep), "ErrorMsg"}}, true, {})

map("v", "<C-a>", "^", { noremap = true })
map("v", "<C-e>", "$", { noremap = true })
map("v", "<Tab>", "$", { noremap = true })
map("v", "<S>", "^", { noremap = true })

map("n", "<leader>bm", function()
  w.render_markdown()
end, { noremap = true })

local function spell_reload()
  vim.cmd(":mkspell! %")
end
map("n", "zR", spell_reload, { noremap = true, silent = true })

-- go to other bracket with treesitter
map("n", "m]", function()
  local ts_utils = require("nvim-treesitter.ts_utils")
  local node = ts_utils.get_node_at_cursor()
  if node then ts_utils.get_next_node(node, true, true) end
end, { noremap = true, silent = true })

-- go to help for selection

-- LSP Info / Lint
map("n", "<leader>cif", "<cmd>LazyFormatInfo<cr>", { desc = "Formatting" })
map("n", "<leader>cic", "<cmd>ConformInfo<cr>", { desc = "Conform" })
local linters = function()
  local linters_attached = require("lint").linters_by_ft[vim.bo.filetype]
  local buf_linters = {}

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

------------------------------------------------------------

local T = require("config.user.telescope_custom_finders")
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
      s = { util.editor.find_and_replace, "Find and Replace", mode = "v" },
      r = { "<Esc><cmd>lua require('telescope').extensions.refactoring.refactors()<CR>", "Select refactor..." },
    },
    b = {
      -- a = { function() require("harpoon"):list():append() end, "Harpoon->Append" },
      c = { util.editor.baleia_colorize, "Colorize" },
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
    -- C = {
    --   name = "ChatGPT",
    --   e = { "<cmd>ChatGPTEditWithInstructions<CR>", "Edit code with instructions", mode = { "n", "v" } },
    --   c = { "<cmd>ChatGPTEditWithInstructions<CR>", "Edit code with instructions", mode = { "n", "v" } },
    --   g = { "<cmd>ChatGPTRun grammar_correction<CR>", "Grammar Correction", mode = { "n", "v" } },
    --   t = { "<cmd>ChatGPTRun translate<CR>", "Translate", mode = { "n", "v" } },
    --   k = { "<cmd>ChatGPTRun keywords<CR>", "Keywords", mode = { "n", "v" } },
    --   d = { "<cmd>ChatGPTRun docstring<CR>", "Docstring", mode = { "n", "v" } },
    --   a = { "<cmd>ChatGPTRun add_tests<CR>", "Add Tests", mode = { "n", "v" } },
    --   o = { "<cmd>ChatGPTRun optimize_code<CR>", "Optimize Code", mode = { "n", "v" } },
    --   s = { "<cmd>ChatGPTRun summarize<CR>", "Summarize", mode = { "n", "v" } },
    --   f = { "<cmd>ChatGPTRun fix_bugs<CR>", "Fix Bugs", mode = { "n", "v" } },
    --   x = { "<cmd>ChatGPTRun explain_code<CR>", "Explain Code", mode = { "n", "v" } },
    --   r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "Roxygen Edit", mode = { "n", "v" } },
    --   l = { "<cmd>ChatGPTRun code_readability_analysis<CR>", "Code Readability Analysis", mode = { "n", "v" } },
    -- },
    c = {
      c = {
        name = "Copy/Reload",
        c = { util.copy_to_pbcopy, "Copy to clipboard", { noremap = true, silent = true } },
        p = {
          function()
            vim.api.nvim_call_function("setreg", { "+", vim.fn.expand("%:p") })
          end,
          "Copy absolute file path to clipboard",
        },
        P = {
          function()
            vim.api.nvim_call_function("setreg", { "+", vim.fn.fnamemodify(vim.fn.expand("%"), ":.") })
          end,
          "Copy file path to clipboard",
        },
        r = { "<cmd>lua vim.cmd('source ~/.config/nvim/init.lua')<CR>", "Reload config" },
      },
      d = {
        function()
          vim.cmd("echo 'here'")
          vim.schedule(function()
            vim.diagnostic.open_float({ source = true })
          end)
        end,
        "Line Diagnostics",
      },
      q = {
        function()
          vim.schedule(function()
            vim.diagnostic.open_float({ source = true })
          end)
        end,
        "Line diagnostics (source)",
      },
    },
    d = {
      S = { "<cmd>lua require('osv').launch({port=8086})<cr>", "Start OSV (port 8086)" },
    },
    f = {
      f = { ":Telescope find_files<CR>", { silent = true, desc = "Files" } },
      t = { ":Telescope live_grep<CR>", { silent = true, desc = "Grep (root dir" } },
      p = { ":Telescope projects<CR>", { silent = true, desc = "Projects" } },
      b = { ":Telescope buffers<CR>", { silent = true, desc = "Buffers" } },
      k = { ":Telescope keymaps<CR>", { silent = true, desc = "Keymaps" } },
      m = { ":Telescope macros<CR>", { silent = true, desc = "Macros" } },
      o = { ":!open .. vim.fn.expand('%:p:h') .. <cr>", "Reveal in finder" },
      l = {
        name = "Terminals/Lazyvim",
        c = {
          function()
            T.view_lazyvim_changelog()
          end,
          "Changelog",
        },
        -- f = {
        --   "<cmd>FloatermNew --name=floatroot --opener=edit --titleposition=center --height=0.85 --width=0.85 --cwd=<root><cr>",
        --   "Floating (root dir)",
        -- },
        -- F = {
        --   "<cmd>FloatermNew --name=floatbuffer --opener=edit --titleposition=center --height=0.85 --width=0.85 --cwd=<buffer><cr>",
        --   "Floating (cwd)",
        -- },
        -- s = {
        --   "<cmd>FloatermNew --name=splitroot --opener=edit --titleposition=center --height=0.35 --wintype=split --cwd=<root><cr>",
        --   "Split (root dir)",
        -- },
        -- S = {
        --   "<cmd>FloatermNew --name=splitbuffer --opener=edit --titleposition=center --height=0.35 --wintype=split --cwd=<buffer><cr>",
        --   "Split (cwd)",
        -- },
        g = {
          function()
            T.grep_lazyvim_files()
          end,
          "Grep lazyvim files",
        },
        l = {
          function()
            T.find_lazyvim_files()
          end,
          "Find lazyvim files",
        },
        m = {
          function()
            T.grep_config_files({})
          end,
          "Grep [m]y config files",
        },
        M = {
          function()
            T.find_config_files({})
          end,
          "Find [M]y config files",
        },
        p = {
          function()
            T.find_project_files()
          end,
          "Find project files",
        },
        i = {
          name = "Inspiration",
          i = {
            function()
              T.grep_inspiration_files({})
            end,
            "Grep Lunarvim files",
          },
          l = {
            function()
              T.grep_dir("lvim", {})
            end,
            "Grep Lunarvim files",
          },
          d = {
            function()
              T.grep_dir("doom", {})
            end,
            "Grep Doomnvim files",
          },
          a = {
            function()
              T.grep_dir("astrovim", {})
            end,
            "Grep Astrovim files",
          },
          f = {
            function()
              T.grep_dir("ftw", {})
            end,
            "Grep FTW files",
          },
          n = {
            function()
              T.grep_dir("nyoom", {})
            end,
            "Grep Nyoom files",
          },
          N = {
            function()
              T.grep_dir("nicoalbanese", {})
            end,
            "Grep nicoalbanese files",
          },
          m = {
            function()
              T.grep_dir("modern", {})
            end,
            "Grep modern-neovim files",
          },
          p = {
            function()
              T.grep_dir("pde", {})
            end,
            "Grep neovim-pde files",
          },
          F = {
            function()
              T.grep_dir("folke", {})
            end,
            "Grep folke files",
          },
          k = {
            function()
              vim.cmd("e /Users/aaron/.local/share/nvim/lazy/LazyVim/lua/lazyvim/config/keymaps.lua")
            end,
            "View LazyVim keymap",
          },
        },
      },
    },
    l = {
      l = { "<cmd>Lazy<cr>", "Lazy", { noremap = true } },
      e = { "<cmd>LazyExtras<cr>", "LazyExtras", { noremap = true } },
    },
    n = {
      e = { "<cmd>NoiceErrors<cr>", "Noice Errors" },
      t = { "<cmd>NoiceTelescope<cr>", "Noice", { noremap = true } },
    },
    g = {
      s = { "<cmd>lua search_google()<CR>", "Search Google" },
      d = { "<cmd>Telescope lsp_definitions<cr>", "Go to definition" },
      -- s = { "<cmd>Telescope lsp_document_symbols<cr>", "Go to symbol" },
      -- s = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Go to workspace symbol" },
    },
    u = {
      -- d = { LazyMod.toggle.diagnostics, "Toggle Diagnostics*" },
      S = {
        function()
          util.toggle_vim_g_variable("enable_leap_lightspeed_mode")
        end,
        "Enable leap lightspeed mode",
      },
      q = { "<Cmd>Trouble<cr>", "Show Trouble" },
    },
    s = {
      B = { "<cmd>Telescope bookmarks list<cr>", "Bookmarks" },
      n = { "<cmd>Telescope notify<cr>", "Telescope notify" },
      t = { "<cmd>Telescope todo<cr>", "Todo" },
      x = { "<cmd>lua require('sg.extensions.telescope').fuzzy_search_results()<CR>", "SG live grep" },
    },
    k = {
      --   r = {
      --     x = { clear_all_registers, "Clear all registers" },
      --   },
      k = {
        X = { util.clear_all_registers, "Clear all registers" },
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
      H = { w.switch_to_highest_window, "Switch to highest window" },
      q = { w.close_all_floating_windows, "Close all floating windows" },
    },
    x = {
      c = {
        function()
          vim.fn.setqflist({})
        end,
        "Clear Quickfix",
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

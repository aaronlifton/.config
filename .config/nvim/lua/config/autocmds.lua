-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
-- https://www.lazyvim.org/configuration/general

-- Location information about the last message printed. The format is
-- `(did print, buffer number, line number)`.
local last_echo = { false, -1, -1 }

-- The timer used for displaying a diagnostic in the commandline.
local echo_timer = nil

-- The timer after which to display a diagnostic in the commandline.
local echo_timeout = 250

-- The highlight group to use for warning messages.
local warning_hlgroup = "WarningMsg"

-- The highlight group to use for error messages.
local error_hlgroup = "ErrorMsg"

-- If the first diagnostic line has fewer than this many characters, also add
-- the second line to it.
local short_line_limit = 20

-- Shows the current line's diagnostics in a floating window.
-- local function show_line_diagnostics()
--   vim.lsp.diagnostic.show_line_diagnostics({ severity_limit = "Warning" }, vim.fn.bufnr())
-- end

-- Prints the first diagnostic for the current line.
local function echo_diagnostic()
  if echo_timer then
    echo_timer:stop()
  end

  echo_timer = vim.defer_fn(function()
    local line = vim.fn.line(".") - 1
    local bufnr = vim.api.nvim_win_get_buf(0)

    if last_echo[1] and last_echo[2] == bufnr and last_echo[3] == line then
      return
    end

    local diags = vim.lsp.diagnostic.get_line_diagnostics(bufnr, line, { severity = vim.diagnostic.severity.WARN })

    if #diags == 0 then
      -- If we previously echo'd a message, clear it out by echoing an empty
      -- message.
      if last_echo[1] then
        last_echo = { false, -1, -1 }

        vim.api.nvim_command('echo ""')
      end

      return
    end

    last_echo = { true, bufnr, line }

    local diag = diags[1]
    local width = vim.api.nvim_get_option_value("columns", {}) - 15
    local lines = { "unknown", "unknown" }
    if diag.message then
      lines = vim.split(diag.message, "\n")
    end
    local message = lines[1]
    -- local trimmed = false

    if #lines > 1 and #message <= short_line_limit then
      message = message .. " " .. lines[2]
    end

    if width > 0 and #message >= width then
      message = message:sub(1, width) .. "..."
    end

    local kind = "warning"
    local hlgroup = warning_hlgroup

    if diag.severity == vim.lsp.protocol.DiagnosticSeverity.Error then
      kind = "error"
      hlgroup = error_hlgroup
    end

    local chunks = {
      { kind .. ": ", hlgroup },
      { message },
    }

    vim.api.nvim_echo(chunks, false, {})
  end, echo_timeout)
end

vim.api.nvim_create_autocmd("CursorMoved", {
  callback = echo_diagnostic,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function(args)
    if args.data.filetype ~= "help" then
      vim.wo.number = true
    elseif args.data.bufname:match("*.csv") then
      vim.wo.wrap = false
    end
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "ColorScheme",
  callback = function()
    vim.api.nvim_echo({ { vim.api.nvim_buf_get_name(0), "none" } }, false, {})
    vim.api.nvim_set_hl(0, "LeapMatch", { guifg = "#000000", guibg = "#ffff00" })
    if vim.g.disable_leap_secondary_labels == true then
      local bg = vim.api.nvim_get_hl(0, { name = "LeapLabelSecondary" }).bg
      vim.api.nvim_set_hl(0, "LeapLabelSecondary", { fg = bg, bg = bg })
    end

    -- local leap = require('leap')
    -- require('leap').init_highlight(true)
  end,
})

-- Debug buffers
-- vim.api.nvim_create_autocmd("BufWinEnter", {
--   pattern = "*",
--   callback = function(ev)
--     local chunks = { { "event fired" }, { vim.inspect(ev) } }
--     vim.api.nvim_echo(chunks, false, {})
--   end,
-- })

local no_diagnostics_buffers = {
  "lazyterm",
  "floaterm",
  "toggleterm",
  "neo-tree",
  "NvimTree",
  "Trouble",
  "floatinghelp",
  "help",
}

local baleia = require("baleia").setup({})
vim.api.nvim_create_autocmd("BufWinEnter", {
  pattern = "*",
  callback = function(ev)
    -- debug :!=vim.api.nvim_buf_get_option(vim.api.nvim_get_current_buf(), "filetype")
    -- debug :!=vim.api.nvim_buf_get_option(vim.fn.bufnr("$"), "filetype")
    -- debug :!=vim.api.nvim_win_get_config(vim.fn.bufwinid(ev.buf)).zindex
    -- local bufnr = vim.api.nvim_get_current_buf()
    local bufnr = vim.fn.bufnr()
    local filetype = vim.api.nvim_get_option_value("filetype", { buf = bufnr })
    local buftype = vim.api.nvim_get_option_value("buftype", { buf = vim.fn.bufnr() })
    local bufname = vim.api.nvim_buf_get_name(ev.buf)
    if buftype ~= "nofile" then
      return
    end
    if bufname == "lazyterm" or filetype == "neo-tree" or bufname == "NvimTree" then
      return
    end

    local winid = vim.fn.bufwinid(ev.buf)
    if vim.api.nvim_win_get_config(winid).zindex then
      -- local chunks = { { "event fired" }, { vim.inspect(ev) } }
      -- vim.api.nvim_echo(chunks, false, {})

      baleia.automatically(vim.fn.bufnr())
      -- baleia.automatically(vim.fn.bufnr(ev.buf))
      -- baleia.once(vim.fn.bufnr(ev.buf))
    end
  end,
})

-- no folding if buffer is bigger then 1 mb
-- TODO: need to used other then `opt` that is not correct here

-- vim.api.nvim_create_autocmd("BufReadPre", {
--   group = "disable_folding",
--   callback = function(ev)
--     local ok, size = pcall(vim.fn.getfsize, vim.api.nvim_buf_get_name(vim.fn.bufnr()))
--     if not ok or size > 1024 * 1024 then
--       -- fallback to default values
--       vim.opt.foldmethod = "manual"
--       vim.opt.foldexpr = "0"
--       vim.opt.foldlevel = 0
--       vim.opt.foldtext = "foldtext()"
--     else
--       vim.opt.foldmethod = "expr"
--       vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
--       vim.opt.foldlevel = 99
--       vim.opt.foldtext = "v:lua.vim.treesitter.foldtext()"
--     end
--   end,
-- })

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

local ac = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup

-- Disable diagnostics in a .env file
ac("BufRead", {
  pattern = { ".env", "help" },
  callback = function()
    vim.diagnostic.disable(0)
  end,
})

-- -- Fix telescope entering on insert mode
ac("WinLeave", {
  callback = function()
    if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
    end
  end,
})
--
local auto_close_filetype = {
  "lazy",
  "lspinfo",
  "toggleterm",
  -- "null-ls-info",
  -- "TelescopePrompt",
  "notify",
}

-- Auto close window when leaving
ac("BufLeave", {
  group = ag("lazyvim_auto_close_win", { clear = true }),
  callback = function(event)
    local ft = vim.api.nvim_buf_get_option(event.buf, "filetype")

    if vim.fn.index(auto_close_filetype, ft) ~= -1 then
      local winids = vim.fn.win_findbuf(event.buf)
      if not winids then
        return
      end
      for _, win in pairs(winids) do
        vim.api.nvim_win_close(win, true)
      end
    end
  end,
})

local to_close_with_esc_or_q = {
  "PlenaryTestPopup",
  "help",
  "lspinfo",
  "man",
  "notify",
  "qf",
  "query",
  "spectre_panel",
  "startuptime",
  "tsplayground",
  "neotest-output",
  "checkhealth",
  "neotest-summary",
  "neotest-output-panel",
  "toggleterm",
  -- "floaterm",
  "lsp-installer",
  "DressingSelect",
}
-- close some filetypes with <esc>, in addition to <q>
ac("FileType", {
  group = augroup("close_with_esc"),
  pattern = to_close_with_esc_or_q,
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "<esc>", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- close additional filetypes with <q>
ac("FileType", {
  group = augroup("close_with_q"),
  pattern = to_close_with_esc_or_q,
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Delete number column on terminals
-- ac("TermOpen", {
--   callback = function()
--     vim.cmd("setlocal listchars=nonumber norelativenumber")
--   end,
-- })

-- Disable next line comments
ac("BufEnter", {
  callback = function()
    vim.cmd("set formatoptions-=cro")
    vim.cmd("setlocal formatoptions-=cro")
  end,
})

-- Disable eslint on node_modules
ac({ "BufNewFile", "BufRead" }, {
  group = ag("DisableEslintOnNodeModules", { clear = true }),
  pattern = { "**/node_modules/**", "node_modules", "/node_modules/*" },
  callback = function()
    vim.diagnostic.disable(0)
  end,
})

-- Use the more sane snippet session leave logic. Copied from:
-- https://github.com/L3MON4D3/LuaSnip/issues/258#issuecomment-1429989436
if not vim.g.native_snippets_enabled then
  ac("ModeChanged", {
    pattern = "*",
    callback = function()
      if
        ((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
        and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require("luasnip").session.jump_active
      then
        require("luasnip").unlink_current()
      end
    end,
  })
end

local uv = vim.uv
-- Create a dir when saving a file if it doesn't exist
ac("BufWritePre", {
  group = ag("auto_create_dir", { clear = true }),
  callback = function(args)
    if args.match:match("^%w%w+://") then
      return
    end
    local file = uv.fs_realpath(args.match) or args.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- folke
-- create directories when needed, when saving a file
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group = vim.api.nvim_create_augroup("better_backup", { clear = true }),
--   callback = function(event)
--     local file = vim.loop.fs_realpath(event.match) or event.match
--     local backup = vim.fn.fnamemodify(file, ":p:~:h")
--     backup = backup:gsub("[/\\]", "%%")
--     vim.go.backupext = backup
--   end,
-- })
ac("FileType", {
  pattern = "help",
  callback = function(args)
    local buf = args.buf
    vim.b[buf].minianimate_disable = true
    vim.opt_local.textwidth = 80
  end,
})

-- -- Fix telescope entering on insert mode
ac("WinLeave", {
  callback = function()
    if vim.bo.ft == "TelescopePrompt" and vim.fn.mode() == "i" then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "i", false)
    end
  end,
})
--
local auto_close_filetype = {
  "lazy",
  "lspinfo",
  "toggleterm",
  -- "null-ls-info",
  -- "TelescopePrompt",
  "notify",
}

-- Auto close window when leaving
ac("BufLeave", {
  group = ag("lazyvim_auto_close_win", { clear = true }),
  callback = function(event)
    local ft = vim.api.nvim_buf_get_option(event.buf, "filetype")

    if vim.fn.index(auto_close_filetype, ft) ~= -1 then
      local winids = vim.fn.win_findbuf(event.buf)
      if not winids then
        return
      end
      for _, win in pairs(winids) do
        vim.api.nvim_win_close(win, true)
      end
    end
  end,
})

local to_close_with_esc_or_q = {
  "PlenaryTestPopup",
  "help",
  "lspinfo",
  "man",
  "notify",
  "qf",
  "query",
  "spectre_panel",
  "startuptime",
  "tsplayground",
  "neotest-output",
  "checkhealth",
  "neotest-summary",
  "neotest-output-panel",
  "toggleterm",
  "floaterm",
  "lsp-installer",
  "DressingSelect",
}
-- close some filetypes with <esc>, in addition to <q>
ac("FileType", {
  group = augroup("close_with_esc"),
  pattern = to_close_with_esc_or_q,
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "<esc>", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- close additional filetypes with <q>
ac("FileType", {
  group = augroup("close_with_q"),
  pattern = to_close_with_esc_or_q,
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

ac("FileType", {
  pattern = "help",
  callback = function(event)
    vim.b[event.buf].minianimate_disable = true
    vim.opt_local.textwidth = 80
  end,
})

ac("FileType", {
  pattern = { ".ts", ".tsx", ".js", ".jsx" },
  callback = function(event)
    -- vim.lsp.inlay_hint.is_enabled()
    vim.lsp.inlay_hint.enable(event.buf, false)
    vim.cmd("echo 'hello'")
  end,
})

-- Delete number column on terminals
-- ac("TermOpen", {
--   callback = function()
--     vim.cmd("setlocal listchars=nonumber norelativenumber")
--   end,
-- })

-- Disable next line comments
ac("BufEnter", {
  callback = function()
    vim.cmd("set formatoptions-=cro")
    vim.cmd("setlocal formatoptions-=cro")
  end,
})

-- Disable eslint on node_modules
ac({ "BufNewFile", "BufRead" }, {
  group = ag("DisableEslintOnNodeModules", { clear = true }),
  pattern = { "**/node_modules/**", "node_modules", "/node_modules/*" },
  callback = function()
    vim.diagnostic.disable(0)
  end,
})

-- Use the more sane snippet session leave logic. Copied from:
-- https://github.com/L3MON4D3/LuaSnip/issues/258#issuecomment-1429989436
if not vim.g.native_snippets_enabled then
  ac("ModeChanged", {
    pattern = "*",
    callback = function()
      if
        ((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
        and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require("luasnip").session.jump_active
      then
        require("luasnip").unlink_current()
      end
    end,
  })
end

-- Create a dir when saving a file if it doesn't exist
ac("BufWritePre", {
  group = ag("auto_create_dir", { clear = true }),
  callback = function(args)
    if args.match:match("^%w%w+://") then
      return
    end
    local file = vim.uv.fs_realpath(args.match) or args.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- folke
-- create directories when needed, when saving a file
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   group = vim.api.nvim_create_augroup("better_backup", { clear = true }),
--   callback = function(event)
--     local file = vim.loop.fs_realpath(event.match) or event.match
--     local backup = vim.fn.fnamemodify(file, ":p:~:h")
--     backup = backup:gsub("[/\\]", "%%")
--     vim.go.backupext = backup
--   end,
-- })

-- NOTE: Originally tried to put this in FileType event autocmd but it is apparently too early for `set modifiable` to take effect
-- vim.api.nvim_create_autocmd("BufWinEnter", {
--   group = vim.api.nvim_create_augroup("quickfix", { clear = true }),
--   desc = "Allow updating quickfix window",
--   pattern = "quickfix",
--   callback = function(ctx)
--     vim.bo.modifiable = true
--     -- :vimgrep's quickfix window display format now includes start and end column (in vim and nvim) so adding 2nd format to match that
--     vim.bo.errorformat = "%f|%l col %c| %m,%f|%l col %c-%k| %m"
--     vim.keymap.set(
--       "n",
--       "<C-s>",
--       '<Cmd>cgetbuffer|set nomodified|echo "quickfix/location list updated"<CR>',
--       { buffer = true, desc = "Update quickfix/location list with changes made in quickfix window" }
--     )
--   end,
-- })

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesWindowOpen",
  callback = function(args)
    local win_id = args.data.win_id

    -- Customize window-local settings
    -- vim.wo[win_id].winblend = 50
    vim.api.nvim_win_set_config(win_id, { border = "double" })
  end,
})

local show_dotfiles = true

local filter_show = function(fs_entry)
  return true
end

local filter_hide = function(fs_entry)
  return not vim.startswith(fs_entry.name, ".")
end

local toggle_dotfiles = function()
  show_dotfiles = not show_dotfiles
  local new_filter = show_dotfiles and filter_show or filter_hide
  MiniFiles.refresh({ content = { filter = new_filter } })
end

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    -- Tweak left-hand side of mapping to your liking
    vim.keymap.set("n", "g.", toggle_dotfiles, { buffer = buf_id })
  end,
})

local map_split = function(buf_id, lhs, direction)
  local rhs = function()
    -- Make new window and set it as target
    local new_target_window
    vim.api.nvim_win_call(MiniFiles.get_target_window(), function()
      vim.cmd(direction .. " split")
      new_target_window = vim.api.nvim_get_current_win()
    end)

    MiniFiles.set_target_window(new_target_window)
  end

  -- Adding `desc` will result into `show_help` entries
  local desc = "Split " .. direction
  vim.keymap.set("n", lhs, rhs, { buffer = buf_id, desc = desc })
end

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    local buf_id = args.data.buf_id
    -- Tweak keys to your liking
    map_split(buf_id, "gs", "belowright horizontal")
    map_split(buf_id, "gv", "belowright vertical")
  end,
})

local files_set_cwd = function(path)
  -- Works only if cursor is on the valid file system entry
  local cur_entry_path = MiniFiles.get_fs_entry().path
  local cur_directory = vim.fs.dirname(cur_entry_path)
  vim.fn.chdir(cur_directory)
end

vim.api.nvim_create_autocmd("User", {
  pattern = "MiniFilesBufferCreate",
  callback = function(args)
    vim.keymap.set("n", "g~", files_set_cwd, { buffer = args.data.buf_id })
  end,
})

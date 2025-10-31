-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function lazyvim_augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = false })
end

local ac = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup
local Util = require("util")

local enabled_autocommands = {
  numbertoggle = false,
}

-- Before
-- local function augroup(name)
--   return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
-- end
-- local close_with_q = {
--   -- LazyVim/lua/lazyvim/config/autocmds.lua:54
--   "PlenaryTestPopup",
--   "checkhealth",
--   "dbout",
--   "gitsigns-blame",
--   "grug-far",
--   -- "help", -- Removed
--   "lspinfo",
--   "neotest-output",
--   "neotest-summary",
--   "neotest-output-panel",
--   "notify",
--   "qf",
--   "spectre_panel",
--   "startuptime",
--   "tsplayground",
--   -- Added
--   "query",
--   "grapple",
-- }
-- local close_with_esc_or_q = {
--   "neoai-input",
--   "neoai-output",
--   "chatgpt-input",
--   "chatgpt-output",
-- }
-- vim.list_extend(close_with_esc_or_q, close_with_q)
-- vim.api.nvim_clear_autocmds({ group = "lazyvim_close_with_q" })
-- ac("FileType", {
--   group = augroup("close_with_q"),
--   pattern = close_with_esc_or_q,
--   callback = function(event)
--     vim.bo[event.buf].buflisted = false
--     vim.schedule(function()
--       vim.keymap.set("n", "q", function()
--         vim.cmd("close")
--         pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
--       end, {
--         buffer = event.buf,
--         silent = true,
--         desc = "Quit buffer",
--       })
--     end)
--   end,
-- })

-- NOTE: for testing heirline
-- ac({ "VimEnter" }, {
--   desc = "Nvim user event that trigger a few ms after nvim starts",
--   callback = function()
--     if not package.loaded["heirline"] then return end
--
--     -- If nvim is opened passing a filename, trigger the event inmediatelly.
--     if #vim.fn.argv() >= 1 then
--       -- In order to avoid visual glitches.
--       Util.trigger_event("User BaseDefered", true)
--       Util.trigger_event("BufEnter", true) -- also, initialize tabline_buffers.
--     else -- Wait some ms before triggering the event.
--       vim.defer_fn(function()
--         Util.trigger_event("User BaseDefered")
--       end, 70)
--     end
--   end,
-- })

-- NOTE: https://github.com/LazyVim/LazyVim/issues/80#issuecomment-1478662212
ac("BufEnter", {
  group = ag("LazyVimOverrides", { clear = false }),
  command = "set formatoptions-=o",
})

-- After
local close_buf = function(event)
  vim.bo[event.buf].buflisted = false

  vim.schedule(function()
    if not vim.api.nvim_buf_is_valid(event.buf) then return end

    vim.keymap.set("n", "q", function()
      vim.cmd("close")
      pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
    end, {
      buffer = event.buf,
      silent = true,
      desc = "Quit buffer",
    })
  end)
end

local close_with_q = { "query", "grapple" }
ac("FileType", {
  group = lazyvim_augroup("close_with_q"),
  pattern = close_with_q,
  callback = close_buf,
})

local lua_reload_ag = ag("LuaReloadModule", { clear = true })
ac("BufWritePost", {
  group = lua_reload_ag,
  -- /opt/homebrew/Cellar/neovim/0.11.4/share/nvim/runtime/doc/autocmd.txt:1273
  pattern = "~/.config/nvim/lua/*.lua",
  callback = function()
    local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
    -- Only reload if the first line is local M = {}
    if first_line and first_line:match("^local%s+M%s*=%s*{}") then
      local file_path = vim.fn.expand("%:p")
      local module_name = vim.fn.fnamemodify(file_path, ":.:r")

      package.loaded[module_name] = nil

      vim.notify("Module Reloaded:" .. module_name, nil, {
        title = "Notification",
        timeout = 500,
        render = "compact",
      })
    end
  end,
  desc = "Reload the current module on save",
})

-- Disable diagnostics in a .env file
-- ac("BufRead", {
--   pattern = ".env",
--   callback = function()
--     vim.diagnostic.enable(false)
--   end,
-- })

-- https://nvchad.com/docs/recipes
ac("VimEnter", {
  command = ":silent !kitty @ set-spacing padding=0 margin=0",
})

ac("VimLeavePre", {
  command = ":silent !kitty @ set-spacing padding=20 margin=10",
})

-- local format_sync_grp = vim.api.nvim_create_augroup("GoImports", {})
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = "*.go",
--   callback = function()
--     require("go.format").goimports()
--   end,
--   group = format_sync_grp,
-- })
-- local auto_close_filetype = {
--   "lazy",
--   "mason",
--   "lspinfo",
--   "toggleterm",
--   "null-ls-info",
--   "TelescopePrompt",
--   "notify",
-- }
--
-- -- Auto close window when leaving
-- ac("BufLeave", {
--   group = ag("lazyvim_auto_close_win", { clear = true }),
--   callback = function(event)
--     local ft = vim.api.nvim_buf_get_option(event.buf, "filetype")
--
--     if vim.fn.index(auto_close_filetype, ft) ~= -1 then
--       local winids = vim.fn.win_findbuf(event.buf)
--       for _, win in pairs(winids) do
--         vim.api.nvim_win_close(win, true)
--       end
--     end
--   end,
-- })

-- Disable leader and localleader for some filetypes
-- ac("FileType", {
--   group = ag("lazyvim_unbind_leader_key", { clear = true }),
--   pattern = {
--     "lazy",
--     "mason",
--     "lspinfo",
--     "toggleterm",
--     "null-ls-info",
--     "neo-tree-popup",
--     "TelescopePrompt",
--     "notify",
--     "floaterm",
--   },
--   callback = function(event)
--     vim.keymap.set("n", "<leader>", "<nop>", { buffer = event.buf, desc = "" })
--     vim.keymap.set("n", "<leader>", "<nop>", { buffer = event.buf, desc = "" })
--     vim.keymap.set("n", "<localleader>", "<nop>", { buffer = event.buf, desc = "" })
--   end,
-- })

-- Delete number column on terminals (floaterm)
-- ac("TermOpen", {
--   callback = function()
--     vim.cmd("setlocal listchars= nonumber norelativenumber")
--     vim.cmd("setlocal nospell")
--   end,
-- })

-- Disable eslint on node_modules
-- ac({ "BufNewFile", "BufRead" }, {
--   group = ag("DisableEslintOnNodeModules", { clear = true }),
--   pattern = { "**/node_modules/**", "node_modules", "/node_modules/*" },
--   callback = function()
--     vim.diagnostic.enable(false)
--   end,
-- })

-- Toggle between relative/absolute line numbers
if enabled_autocommands.numbertoggle then
  local numbertoggle = ag("numbertoggle", { clear = true })
  ac({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
    pattern = "*",
    group = numbertoggle,
    callback = function()
      if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then vim.opt.relativenumber = true end
    end,
  })

  ac({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
    pattern = "*",
    group = numbertoggle,
    callback = function()
      if vim.o.nu then
        vim.opt.relativenumber = false
        vim.cmd.redraw()
      end
    end,
  })
end

-- BufNew ?
ac({ "BufEnter" }, {
  pattern = { "*.md", "help", "log" },
  group = ag("Textfiles", { clear = true }),
  callback = function(event)
    vim.opt_local.spell = false
    if vim.tbl_contains({ "log" }, event.match) then vim.diagnostic.enable(false) end
  end,
})

vim.filetype.add({
  filename = {
    ["Tiltfile"] = "tiltfile",
    [".tiltfile"] = "tiltfile",
  },
})
vim.api.nvim_create_autocmd({ "FileType" }, {
  group = vim.api.nvim_create_augroup("snacks_bigfile", { clear = true }),
  pattern = "bigfile",
  callback = function(ev)
    -- vim.opt_local:set("syntax", "starlark")
    vim.bo[ev.buf].syntax = "starlark"
  end,
}) --

-- NOTE: what is this:?
-- Clear the quickfix window keymap set on BufEnter
-- ac({ "BufEnter", "BufWinEnter" }, {
--   pattern = "qf",
--   callback = function()
--     vim.keymap.set("n", "<C-d>", function()
--       vim.fn.setqflist({})
--     end, { buffer = true })
--   end,
-- })

ac({ "FileType" }, {
  pattern = { "json", "javascript" },
  callback = function(args)
    vim.keymap.set("n", "<leader>cpj", function()
      require("util.treesitter.copy_path").copy_json_path({ register = "*" })
    end, { desc = "Copy JSON Path", buffer = args.buf })
  end,
})

ac({ "FileType" }, {
  pattern = { "ruby" },
  callback = function(args)
    vim.keymap.set("n", "<leader>cpj", function()
      require("util.treesitter.copy_path").copy_ruby_path({ register = "*" })
    end, { desc = "Copy Ruby Path", buffer = args.buf })
  end,
})

-- ac({ "FileType" }, {
--   pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
--   callback = function(args)
--     vim.keymap.set("n", "<leader>ccj", function()
--       copy_path.copy_javascript_path({ register = "*" })
--     end, { buffer = args.buf })
--   end,
-- })

ac({ "FileType" }, {
  pattern = { "markdown", "mchat" },
  callback = function(args)
    vim.keymap.set("n", "]n", function()
      require("util.movement").find_next_ordered_list_item()
    end, { desc = "Next in ordered list", remap = true, buffer = true })
    vim.keymap.set("n", "[n", function()
      require("util.movement").find_prev_ordered_list_item()
    end, { desc = "Prev in ordered list", remap = true, buffer = true })
  end,
})

-- render-markdown.nvim is automatically enabled by the ft spec in the
-- render-markdown dependency of model.nvim, but it still needs to be enabled
-- for mchat buffers
ac({ "FileType" }, {
  pattern = { "mchat" },
  callback = function(args)
    if vim.bo[args.buf].buflisted then require("render-markdown").enable() end
  end,
})

ac({ "FileType" }, {
  pattern = { "*js.snap" },
  callback = function(_args)
    vim.cmd("set ft=html")
  end,
})

-- Modified from snacks.bigfile
-- TODO: see if it's worth to copy anhd extend snacks.bigfile instead of
-- keeping a filename list.
local bigfiles = { "common.json" }
ac({ "BufRead" }, {
  callback = function(ctx)
    local filepath = vim.api.nvim_buf_get_name(ctx.buf)
    local filename = filepath:match("([^/]+)$")
    for _, bigfile in ipairs(bigfiles) do
      if filename == bigfile then
        -- local ft = vim.filetype.match({ buf = args.buf }) or ""
        -- vim.schedule(function()
        --   vim.bo[args.buf].syntax = ft
        -- end)
        -- vim.bo[args.buf].filetype = "bigfile"
        if vim.fn.exists(":NoMatchParen") ~= 0 then vim.cmd([[NoMatchParen]]) end
        Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
        vim.b.minianimate_disable = true
        vim.schedule(function()
          if vim.api.nvim_buf_is_valid(ctx.buf) then vim.bo[ctx.buf].syntax = ctx.ft end
        end)
        break
      end
    end
  end,
})

-- Re-add <leader>gl keymap deleted by lazyvim gitui extra
ac("User", {
  pattern = "LazyVimKeymaps",
  once = true,
  callback = function()
    -- Override gitui/snacks.picker keymap with lazygit, as this mapping gets
    -- deleted here: LazyVim/lua/lazyvim/plugins/extras/util/gitui.lua:30
    vim.keymap.set("n", "<leader>gl", function()
      Snacks.lazygit.log({ cwd = LazyVim.root.git() })
    end, { desc = "Lazygit Log" })
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "LazyLoad",
  desc = "Initialize Util module",
  callback = function(args)
    require("util")
  end,
})

-- require("util.ui.lsp").advanced_lsp_progress_autocmd()

-- already set by smart-splits.nvim (var:is_nvim)
-- ac({ "VimEnter", "VimResume" }, {
--   group = vim.api.nvim_create_augroup("KittySetVarVimEnter", { clear = true }),
--   callback = function()
--     io.stdout:write("\x1b]1337;SetUserVar=in_editor=MQo\007")
--   end,
-- })
--
-- ac({ "VimLeave", "VimSuspend" }, {
--   group = vim.api.nvim_create_augroup("KittyUnsetVarVimLeave", { clear = true }),
--   callback = function()
--     io.stdout:write("\x1b]1337;SetUserVar=in_editor\007")
--   end,
-- })

-- require("config.abstract.autocmds").auto_resize_splited_window()
local vim_resized_group = ag("VimResized", { clear = true })
ac("VimResized", {
  group = vim_resized_group,
  desc = "Auto-resize split windows",
  pattern = "*",
  command = "tabdo wincmd =",
})

-- lazyvim/util/init.lua:185
ac("User", {
  pattern = "LazyLoad",
  desc = "Initialize Util module",
  callback = function(event)
    require("util")
  end,
})

ac("FileChangedShell", {
  group = ag("RAPluginsInterruptless", { clear = true }),
  callback = function()
    vim.v.fcs_choice = "just do nothing"

    local filename = vim.fn.expand("<afile>")

    if vim.v.fcs_reason == "conflict" then
      vim.fn.notify(
        [[Warning: File "]] .. filename .. [[" has changed and the buffer was changed in Vim as well]],
        vim.log.levels.WARN
      )
    end
  end,
})

local avante_group = ag("Avante", { clear = true })

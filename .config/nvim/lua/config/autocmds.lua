-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

local ac = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup

-- LazyVim/lua/lazyvim/config/autocmds.lua:53
local lazyvim_close_with_q_filetypes = {
  "PlenaryTestPopup",
  "help",
  "lspinfo",
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
}
local to_close_with_esc_or_q = {
  "neoai-input",
  "neoai-output",
}
for _, ft in ipairs(lazyvim_close_with_q_filetypes) do
  table.insert(to_close_with_esc_or_q, ft)
end
-- vim.api.nvim_clear_autocmds({ group = "lazyvim_close_with_q" })
ac("FileType", {
  group = augroup("close_with_q"),
  pattern = to_close_with_esc_or_q,
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- close some filetypes with <esc>, in addition to <q>
ac("FileType", {
  group = augroup("close_with_esc"),
  pattern = to_close_with_esc_or_q,
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "<esc>", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- Disable diagnostics in a .env file
ac("BufRead", {
  pattern = ".env",
  callback = function()
    vim.diagnostic.disable(0)
  end,
})

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
-- Disabled: investigating terminal opening flash
ac("TermOpen", {
  callback = function()
    vim.defer_fn(function()
      vim.cmd("setlocal listchars= nonumber norelativenumber")
      vim.cmd("setlocal nospell")
    end, 1500)
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

local numbertoggle = ag("numbertoggle", { clear = true })
-- Toggle between relative/absolute line numbers
ac({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
  pattern = "*",
  group = numbertoggle,
  callback = function()
    if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
      vim.opt.relativenumber = true
    end
  end,
})

ac({ "BufEnter" }, {
  pattern = "*.md",
  group = ag("readme", { clear = true }),
  callback = function()
    -- if at project root then disable diagnostics
    if vim.fn.getcwd() == vim.fn.expand("%:p:h") then
      vim.diagnostic.disable(0)
    end
  end,
})

-- INFO: This was causing the terminal flash
-- Disabled: investigating terminal opening flash
-- ac({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
--   pattern = "*",
--   group = numbertoggle,
--   callback = function()
--     local ft = vim.bo.ft
--     if ft == "floaterm" or ft == "toggleterm" or ft == "terminal" then
--       return
--     end
--     if vim.o.nu then
--       vim.opt.relativenumber = false
--       vim.cmd.redraw()
--     end
--   end,
-- })

-- Use the more sane snippet session leave logic. Copied from:
-- https://github.com/L3MON4D3/LuaSnip/issues/258#issuecomment-1429989436
ac("ModeChanged", {
  pattern = "*",
  callback = function()
    if not vim.g.vscode then
      if
        ((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
        and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
        and not require("luasnip").session.jump_active
      then
        require("luasnip").unlink_current()
      end
    end
  end,
})

ac("ColorScheme", {
  pattern = "*",
  group = ag("fix_highlights", { clear = true }),
  callback = function()
    require("config.highlights").setup()
    vim.api.nvim_echo({ { "Highlights updated", "Normal" } }, false, {})
  end,
})

-- ac("WinLeave", {
-- 	pattern = "*",
-- 	group = ag("remember_last_win", { clear = true }),
-- 	callback = function(event)
-- 		vim.print(vim.inspect(event))
-- 		vim.g.last_winid = event.win
-- 	end,
-- })

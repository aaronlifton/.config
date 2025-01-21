-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

local ac = vim.api.nvim_create_autocmd
local ag = vim.api.nvim_create_augroup

local close_with_q = {
  -- LazyVim/lua/lazyvim/config/autocmds.lua:53
  "PlenaryTestPopup",
  "grug-far",
  -- "help", -- Removed
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
  "dbout",
  "gitsigns-blame",
  -- Added
  "toggleterm",
  "grapple",
}
local close_with_esc_or_q = {
  "neoai-input",
  "neoai-output",
  "chatgpt-input",
  "chatgpt-output",
}
vim.list_extend(close_with_esc_or_q, close_with_q)
vim.api.nvim_clear_autocmds({ group = "lazyvim_close_with_q" })
ac("FileType", {
  group = augroup("close_with_q"),
  pattern = close_with_esc_or_q,
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", {
      buffer = event.buf,
      silent = true,
      desc = "Quit buffer",
    })
  end,
})

-- close some filetypes with <esc>, in addition to <q>
-- ac("FileType", {
--   group = augroup("close_with_esc"),
--   pattern = to_close_with_esc_or_q,
--   callback = function(event)
--     vim.bo[event.buf].buflisted = false
--     vim.keymap.set("n", "<esc>", "<cmd>close<cr>", { buffer = event.buf, silent = true })
--   end,
-- })

-- Disable diagnostics in a .env file
ac("BufRead", {
  pattern = ".env",
  callback = function()
    vim.diagnostic.enable(false)
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
    vim.diagnostic.enable(false)
  end,
})
--
-- local numbertoggle = ag("numbertoggle", { clear = true })
-- -- Toggle between relative/absolute line numbers
-- ac({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
--   pattern = "*",
--   group = numbertoggle,
--   callback = function()
--     if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
--       vim.opt.relativenumber = true
--     end
--   end,
-- })

ac({ "BufEnter" }, {
  pattern = { "*.md", "help" },
  group = ag("readme", { clear = true }),
  callback = function()
    -- if at project root then disable diagnostics
    -- if vim.fn.getcwd() == vim.fn.expand("%:p:h") then
    -- local filename = vim.fn.expand("%:t")
    -- if filename == "README.md" or filename == "CHANGELOG.md" then
    --   vim.diagnostic.enable(false)
    --   vim.api.nvim_echo({ { "Disabled diagnostics", "Special" } }, false, {})
    -- end
    vim.opt_local.spell = false
  end,
})

ac({ "BufNewFile", "BufRead" }, {
  pattern = { "Tiltfile", "*.tiltfile" },
  group = ag("tiltfile", { clear = true }),
  callback = function()
    vim.api.nvim_command(":set ft=tiltfile syntax=starlark")
  end,
})

-- ac({ "FileType" }, {
--   pattern = { "help" },
--   group = ag("readme", { clear = true }),
--   callback = function(args)
--     vim.api.nvim_command(":sleep 50m<cr>")
--     vim.schedule_wrap(function()
--       vim.treesitter.stop(args.buf)
--     end)
--   end,
-- })

ac("ColorScheme", {
  pattern = "*",
  group = ag("fix_highlights", { clear = true }),
  callback = function()
    require("config.highlights").setup()
  end,
})

-- Clear the quickfix window keymap set on BufEnter
ac({ "BufEnter", "BufWinEnter" }, {
  pattern = "qf",
  callback = function()
    vim.keymap.set("n", "<C-d>", function()
      vim.fn.setqflist({})
    end, { buffer = true })
  end,
})

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

ac({ "FileType" }, {
  pattern = { "markdown" },
  callback = function(_args)
    vim.opt_local.spell = false
  end,
})

ac({ "FileType" }, {
  pattern = { "mchat" },
  callback = function(args)
    if vim.bo[args.buf].buflisted then require("render-markdown").enable() end
  end,
})

ac({ "FileType" }, {
  pattern = { "log" },
  callback = function(_args)
    vim.opt_local.spell = false
    vim.diagnostic.enable(false)
  end,
})

-- NOTE: Doesn't work since avante sets the buffer cmp right after this
-- Add multi-buffer word completion to AvanteInput
-- ac({ "FileType" }, {
--   pattern = { "AvanteInput" },
--   callback = function(_args)
--     require("cmp").setup.buffer({
--       sources = {
--         {
--           name = "buffer",
--           option = {
--             get_bufnrs = require("util.win").editor_bufs,
--           },
--         },
--       },
--     })
--   end,
-- })

-- Replaced by default keymap <C-w>g<Tab>
-- ac({ "TabLeave" }, {
--   callback = function()
--     local tabpage = vim.api.nvim_get_current_tabpage()
--     vim.g.last_tabpage = tabpage
--   end,
-- })

local bigfiles = {
  "common.json",
  "listing_drafts_controller_spec.rb",
}

-- Modified from snacks.bigfile
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
        vim.cmd([[NoMatchParen]])
        Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
        vim.b.minianimate_disable = true
        vim.schedule(function()
          vim.bo[ctx.buf].syntax = ctx.ft
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
    vim.keymap.set("n", "<leader>gl", function()
      Snacks.lazygit.log({ cwd = LazyVim.root.git() })
    end, { desc = "Lazygit Log" })
    -- Use Snacks.git.blame_line until Snacks.picker.git_log_line improves
    vim.keymap.set("n", "<leader>gb", function()
      Snacks.git.blame_line()
    end, { desc = "Git Blame Line" })
  end,
})

-- require("util.ui.lsp").advanced_lsp_progress_autocmd()

-- Already set by smart-splits.nvim (var:IS_NVIM)
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

-- ac({ "FileType" }, {
--   pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
--   callback = function(args)
--     vim.keymap.set("n", "<leader>ccj", function()
--       copy_path.copy_javascript_path({ register = "*" })
--     end, { buffer = args.buf })
--   end,
-- })

-- ac("WinLeave", {
-- 	pattern = "*",
-- 	group = ag("remember_last_win", { clear = true }),
-- 	callback = function(event)
-- 		vim.print(vim.inspect(event))
-- 		vim.g.last_winid = event.win
-- 	end,
-- })

-- local ag_view_activated = ag("view_activated", { clear = true })
-- ac({ "BufWinLeave", "BufWritePost", "WinLeave" }, {
--   group = ag_view_activated,
--   desc = "Save view with mkview for real files",
--   callback = function(event)
--     if vim.b[event.buf].view_activated then
--       vim.api.nvim_echo({ { "Saving view", "Special" } }, false, {})
--       vim.cmd.mkview({ mods = { emsg_silent = true } })
--     end
--   end,
-- })
-- ac("BufWinEnter", {
--   group = ag_view_activated,
--   desc = "Try to load file view if available and enable view saving for real files",
--   callback = function(event)
--     if not vim.b[event.buf].view_activated then
--       local filetype = vim.bo[event.buf].filetype
--       local buftype = vim.bo[event.buf].buftype
--       local ignore_filetypes = { "gitcommit", "gitrebase", "svg", "hgcommit" }
--       if buftype == "" and filetype and filetype ~= "" and not vim.tbl_contains(ignore_filetypes, filetype) then
--         vim.api.nvim_echo({ { "Loading view", "Special" } }, false, {})
--         vim.b[event.buf].view_activated = true
--         vim.cmd.loadview({ mods = { emsg_silent = true } })
--       end
--     end
--   end,
-- })

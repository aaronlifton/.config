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
  -- "help", -- Removed
  "lspinfo",
  "notify",
  "qf",
  "query",
  "startuptime",
  "tsplayground",
  "neotest-output",
  "checkhealth",
  "neotest-summary",
  "neotest-output-panel",
  "dbout",
  "gitsigns.blame",
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
    vim.diagnostic.disable(0)
  end,
})

ac("BufRead", {
  pattern = "*_spec.rb",
  callback = function()
    local ai = require("mini.ai")
    vim.b.miniai_config = {
      custom_textobjects = {
        C = ai.gen_spec.treesitter({
          a = { "@rspec.context" },
          i = { "@rspec.context" },
        }),
        I = ai.gen_spec.treesitter({
          a = { "@rspec.it" },
          i = { "@rspec.it" },
        }),
        E = ai.gen_spec.treesitter({
          a = { "@rspec.expect" },
          i = { "@rspec.expect" },
        }),
        M = ai.gen_spec.treesitter({
          a = { "@rspec.matcher" },
          i = { "@rspec.matcher" },
        }),
      },
    }
    if LazyVim.is_loaded("nvim-treesitter") then
      -- treesitter
      require("nvim-treesitter.configs").setup({
        textobjects = {
          move = {
            goto_next_start = {
              ["]r"] = "@rspec.context",
              ["]i"] = "@rspec.it",
              -- ["]]"] = "@structure.outer",
            },
            goto_next_end = {
              ["[I"] = "@rspec.it",
              ["]R"] = "@rspec.context",
              -- ["]["] = "@structure.outer",
            },
            goto_previous_start = {
              ["[r"] = "@rspec.context",
              ["[i"] = "@rspec.it",
              -- ["[["] = "@structure.outer",
            },
            goto_previous_end = {
              ["[R"] = "@rspec.context",
              ["]I"] = "@rspec.it",
              -- ["[]"] = "@structure.outer",
            },
          },
        },
      })
    else
      vim.api.nvim_echo({ { "nvim-treesitter not loaded", "Error" } }, true, {})
    end
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
  pattern = { "*.md", "help" },
  group = ag("readme", { clear = true }),
  callback = function()
    -- if at project root then disable diagnostics
    -- if vim.fn.getcwd() == vim.fn.expand("%:p:h") then
    -- local filename = vim.fn.expand("%:t")
    -- if filename == "README.md" or filename == "CHANGELOG.md" then
    --   vim.diagnostic.disable(0)
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

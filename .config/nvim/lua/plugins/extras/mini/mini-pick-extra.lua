local picker
local function get_picker()
  if not picker then picker = require("util.minipick_registry.picker") end
  return picker
end

-- local mark_hints = vim.split("'\"[]^.<>CDKLS0123456789", "")

return {
  { import = "plugins.extras.ui.snacks-extended" },
  { import = "plugins.extras.editor.fzf-extended" },
  {
    "folke/snacks.nvim",
    optional = true,
    keys = {
      { "<leader>:", false },
      { "<leader>fR", false },
      { "<leader>fr", false },
      { "<leader>s/", false },
      -- { "<leader>s<C-b>", false },
      { "<leader>sB", false },
      { "<leader>sC", false },
      { "<leader>sD", false },
      { "<leader>sH", false },
      { "<leader>sc", false },
      { "<leader>sd", false },
      { "<leader>sm", false },
      { '<leader>s"', false },
      -- { "<leader>st", false },
    },
  },
  {
    "ibhagwan/fzf-lua",
    optional = true,
    keys = {
      { "<leader>:", false },
      { "<leader><space>", false },
      { "<leader>fF", false },
      { "<leader>fM", false },
      { "<leader>fP", false },
      { "<leader>fR", false },
      { "<leader>fc", false },
      { "<leader>ff", false },
      { "<leader>fg", false },
      { "<leader>fr", false },
      { "<leader>ga", false },
      { "<leader>gc", false },
      { "<leader>gr", false },
      { "<leader>s/", false },
      { "<leader>s<C-m>", false },
      { "<leader>s<C-w>", false },
      { "<leader>sA", false },
      { "<leader>sC", false },
      { "<leader>sF", false },
      { "<leader>sG", false },
      { "<leader>sH", false },
      { "<leader>sN", false },
      { "<leader>sP", false },
      { "<leader>sR", false },
      { "<leader>sW", false },
      { "<leader>sc", false },
      { "<leader>sg", false },
      { "<leader>sh", false },
      { "<leader>sp", false },
      { "<leader>su", false },
      { "<leader>su", false, mode = { "v" } },
      { "<leader>sw", false },
      { "<leader>sw", false, mode = { "v" } },
    },
  },
  {
    "nvim-mini/mini.pick",
    optional = true,
    keys = {
      -- stylua: ignore start
      { "<leader>s<C-r>", false },
      { "<leader>s<M-g>", false },
      { "<leader>s<C-r>", false },
      { "<leader><space>", function() get_picker().pick_files() end, desc = "Find Files (Root Dir)" },
      { "<leader>ff", function() get_picker().pick_files() end, desc = "Find Files (Root Dir)" },
      { "<leader>fF", function() get_picker().pick_files(get_picker().cwd_dir()) end, desc = "Find Files (cwd)" },
      {
        "<leader>fN",
        function()
          -- Notification is handled by #node_modules_dir
          local path = Util.picker.node_modules_dir()
          if not path then return end

          get_picker().pick_files(path)
        end,
        desc = "Files (node_modules)",
      },
      {
        "<leader>fc",
        function()
          get_picker().pick_files(vim.fn.stdpath("config"), {}, { source = { name = "Config" } })
        end,
        desc = "Find Config Files",
      },
      {
        "<leader>fl",
        function()
          get_picker().pick_files(get_lazyvim_base_dir(), {}, { source = { name = "LazyVim" } })
        end,
        desc = "Find LazyVim Files",
      },
      {
        "<leader>fp",
        function()
          get_picker().pick_files(get_picker().lazyvim_plugins_dir(), {}, { source = { name = "Plugins" } })
        end,
        desc = "Plugins",
      },

      {
        "<leader>su",
        function()
          local pick = get_picker()
          pick.pick_grep(vim.fn.expand("<cword>"))
        end,
        desc = "Word",
        mode = "n",
      },
      {
        "<leader>su",
        function()
          local pick = get_picker()
          pick.pick_grep()
        end,
        desc = "Visual selection or word (Root Dir)",
        mode = "v",
      },
      {
        "<leader>su",
        function()
          local pick = get_picker()
          pick.pick_grep()
        end,
        desc = "Visual selection or word (cwd)",
        mode = "v",
      },
      {
        "<leader>sw",
        function()
          local pick = get_picker()
          pick.pick_grep(vim.fn.expand("<cword>"))
        end,
        desc = "Word (Root Dir)",
        mode = "n",
      },
      {
        "<leader>sW",
        function()
          local pick = get_picker()
          pick.pick_grep(vim.fn.expand("<cword>"), nil, { source = { cwd = pick.cwd_dir() } })
        end,
        desc = "Word (cwd)",
        mode = "n",
      },
      {
        "<leader>sw",
        function()
          local pick = get_picker()
          pick.pick_grep()
        end,
        desc = "Selection (Root Dir)",
        mode = "v",
      },
      {
        "<leader>sW",
        function()
          local pick = get_picker()
          pick.pick_grep(nil, nil, { source = { cwd = pick.cwd_dir() } })
        end,
        desc = "Selection (cwd)",
        mode = "v",
      },
      {
        "<leader>s<C-w>",
        function()
          local pick = get_picker()
          pick.pick_grep(vim.fn.expand("<cWORD>"))
        end,
        desc = "WORD (Root Dir)",
        mode = "n",
      },
      {
        "<leader>/",
        function()
          get_picker().pick_grep_live()
        end,
        desc = "Grep (Root Dir)",
      },
      {
        "<leader>sg",
        function()
          get_picker().pick_grep_live()
        end,
        desc = "Grep (Root Dir)",
      },
      {
        "<leader>sG",
        function()
          get_picker().pick_grep_live({}, { source = { cwd = get_picker().cwd_dir() } })
        end,
        desc = "Grep (cwd)",
      },
      -- { "<leader>sP", function() MiniPick.registry.rg_pcre2({}, { source = { cwd = get_picker().root_dir() } }) end, desc = "Grep (--pcre2)" },
      {
        "<leader>s<M-l>",
        function()
          get_picker().pick_grep_live({}, { source = { cwd = get_lazyvim_base_dir(), name = "LazyVim" } })
        end,
        desc = "Grep LazyVim Files",
      },
      {
        "<leader>s<M-c>",
        function()
          get_picker().pick_grep_live({}, { source = { cwd = vim.fn.stdpath("config"), name = "Config" } })
        end,
        desc = "Grep Config Files",
      },
      {
        "<leader>sp",
        function()
          get_picker().pick_grep_live({ ts_highlight = false }, { source = { cwd = get_picker().lazyvim_plugins_dir(), name = "Plugins" } })
        end,
        desc = "Grep Plugins",
      },
      {
        "<leader>sN",
        function()
          local path = Util.picker.node_modules_dir()
          if not path then return end
          get_picker().pick_grep_live({ ts_highlight = false }, { source = { cwd = path, name = "Node Modules" } })
        end,
        desc = "Grep (node_modules)",
      },
      {
        "<leader>sF",
        function()
          get_picker().pick_grep(vim.fn.expand("<cword>"), { flags = { "fixed_strings" } })
        end,
        desc = "Grep (--fixed-strings)",
        mode = { "n" },
      },
      {
        "<leader>sF",
        function()
          get_picker().pick_grep(nil, { flags = { "fixed_strings" } })
        end,
        desc = "Grep (--fixed-strings)",
        mode = { "v" },
      },
      {
        "<leader>s<M-r>",
        function()
          local gem = "ruby-lsp" -- rails
          local function handle_output(stdout, code, stderr)
            if code ~= 0 then
              vim.api.nvim_echo({ { ("Error getting gem path: %s"):format(stderr), "Error" } }, true, {})
              return
            end
            local path = stdout:match("^(.-)\n")
            if not path or path == "" then
              vim.api.nvim_echo({ { "Could not find ruby-lsp gem path", "Error" } }, true, {})
              return
            end
            path = vim.fn.fnamemodify(path, ":h")
            local gems_dir = vim.fn.fnamemodify(path, ":~:h:h")
            get_picker().pick_grep_live({}, { source = { cwd = path, name = gems_dir } })
          end

          vim.system({ "bundle", "show", gem }, { text = true }, function(res)
            vim.schedule(function()
              handle_output(res.stdout, res.code, res.stderr)
            end)
          end)
        end
      },
      {
        "<leader>s<C-m>",
        function()
          -- Grep ruby gem or node module dir, if current buf is a file inside of one
          local result = Util.picker.node_module_subdir()
          if result then
            local path = result.path or result
            local display = result.display
            get_picker().pick_grep_live({}, { source = { cwd = path, name = ("node_modules/%s"):format(display) } })
          end
        end,
        desc = "Module subdir",
      },
      { "<leader>sB", function() require("mini.extra").pickers.buf_lines({ scope = "all" }) end, desc = "Grep Buffers" },
      -- { "<leader>sb", function() require("mini.extra").pickers.buf_lines({ scope = "current" }) end, desc = "Lines" },
      -- { "<leader>sb", function() MiniPick.registry.bufferlines_ts({ scope = "current" }) end, desc = "Lines" },
      -- { "<leader>sb", function()
      --   MiniPick.registry.bufferlines_ts({ scope = "current" })
      --   local lines, _ = Util.selection.get_visual_selection()
      --   vim.schedule_wrap(function()
      --     MiniPick.set_picker_query(vim.split(lines, "n"))
      --   end)
      -- end, desc = "Lines", mode = {"v"} },

      { '<leader>s"', function() require("mini.extra").pickers.registers() end, desc = "Registers" },
      { "<leader>s/", function() require("mini.extra").pickers.history({ scope = "/" }, { hinted = { enable = true } }) end, desc = "Search History" },
      { "<leader>:", function() require("mini.extra").pickers.history({ scope = ":" }, { hinted = { enable = true } }) end, desc = "Command History" },
      { "<leader>sc", function() require("mini.extra").pickers.history({ scope = ":" }, { hinted = { enable = true } }) end, desc = "Command History" },
      { "<leader>sC", function() require("mini.extra").pickers.commands() end, desc = "Commands" },
      -- { "<leader>sD", function() require("mini.extra").pickers.diagnostic() end, desc = "Diagnostics" },
      -- { "<leader>sd", function() require("mini.extra").pickers.diagnostic({ scope = "current" }) end, desc = "Buffer Diagnostics" },
      { "<leader>sH", function() require("mini.extra").pickers.hl_groups() end, desc = "Search Highlight Groups" },
      { "<leader>sh", function() require("mini.pick").builtin.help() end, desc = "Search Highlight Groups" },
      -- { "<leader>sk", function() require("mini.pick").registry.keymaps_callback() end, desc = "Keymaps" },
      { "<leader>sm", function() require("mini.extra").pickers.marks() end, desc = "Marks" },
      { "<leader>sA", function() require("mini.extra").pickers.treesitter() end, desc = "Treesitter Symbols" },
      { "<leader>sR", function() require("mini.pick").builtin.resume() end, desc = "Grep (Live)"},
      -- { "<leader>st", function() require("mini.pick").registry.grep_todo_keywords() end, desc = "Todo"},
      {
        "<leader>s<C-t>",
        function()
          get_picker().pick_files(nil, { fd_flags = { "today", "no_ignore" }, source = { name = "Today" } })
        end,
        desc = "Today",
      },

      -- Git
      -- { "<leader>ga", function() require("mini.extra").pickers.git_branches() end, desc = "Git Branches" },
      -- { "<leader>gA", function() require("mini.extra").pickers.git_branches({ scope = "remote"}) end, desc = "Branches" },
      { "<leader>gc", function() require("mini.extra").pickers.git_commits() end, desc = "Commits" },
      { "<leader>fr", function() require("mini.extra").pickers.visit_paths() end, desc = "Visit paths" },
      { "<leader>fR", function() require("mini.extra").pickers.oldfiles() end, desc = "Recent" },
      -- { "<leader>fR", function() require("mini.extra").pickers.oldfiles({ current_dir = true }) end, desc = "Recent (cwd)" },
      { "z=", function() require("mini.extra").pickers.spellsuggest() end, desc = "Spelling Suggestions" },
      -- { "<leader>sJ", function() require("mini.extra").pickers.visit_labels() end, desc = "Visit labels" },
      { "<leader>fg", function() require("mini.extra").pickers.git_files() end, desc = "Files" },
      -- { "<leader>gs", function() require("mini.extra").pickers.git_hunks({scope = "unstaged"}) end, desc = "Git Diff" },
      -- { "<leader>gS", function() require("mini.extra").pickers.git_hunks({scope = "staged"}) end, desc = "Git Diff (Staged)" },
      -- stylua: ignore end
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
            -- stylua: ignore
            keys = {
              { "gd", function() get_picker().pick_lsp2({ scope = "definition"}) end, desc = "Goto Definition", has = "definition" },
              { "gD", function() get_picker().pick_lsp2({ scope = "declaration"}) end, desc = "Goto Definition", has = "definition" },
              { "gr", function() get_picker().pick_lsp2({ scope = "references"}) end, nowait = true, desc = "References" },
              { "gI", function() get_picker().pick_lsp2({ scope = "implementation"}) end, desc = "Goto Implementation" },
              { "gy", function() get_picker().pick_lsp2({ scope = "type_definition" }) end, desc = "Goto T[y]pe Definition" },
              { "<leader>ss", function() get_picker().pick_lsp2({ scope = "document_symbol_live" }) end, desc = "LSP Symbols", has = "documentSymbol" },
              { "<leader>sS", function() get_picker().pick_lsp2({ scope = "workspace_symbol_live" }) end, desc = "Workspace Symbols", has = "workspace/symbols" },
              -- { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming", has = "callHierarchy/incomingCalls" },
              -- { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing", has = "callHierarchy/outgoingCalls" },
            },
        },
      },
    },
  },
}

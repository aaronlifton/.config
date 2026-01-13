return {
  {
    "folke/snacks.nvim",
    opts = {
      -- Already enabled by LazyVim
      -- scope = { enabled = true },
      -- indent = { enabled = true },
      -- words = { enabled = true },
      --
      zen = {
        enabled = true,
        toggles = {
          inlay_hints = true,
          diagnostics = true,
        },
      },
      scroll = {
        enabled = vim.g.smooth_scroll_provider == "snacks",
        animate = {
          duration = { step = 10, total = 150 },
        },
      },
      notifier = {
        style = "fancy",
      },
      ---@class snacks.gitbrowse.Config
      gitbrowse = {
        remote_patterns = {
          -- { "^https://[^@]+@(.+)$", "https://%1" },
          -- { "^https://[^@]+@git%.synack%.com/(.+)%.git$", "https://git.synack.com/%1" },
          { "^https://git%.synack%.com/(.+)%.git$", "https://git.synack.com/%1" },
        },
        url_patterns = {
          ["git%.synack%.com"] = {
            branch = "/tree/{branch}",
            file = "/blob/{branch}/{file}#L{line_start}-L{line_end}",
            commit = "/commit/{commit}",
          },
        },
      },
      picker = {
        previewers = {
          git = {
            builtin = false,
          },
        },
        matcher = {
          frecency = true,
        },
        win = {
          input = {
            keys = {
              ["<a-c>"] = {
                "toggle_cwd",
                mode = { "n", "i" },
              },
              ["<M-s>"] = { "leap", mode = { "n", "i" } },
              ["s"] = { "leap" },
              -- ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              -- ["<a-j>"] = { "list_scroll_down", mode = { "i", "n" } },
              -- ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              -- ["<a-k>"] = { "list_scroll_up", mode = { "i", "n" } },
            },
          },
        },
        actions = {
          leap = function(picker)
            local all_wins = vim.api.nvim_list_wins()
            local wins = vim.tbl_filter(function(win)
              return vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "snacks_picker_list"
            end, all_wins)

            require("leap").leap({
              -- pattern = "^",
              target_windows = wins,
              action = function(target)
                local idx = picker.list:row2idx(target.pos[1])
                picker.list:_move(idx, true, true)
              end,
            })
          end,
        },
        layouts = {
          default = {
            layout = {
              box = "horizontal",
              width = 0.8,
              min_width = 120,
              height = 0.8,
              {
                box = "vertical",
                border = "rounded",
                title = "{title} {live} {flags}",
                { win = "input", height = 1, border = "bottom" },
                { win = "list", border = "none" },
              },
              { win = "preview", title = "{preview}", border = "rounded", width = 0.6 },
            },
          },
          default_adjusted = {
            layout = {
              box = "horizontal",
              width = 0.8,
              min_width = 75,
              height = 0.8,
              {
                box = "vertical",
                border = "none",
                title = "{title} {live} {flags}",
                { win = "input", height = 1, border = "rounded" },
                { win = "list", border = "rounded" },
              },
              { win = "preview", title = "{preview}", border = "rounded", width = 0.65 },
            },
          },
        },
      },
      image = {
        enabled = true,
        doc = {
          inline = false,
        },
      },
      dashboard = {
        preset = {
          header = [[
                                                                   
      ████ ██████           █████      ██                    
     ███████████             █████                            
     █████████ ███████████████████ ███   ███████████  
    █████████  ███    █████████████ █████ ██████████████  
   █████████ ██████████ █████████ █████ █████ ████ █████  
 ███████████ ███    ███ █████████ █████ █████ ████ █████ 
██████  █████████████████████ ████ █████ █████ ████ ██████
      ]],
          -- stylua: ignore
          ---@type snacks.dashboard.Item[]
          keys = {
            { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
            { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
            { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })" },
            -- { icon = " ", key = "a", desc = "Chat with AI", action = ":ene | Mchat gemini:flash-2.5" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
        pick = function(cmd, opts)
          vim.api.nvim_echo({ { vim.inspect({ cmd = cmd, opts = opts }), "Normal" } }, true, {})
          return true
        end,
      },
    },
    keys = {
      -- Explorer
      -- {
      --   "<leader><C-Space>",
      --   function()
      --     Snacks.picker.explorer({
      --       layout = { preset = "vertical", preview = true },
      --       main = { current = true },
      --       auto_close = true,
      --     })
      --   end,
      --   "n",
      --   desc = "Floating Explorer",
      -- },
      -- {
      --   "<leader>f<C-e>",
      --   function()
      --     Snacks.picker.explorer({ cwd = LazyVim.root() })
      --   end,
      --   desc = "Explorer Snacks (root dir)",
      -- },
      -- {
      --   "<leader>f<M-e>",
      --   function()
      --     Snacks.picker.explorer()
      --   end,
      --   desc = "Explorer Snacks (cwd)",
      -- },

      -- stylua: ignore start
      { "<leader>\\", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      -- In addition to LazyVim's <leader>wm and <leader>uZ mappings:
      { "<leader>z", function() Snacks.zen.zoom() end, desc = "Zoom" },
      { "<leader>fP", function() Snacks.picker.projects() end, desc = "Projects" },
      -- { "<leader>Z", function() Snacks.zen.zen() end, desc = "Zen" },
      -- { "<leader>LS",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      -- { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      -- { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      -- { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      -- { "<leader>u<C-c>", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      -- Search
      { "<leader>s<C-b>", function() Snacks.picker.lines() end, desc = "Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Buffers" },
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>s<C-k>", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      -- { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
      -- { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      -- { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>s<C-g>", function() Snacks.picker.grep({
        exclude = { "**/dist/**.js*", "*{-,.}min.js" },
      })
      end, desc = "Grep" },
      { "<leader>s<C-u>", function() Snacks.picker.undo() end, desc = "Undotree" },
      { "<leader>sX", function() Snacks.picker() end, desc = "Choose snacks picker" },

      -- Picker
      { "<leader>fi", function() Snacks.picker.lazy() end, desc = "Plugins (Installed)" },

      -- Override Snacks.picker.notifications keymap
      -- { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },

      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      -- Alternate keymaps for testing
      { "<leader>f<C-f>", function() Snacks.picker.files() end, desc = "Find Files (Root Dir)" },
      -- { "g<C-d>", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },

      -- git
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (hunks)" },
      { "<leader>g<C-d>", function() Snacks.picker.git_diff({ base = "origin", group = true }) end, desc = "Git Diff (origin)" },
      -- { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      {"<leader>g<C-l>", function() Snacks.picker.git_log_line() end,  desc = "Git Log Line" },
      -- Already <leader>gf
      -- {"<leader>g<C-f>", function() Snacks.picker.git_log_file() end,  desc = "Git Log File" },
      { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
      { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
      { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
      { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        ["*"] = {
          -- stylua: ignore
          keys = {
            -- { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition", has = "definition" },
            -- { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
            -- { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
            -- { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
            -- { "<leader>ss", function() Snacks.picker.lsp_symbols({ filter = LazyVim.config.kind_filter }) end, desc = "LSP Symbols", has = "documentSymbol" },
            -- { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols({ filter = LazyVim.config.kind_filter }) end, desc = "LSP Workspace Symbols", has = "workspace/symbols" },
            { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming", has = "callHierarchy/incomingCalls" },
            { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing", has = "callHierarchy/outgoingCalls" },
          },
        },
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    optional = true,
    -- stylua: ignore
    keys = {
      { "<leader>st", function() Snacks.picker.todo_comments({ cwd = LazyVim.root() }) end, desc = "Todo" },
      { "<leader>sT", function () Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
    },
  },
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      table.insert(opts.dashboard.preset.keys, 3, {
        icon = " ",
        key = "p",
        desc = "Projects",
        action = ":lua Snacks.picker.projects()",
      })
    end,
  },
  {
    "folke/snacks.nvim",
    opts = function(_, opts)
      if LazyVim.has("trouble.nvim") then
        return vim.tbl_deep_extend("force", opts or {}, {
          picker = {
            actions = require("trouble.sources.snacks").actions,
            win = {
              input = {
                keys = {
                  ["<c-t>"] = {
                    "trouble_open",
                    mode = { "n", "i" },
                  },
                },
              },
            },
          },
        })
      end
    end,
  },
}

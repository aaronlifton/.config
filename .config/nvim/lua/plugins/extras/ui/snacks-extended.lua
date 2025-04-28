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
              -- ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              -- ["<a-j>"] = { "list_scroll_down", mode = { "i", "n" } },
              -- ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              -- ["<a-k>"] = { "list_scroll_up", mode = { "i", "n" } },
            },
          },
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
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
            { icon = " ", key = "a", desc = "Chat with AI", action = ":ene | Mchat claude:cache" },
            { icon = " ", key = "s", desc = "Restore Session", section = "session" },
            { icon = " ", key = "x", desc = "Lazy Extras", action = ":LazyExtras" },
            { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
            { icon = " ", key = "q", desc = "Quit", action = ":qa" },
          },
        },
      },
    },
    keys = {
      -- stylua: ignore start
      { "<leader>\\", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      -- In addition to LazyVim's <leader>wm and <leader>uZ mappings:
      { "<leader>z", function() Snacks.zen.zoom() end, desc = "Zoom" },
      -- { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      {"<leader>g<C-l>", function() Snacks.picker.git_log_line() end,  desc = "Git Log Line" },
      {"<leader>g<C-f>", function() Snacks.picker.git_log_file() end,  desc = "Git Log File" },
      -- { "<leader>Z", function() Snacks.zen.zen() end, desc = "Zen" },
      -- { "<leader>LS",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      -- { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      -- { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      -- { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      -- Picker
      { "<leader>s<C-b>", function() Snacks.picker.lines() end, desc = "Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Buffers" },
      { "<leader>s<C-g>", function() Snacks.picker.grep({
          exclude = { "**/dist/**.js*", "*{-,.}min.js" },
        })
      end, desc = "Grep" },
      { "<leader>fli", function() Snacks.picker.lazy() end, desc = "Plugins (Installed)" },
      -- Override Snacks.picker.notifications keymap
      { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>s<C-u>", function() Snacks.picker.undo() end, desc = "Undotree" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      -- Alternate keymaps for testing
      { "<leader>f<C-f>", function() Snacks.picker.files() end, desc = "Find Files (Root Dir)" },
      -- { "g<C-d>", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "<leader>sX", function() Snacks.picker() end, desc = "Choose snacks picker" },
      -- Explorer
      {
        "<leader>f<C-e>",
        function()
          Snacks.picker.explorer({ cwd = LazyVim.root() })
        end,
        desc = "Explorer Snacks (root dir)",
      },
      {
        "<leader>f<M-e>",
        function()
          Snacks.picker.explorer()
        end,
        desc = "Explorer Snacks (cwd)",
      },
    },
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
  -- {
  --   "neovim/nvim-lspconfig",
  --   opts = function()
  --     if vim.g.lazyvim_picker ~= "snacks" then return end
  --     local Keys = require("lazyvim.plugins.lsp.keymaps").get()
  --       -- stylua: ignore
  --       vim.list_extend(Keys, {
  --         { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition", has = "definition" },
  --         { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
  --         { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
  --         { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
  --         { "<leader>ss", function() Snacks.picker.lsp_symbols({ filter = LazyVim.config.kind_filter }) end, desc = "LSP Symbols", has = "documentSymbol" },
  --         { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols({ filter = LazyVim.config.kind_filter }) end, desc = "LSP Workspace Symbols", has = "workspace/symbols" },
  --       })
  --   end,
  -- },
}

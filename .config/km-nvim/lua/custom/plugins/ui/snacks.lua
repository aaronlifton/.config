-- Terminal navigation function using smart-splits
local function term_nav(direction)
  return function()
    if vim.bo.filetype == "snacks_terminal" then
      require("smart-splits")["move_cursor_" .. direction]()
    else
      return "<C-" .. direction .. ">"
    end
  end
end

return {
  {
    "folke/snacks.nvim",
    opts = {
      -- Already enabled by Util.lazy
      -- scope = { enabled = true },
      -- indent = { enabled = true },
      -- words = { enabled = true },
      bigfile = { enabled = true },
      quickfile = { enabled = true },
      terminal = {
        win = {
          keys = {
            nav_h = { "<C-h>", term_nav("left"), desc = "Go to Left Window", expr = true, mode = "t" },
            nav_j = { "<C-j>", term_nav("down"), desc = "Go to Lower Window", expr = true, mode = "t" },
            nav_k = { "<C-k>", term_nav("up"), desc = "Go to Upper Window", expr = true, mode = "t" },
            nav_l = { "<C-l>", term_nav("right"), desc = "Go to Right Window", expr = true, mode = "t" },
          },
        },
      },
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
            -- { icon = " ", key = "a", desc = "Chat with AI", action = ":ene | Mchat gemini:flash-2.5" },
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
      -- { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      { "<leader>dps", function() Snacks.profiler.scratch() end, desc = "Profiler Scratch Buffer" },
      { "<leader>\\", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      -- In addition to Util.lazy's <leader>wm and <leader>uZ mappings:
      { "<leader>z", function() Snacks.zen.zoom() end, desc = "Zoom" },
      -- { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      {"<leader>gl", function() Snacks.picker.git_log_line() end,  desc = "Git Log Line" },
      {"<leader>gF", function() Snacks.picker.git_log_file() end,  desc = "Git Log File" },
      -- { "<leader>Z", function() Snacks.zen.zen() end, desc = "Zen" },
      -- { "<leader>LS",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      -- { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      -- { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      -- { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      -- Picker
      { "<leader>sL", function() Snacks.picker.lines() end, desc = "Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Buffers" },
      { "<leader>sG", function() Snacks.picker.grep({
          exclude = { "**/dist/**.js*", "*{-,.}min.js" },
        })
      end, desc = "Grep" },
      { "<leader>fli", function() Snacks.picker.lazy() end, desc = "Plugins (Installed)" },
      -- Override Snacks.picker.notifications keymap
      { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>sU", function() Snacks.picker.undo() end, desc = "Undotree" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      -- { "g<C-d>", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "<leader>sX", function() Snacks.picker() end, desc = "Choose snacks picker" },
      -- stylua: ignore end
    },
  },
}

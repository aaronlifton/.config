return {
  "folke/snacks.nvim",
  opts = {
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
    scope = { enabled = true },
    indent = { enabled = true },
    words = { enabled = true },
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
    { "<leader>bz", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
    -- In addition to LazyVim's <leader>wm and <leaer>uZ mappings:
    { "<leader>z", function() Snacks.zen.zoom() end, desc = "Zoom" },
    -- { "<leader>Z", function() Snacks.zen.zen() end, desc = "Zen" },
    -- { "<leader>LS",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    -- { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
    -- { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
    -- { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
  },
}

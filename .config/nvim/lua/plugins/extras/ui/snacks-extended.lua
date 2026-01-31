---@class snacks.picker.Config
---@field regex boolean
---@field glob string[]

local M = {}

M.ctx = { globs = {} }
function M.add_glob()
  local ok, glob = pcall(vim.fn.input, "iglob pattern: ")
  if ok then
    table.insert(M.ctx.globs, glob)
    return glob
  end
end

function M.remove_glob()
  if #M.ctx.globs > 0 then
    local removed = table.remove(M.ctx.globs)
    return removed
  end
end

return {
  {
    "folke/snacks.nvim",
    init = function()
      local Grep = require("snacks.picker.source.grep")
      local orig_grep = Grep.grep

      -- Ensure grep's opts.glob is set before building ripgrep args.
      ---@diagnostic disable-next-line: duplicate-set-field
      function Grep.grep(opts, ctx)
        if ctx and ctx.picker and ctx.picker.opts then
          vim.iter({ "glob", "regex" }):each(function(opt)
            if ctx.picker.opts[opt] ~= nil then
              opts = vim.tbl_deep_extend("force", {}, opts, { [opt] = ctx.picker.opts[opt] })
            end
          end)
        end
        return orig_grep(opts, ctx)
      end
    end,
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
              -- to close the picker on ESC instead of going to normal mode,
              -- add the following keymap to your config
              -- ["<Esc>"] = { "close", mode = { "n", "i" } },
              ["<C-d>"] = { "list_scroll_down2", mode = { "i", "n" } },
              ["<C-u>"] = { "list_scroll_up2", mode = { "i", "n" } },
              ["<a-c>"] = {
                "toggle_cwd",
                mode = { "n", "i" },
              },
              -- Check defaults ~/.local/share/nvim/lazy/snacks.nvim/lua/snacks/picker/config/defaults.lua:226
              ["<M-s>"] = { "leap", mode = { "n", "i" } },
              ["<C-x>"] = { "leap", mode = { "n", "i" } },
              ["<C-o>"] = { "add_glob", mode = { "n", "i" } },
              ["<C-x>"] = { "remove_glob", mode = { "n", "i" } },
              -- Make same as fzf keymap
              ["<C-e>"] = { "toggle_live", mode = { "i", "n" } },
              -- Flag bindings
              -- ["<M-j>"] = { "toggle_js_ts", mode = { "n", "i" } },
              ["<M-j>"] = { "toggle_js_no_tests", mode = { "n", "i" } },
              ["<M-o>"] = { "toggle_js_tests", mode = { "n", "i" } },
              ["<M-S-t>"] = { "toggle_tests", mode = { "n", "i" } },
              ["<M-x>"] = { "toggle_no_tests", mode = { "n", "i" } },
              ["<M-c>"] = { "toggle_type_conf", mode = { "n", "i" } },
              ["<M-W>"] = { "toggle_type_web", mode = { "n", "i" } },
              -- Overrides toggle_follow
              ["<M-f>"] = { "toggle_regex", mode = { "i", "n" } },
              ["<M-u>"] = { "toggle_dotall", mode = { "n", "i" } },
              ["<M-l>"] = { "toggle_type_lua", mode = { "n", "i" } },
              ["<M-r>"] = { "toggle_type_ruby", mode = { "n", "i" } },
              ["<M-P>"] = { "toggle_type_python", mode = { "n", "i" } },
              ["<M-J>"] = { "toggle_type_js", mode = { "n", "i" } },
              -- Overrides toggle_maximize
              ["<M-m>"] = { "toggle_type_md", mode = { "n", "i" } },
              ["<F7>"] = { "toggle_maximize", mode = { "i", "n" } },
              -- ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
              -- ["<a-j>"] = { "list_scroll_down", mode = { "i", "n" } },
              -- ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
              -- ["<a-k>"] = { "list_scroll_up", mode = { "i", "n" } },
            },
          },
        },
        actions = {
          ---@param picker snacks.Picker
          leap = function(picker)
            local all_wins = vim.api.nvim_list_wins()
            local wins = vim.tbl_filter(function(win)
              return vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "snacks_picker_list"
            end, all_wins)

            require("leap").leap({
              target_windows = wins,
              action = function(target)
                local idx = picker.list:row2idx(target.pos[1])
                picker.list:_move(idx, true, true)
              end,
              pattern = "\\%>0v\\%<2v.",
              inclusive = false,
              opts = {
                safe_labels = "",
                labels = "asdfhjklqwertyuiopzxcvbnm1234567890" .. "ASDFHJKLQWERTYUIOPZXCVBNM", -- "-=[];';,./"
              },
            })
          end,
          ---@param p snacks.Picker
          list_scroll_down2 = function(p)
            local target = math.min(p.list.cursor + 24, p.list:count())
            p.list:move(target, true, true)
          end,
          ---@param p snacks.Picker
          list_scroll_up2 = function(p)
            local target = math.max(p.list.cursor - 24, 1)
            p.list:move(target, true, true)
          end,
          ---@param p snacks.Picker
          list_center = function(p)
            local height = p.list.state.height or p.list:height()
            local middle = math.floor((height + 1) / 2)
            local cursor = p.list.cursor
            p.list:view(cursor, cursor - middle + 1)
          end,
          ---@param p snacks.Picker
          toggle_js_no_tests = function(p)
            Util.snacks.actions.toggle_iglob("js_no_tests", p)
          end,
          toggle_js_tests = function(p)
            Util.snacks.actions.toggle_iglob("js_tests", p)
          end,
          toggle_tests = function(p)
            Util.snacks.actions.toggle_iglob("tests", p)
          end,
          toggle_no_tests = function(p)
            Util.snacks.actions.toggle_iglob("no_tests", p)
          end,
          toggle_js_ts = function(p)
            Util.snacks.actions.toggle_iglob("js_ts", p)
          end,
          toggle_no_bundle = function(p)
            Util.snacks.actions.toggle_iglob("no_bundle", p)
          end,
          toggle_type_conf = function(p)
            Util.snacks.actions.toggle_flag("type_conf", p)
          end,
          toggle_type_web = function(p)
            Util.snacks.actions.toggle_flag("type_web", p)
          end,
          toggle_context = function(p)
            Util.snacks.actions.toggle_flag("context", p)
          end,
          ---@param p snacks.Picker
          -- toggle_fixed_strings = function(p)
          --   ---@diagnostic disable-next-line: inject-field
          --   if p.opts.regex then
          --     p.opts.regex = false
          --   else
          --     p.opts.regex = true
          --   end
          --   p:refresh()
          -- end,
          toggle_dotall = function(p)
            Util.snacks.actions.toggle_flag("dotall", p)
          end,
          toggle_type_lua = function(p)
            Util.snacks.actions.toggle_ft("lua", p)
          end,
          toggle_type_ruby = function(p)
            Util.snacks.actions.toggle_ft("ruby", p)
          end,
          toggle_type_python = function(p)
            Util.snacks.actions.toggle_ft("python", p)
          end,
          toggle_type_js = function(p)
            Util.snacks.actions.toggle_ft({ "js", "ts" }, p)
          end,
          ---@param p snacks.Picker
          toggle_type_md = function(p)
            Util.snacks.actions.toggle_ft("markdown", p)
          end,
          add_glob = function(p)
            local glob = M.add_glob()
            if glob then Util.snacks.actions.toggle_glob(glob, p) end
          end,
          remove_glob = function(p)
            local glob = M.remove_glob()
            vim.api.nvim_echo({ { vim.inspect({ glob = glob }), "Normal" } }, true, {})
            if glob then Util.snacks.actions.toggle_glob(glob, p) end
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
            -- { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
            -- { icon = " ", key = "r", desc = "Recent Files", action = ":lua require('mini.extra').pickers.visit_paths()" },
            { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.picker.recent()" },
            { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', { cwd = vim.fn.stdpath('config') })" },
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
      { "<leader>sk", false },
      -- stylua: ignore start
      { "<leader>\\", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      -- In addition to LazyVim's <leader>wm and <leader>uZ mappings:
      { "<leader>z", function() Snacks.zen.zoom() end, desc = "Zoom" },
      { "<leader>fP", function() Snacks.picker.projects() end, desc = "Projects" },
      -- Override Snacks.picker.notifications keymap
      -- { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      -- { "<leader>Z", function() Snacks.zen.zen() end, desc = "Zen" },
      -- { "<leader>LS",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      -- { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
      -- { "<leader>n", function() Snacks.notifier.show_history() end, desc = "Notification History" },
      -- { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },
      -- { "<leader>u<C-c>", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      -- Search
      -- { "<leader>s<C-b>", function() Snacks.picker.lines() end, desc = "Lines" },
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Buffers" },
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      -- Can't edit file
      { "<leader>s<C-k>", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      -- { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
      -- { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      -- { "<leader>:", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>s<M-g>", function() Snacks.picker.grep({
        exclude = { "**/dist/**.js*", "*{-,.}min.js" },
      })
      end, desc = "Grep" },
      { "<leader>s<C-u>", function() Snacks.picker.undo() end, desc = "Undotree" },
      { "<leader>sX", function() Snacks.picker() end, desc = "Choose snacks picker" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },

      -- Picker
      { "<leader>fi", function() Snacks.picker.lazy() end, desc = "Plugins (Installed)" },
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
      -- { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      -- { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
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
            actions = {
              trouble_open = function(...)
                return require("trouble.sources.snacks").actions.trouble_open.action(...)
              end,
            },
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

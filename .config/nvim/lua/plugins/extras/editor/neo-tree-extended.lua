local M = {}
function M.notify(msg, level)
  vim.notify(msg, level, { title = "NeoTree" })
end
function M.remove_cwd(path)
  local cwd = vim.fn.getcwd()
  cwd = M.escape_pattern(cwd) .. "/"

  return path:gsub("^" .. cwd, "")
end
function M.escape_pattern(text)
  return text:gsub("([^%w])", "%%%1")
end

---@class NeoTreeState
---@field name string
---@field id string
---@field current_position string
---@field tabid number
---@field winid number
---@field bufnr number
---@field clipboard table<string, table>

local astrovim_style = false

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    optional = true,
    opts = {
      -- auto_clean_after_session_restore = true,
      close_if_last_window = true,
      popup_border_style = "rounded",
      commands = {
        -- parent_or_close = function(state)
        --   local node = state.tree:get_node()
        --   if (node.type == "directory" or node:has_children()) and node:is_expanded() then
        --     state.commands.toggle_node(state)
        --   else
        --     require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
        --   end
        -- end,
        -- https://github.com/AstroNvim/AstroNvim/blob/34208f8fed7521380930cea3ec4f65f993fe22d2/lua/plugins/neo-tree.lua#L10
        copy_selector = function(state)
          local node = state.tree:get_node()
          local filepath = node:get_id()
          local filename = node.name
          local modify = vim.fn.fnamemodify

          local vals = {
            ["BASENAME"] = modify(filename, ":r"),
            ["EXTENSION"] = modify(filename, ":e"),
            ["FILENAME"] = filename,
            ["PATH (CWD)"] = modify(filepath, ":."),
            ["PATH (HOME)"] = modify(filepath, ":~"),
            ["PATH"] = filepath,
            ["URI"] = vim.uri_from_fname(filepath),
          }

          local options = vim.tbl_filter(function(val)
            return vals[val] ~= ""
          end, vim.tbl_keys(vals))
          if vim.tbl_isempty(options) then
            M.notify("No values to copy", vim.log.levels.WARN)
            return
          end
          table.sort(options)
          vim.ui.select(options, {
            prompt = "Choose to copy to clipboard:",
            format_item = function(item)
              return ("%s: %s"):format(item, vals[item])
            end,
          }, function(choice)
            local result = vals[choice]
            if result then
              M.notify(("Copied: `%s`"):format(result))
              vim.fn.setreg("+", result)
            end
          end)
        end,
        find_in_dir = function(state)
          local node = state.tree:get_node()
          local path = node.type == "file" and node:get_parent_id() or node:get_id()
          vim.api.nvim_echo({ { "Searching in " .. path, "Normal" } }, true, {})
          -- require("telescope.builtin").find_files({ cwd = path })
          LazyVim.pick("files", { cwd = path })()
        end,
        -- https://github.com/UnicornDot/Astrovim/blob/b3cdce0c3cb3982a56203b8ba3cddcea584a6937/lua/plugins/neo-tree.lua#L45
        copy_absolute_path = function(state)
          local absolute_path = state.tree:get_node():get_id()
          vim.fn.setreg("+", absolute_path)
        end,
        copy_relative_path = function(state)
          local absolute_path = state.tree:get_node():get_id()
          local relative_path = M.remove_cwd(absolute_path)
          vim.fn.setreg("+", relative_path)
        end,
      },
      window = {
        ---@type table<string, string|fun(state:NeoTreeState)|table<string, string|fun(state:NeoTreeState)>>
        mappings = {
          ["l"] = "open",
          ["h"] = "close_node",
          ["<space>"] = "none",
          -- ["b"] = function()
          --   vim.api.nvim_exec2("Neotree focus buffers left", { output = true })
          -- end,
          -- ["g"] = function()
          --   vim.api.nvim_exec2("Neotree focus git_status left", { output = true })
          -- end,
          ["<C-s>"] = "open_split",
          ["v"] = "open_vsplit",
          ["D"] = function(state)
            local node = state.tree:get_node()
            local log = require("neo-tree.log")
            state.clipboard = state.clipboard or {}
            if DiffNode and DiffNode ~= tostring(node.id) then
              local current_diff = node.id
              require("neo-tree.utils").open_file(state, DiffNode, "open")
              vim.cmd("vert diffs " .. current_diff)
              log.info("Diffing " .. DiffName .. " against " .. node.name)
              DiffNode = nil
              current_diff = nil
              state.clipboard = {}
              require("neo-tree.ui.renderer").redraw(state)
            else
              local existing = state.clipboard[node.id]
              if existing and existing.action == "diff" then
                state.clipboard[node.id] = nil
                DiffNode = nil
                require("neo-tree.ui.renderer").redraw(state)
              else
                state.clipboard[node.id] = { action = "diff", node = node }
                DiffName = state.clipboard[node.id].node.name
                DiffNode = tostring(state.clipboard[node.id].node.id)
                log.info("Diff source file " .. DiffName)
                require("neo-tree.ui.renderer").redraw(state)
              end
            end
          end,
          ["F"] = "find_in_dir",
          ["y"] = "copy_selector",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "copy path to clipboard",
          },
          -- set_default_mappings() found conflicting mapping for S: <Lua 1265: ~/.local/share/nvim/lazy/neo-tree.nvim/lua/neo-tree/ui/renderer.lua:856>
          -- set_default_mappings() found conflicting mapping for s: <Lua 1237: ~/.local/share/nvim/lazy/neo-tree.nvim/lua/neo-tree/ui/renderer.lua:856>
          -- ["S"] = function()
          --   local leap_util = require("util.leap")
          --   local buf = vim.api.nvim_get_current_buf()
          --   local leap = leap_util.get_leap_for_buf(buf)
          --   leap()
          -- end,
          ["s"] = {
            function()
              if not package.loaded["leap"] then return end

              local leap_util = require("util.leap")
              local buf = vim.api.nvim_get_current_buf()
              local leap = leap_util.get_leap_for_buf(buf)
              leap()
            end,
            desc = "Leap",
          },
          ["'"] = "copy_absolute_path",
          ['"'] = "copy_relative_path",
          ["G"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              local fs_stat = vim.uv.fs_stat(path)
              if fs_stat and fs_stat.type == "file" then path = vim.fn.fnamemodify(path, ":h") end
              LazyVim.pick("files", { cwd = path })
            end,
            desc = "Grep in dir",
          },
          -- Handled by edgy
          ["e"] = "",
          unpack(astrovim_style and {
            ["[b"] = "prev_source",
            ["]b"] = "next_source",
          } or {}),
        },
      },
      filesystem = {
        -- hijack_netrw_behavior = "open_default",
        window = {
          mappings = {
            ["<M-d>"] = "fuzzy_finder_directory",
          },
        },
        filtered_items = {
          --   always_show = { ".github", ".gitignore" },
          --   hide_dotfiles = false,
          --   hide_gitignored = false,
          --   hide_by_name = {
          --     ".git",
          --     "node_modules",
          --   },
          never_show = {
            ".DS_Store",
            "thumbs.db",
          },
        }, -- },
      },
      source_selector = astrovim_style
          and {
            winbar = true,
            content_layout = "center",
            sources = {
              { source = "filesystem", display_name = "" .. "File" },
              { source = "buffers", display_name = "󰈙" .. "Bufs" },
              { source = "git_status", display_name = "󰒡" .. "Git Status" },
            },
            -- sources = { "filesystem", "buffers", "git_status" },
          }
        or {},
      -- open_files_do_not_resize = {
      --   "terminal",
      --   "Trouble",
      --   "qf",
      --   "Outline",
      --   "trouble",
      --   "dap-repl",
      --   "dap-float",
      --   "dapui_scopes",
      --   "dapui_console",
      --   "dapui_hover",
      --   "dapui_breakpoints",
      --   "dapui_stacks",
      --   "dapui_watches",
      --   "edgy",
      -- },
    },
    keys = {
      {
        "<leader>gE",
        function()
          require("neo-tree.command").execute({ source = "git_status", git_base = "HEAD~2", toggle = false })
        end,
        desc = "Git Explorer (HEAD~2)",
      },
    },
  },
  astrovim_style
      and {
        "folke/edgy.nvim",
        optional = true,
        opts = function(_, opts)
          local indexes = {}
          for i, source in opts.left do
            if source.title == "NeoTree Buffers" or source.title == "Neo-Tree Git status" then
              table.insert(indexes, i)
            end
          end
          for i = #indexes, 1, -1 do
            table.remove(opts.left, indexes[i])
          end
        end,
      }
    or {},
}

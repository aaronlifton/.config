local utils = {
  notify = function(msg, level)
    vim.notify(msg, level, { title = "NeoTree" })
  end,
}

return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    -- auto_clean_after_session_restore = true,
    close_if_last_window = true,
    commands = {
      parent_or_close = function(state)
        local node = state.tree:get_node()
        if (node.type == "directory" or node:has_children()) and node:is_expanded() then
          state.commands.toggle_node(state)
        else
          require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
        end
      end,
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
          utils.notify("No values to copy", vim.log.levels.WARN)
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
            utils.notify(("Copied: `%s`"):format(result))
            vim.fn.setreg("+", result)
          end
        end)
      end,
      find_in_dir = function(state)
        local node = state.tree:get_node()
        local path = node.type == "file" and node:get_parent_id() or node:get_id()
        vim.api.nvim_echo({ { "Searching in " .. path, "Normal" } }, true, {})
        require("telescope.builtin").find_files({ cwd = path })
      end,
    },
    window = {
      mappings = {
        ["l"] = "open",
        ["e"] = function()
          vim.api.nvim_exec("Neotree focus filesystem left", true)
        end,
        ["b"] = function()
          vim.api.nvim_exec("Neotree focus buffers left", true)
        end,
        ["g"] = function()
          vim.api.nvim_exec("Neotree focus git_status left", true)
        end,
        ["h"] = "close_node",
        ["<C-/>"] = "fuzzy_finder_directory",
        ["D"] = function(state)
          local node = state.tree:get_node()
          local log = require("neo-tree.log")
          state.clipboard = state.clipboard or {}
          if diff_Node and diff_Node ~= tostring(node.id) then
            local current_Diff = node.id
            require("neo-tree.utils").open_file(state, diff_Node, open)
            vim.cmd("vert diffs " .. current_Diff)
            log.info("Diffing " .. diff_Name .. " against " .. node.name)
            diff_Node = nil
            current_Diff = nil
            state.clipboard = {}
            require("neo-tree.ui.renderer").redraw(state)
          else
            local existing = state.clipboard[node.id]
            if existing and existing.action == "diff" then
              state.clipboard[node.id] = nil
              diff_Node = nil
              require("neo-tree.ui.renderer").redraw(state)
            else
              state.clipboard[node.id] = { action = "diff", node = node }
              diff_Name = state.clipboard[node.id].node.name
              diff_Node = tostring(state.clipboard[node.id].node.id)
              log.info("Diff source file " .. diff_Name)
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
        -- ["J"] = function()
        ["S"] = function()
          local leap_util = require("util.leap")
          local buf = vim.api.nvim_get_current_buf()
          local leap = leap_util.get_leap_for_buf(buf)
          leap()
        end,
      },
    },
    filesystem = {
      hijack_netrw_behavior = "open_default",
      window = {
        mappings = {
          ["O"] = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.jobstart({ "open", path }, { detach = true })
          end,
        },
      },
    },
    open_files_do_not_resize = {
      "terminal",
      "Trouble",
      "qf",
      "Outline",
      "trouble",
      "Arrow",
      "dap-repl",
      "dap-float",
      "dapui_scopes",
      "dapui_console",
      "dapui_hover",
      "dapui_breakpoints",
      "dapui_stacks",
      "dapui_watches",
      "edgy",
    },
  },
}

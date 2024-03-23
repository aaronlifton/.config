local sort_func = function(a, b)
  -- create a sort function that lists Ruby on Rails in the folloing order:
  if a.type == b.type then
    return a.path < b.path
  else
    return a.type < b.type
  end
end

return {
  "nvim-neo-tree/neo-tree.nvim",
  optional = true,
  -- enabled = false,
  opts = function(_, opts)
    opts.open_files_do_not_replace_types = opts.open_files_do_not_replace_types
      or { "terminal", "Trouble", "qf", "Outline", "trouble", "Arrow" }
    table.insert(opts.open_files_do_not_replace_types, "edgy")
    vim.tbl_deep_extend("force", opts, {
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
      filesystem = {
        -- bind_to_cwd = true,
        -- hijack_netrw_behavior = "open_current",
      },
      commands = {
        system_open = function(state)
          vim.ui.open(state.tree:get_node():get_id())
        end,
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
          require("telescope.builtin").find_files({ cwd = path })
        end,
      },
      window = {
        mappings = {
          O = "system_open",
          H = "parent_or_close",
          y = "copy_selector",
          e = "none",
          F = "find_in_dir",
          ["<space>"] = "none",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "copy path to clipboard",
          },
        },
      },
    })
  end,
}

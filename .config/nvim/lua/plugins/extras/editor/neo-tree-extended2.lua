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

local function copy_selector(state, type)
  local node = state.tree:get_node()
  local filepath = node:get_id()
  local filename = node.name
  local modify = vim.fn.fnamemodify

  local vals = {
    ["basename"] = modify(filename, ":r"),
    ["filename"] = filename,
    ["cwd"] = modify(filepath, ":."),
    ["abs_norm"] = modify(filepath, ":~"),
    ["abs"] = filepath,
  }

  return vals[type]
end

return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    optional = true,
    opts = {
      close_if_last_window = true,
      popup_border_style = "rounded",
      commands = {
        -- https://github.com/AstroNvim/AstroNvim/blob/34208f8fed7521380930cea3ec4f65f993fe22d2/lua/plugins/neo-tree.lua#L10
        -- https://github.com/UnicornDot/Astrovim/blob/b3cdce0c3cb3982a56203b8ba3cddcea584a6937/lua/plugins/neo-tree.lua#L45
        copy_absolute_path = function(state)
          local path = copy_selector(state, "abs")
          vim.fn.setreg("+", path)
        end,
        copy_relative_path = function(state)
          local path = copy_selector(state, "cwd")
          vim.fn.setreg("+", path)
        end,
        copy_filename = function(state)
          local path = copy_selector(state, "filename")
          vim.fn.setreg("+", path)
        end,
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
      },
      window = {
        ---@type table<string, string|fun(state:NeoTreeState)|table<string, string|fun(state:NeoTreeState)>>
        mappings = {
          ["y"] = "copy_selector",
          ["Y"] = {
            function(state)
              local node = state.tree:get_node()
              local path = node:get_id()
              vim.fn.setreg("+", path, "c")
            end,
            desc = "copy path to clipboard",
          },
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
          ["s"] = {
            function()
              -- if not package.loaded["leap"] then return end
              if not package.loaded["leap"] then vim.cmd([[Lazy load leap.nvim]]) end

              local leap_util = require("util.leap")
              local buf = vim.api.nvim_get_current_buf()
              local leap = leap_util.get_leap_for_buf(buf)
              leap()
            end,
            desc = "Leap",
          },
          -- Handled by edgy
          ["e"] = "",
        },
      },
      filesystem = {
        hijack_netrw_behavior = "open_default",
        window = {
          mappings = {
            ["<M-d>"] = "fuzzy_finder_directory",
          },
        },
        filtered_items = {
          always_show = { ".github" },
          never_show = {
            ".DS_Store",
            "thumbs.db",
          },
        },
      },
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
}

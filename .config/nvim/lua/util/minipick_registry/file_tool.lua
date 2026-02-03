local M = {}

local FlagManager = require("util.flag_manager")

local function append_flag_args(cmd, flag)
  if type(flag) == "string" then
    for _, part in ipairs(vim.split(flag, "%s+", { trimempty = true })) do
      table.insert(cmd, part)
    end
    -- elseif type(flag) == "table" then
    --   vim.list_extend(cmd, flag)
  end
end

local function fd_tool()
  local flag_map = FlagManager.fd_flags
  return {
    key = "fd",
    supports = { regex = true, excludes = true },
    flag_map = flag_map,
    build_command = function(opts)
      -- local cmd = { "fd", "--type", "f", "--color", "never", "--follow", "--exclude", ".git" }
      local cmd = {
        "fd",
        "--type",
        "f",
        "--color",
        "never",
        "--follow",
        "--exclude",
        ".git",
        "--exclude",
        "'**/dist/*.js*'",
        "--exclude",
        "'**/dist/*.css*'",
        "--exclude",
        "'*.min.*'",
        "--exclude",
        "'*-min.*'",
      }

      for flag, val in pairs(opts.flags or {}) do
        if flag ~= "regex" then append_flag_args(cmd, flag_map[flag] or flag, val) end
      end
      for _, pattern in ipairs(opts.excludes or {}) do
        table.insert(cmd, "--exclude")
        table.insert(cmd, pattern)
      end
      if opts.regex_mode and opts.pattern and opts.pattern ~= "" then
        table.insert(cmd, "--regex")
        table.insert(cmd, opts.pattern)
      end
      return cmd
    end,
  }
end

local function rg_tool()
  local flag_map = FlagManager.rg_file_flags
  return {
    key = "rg",
    supports = { regex = false, excludes = true },
    flag_map = flag_map,
    build_command = function(opts)
      local cmd = { "rg", "--files", "--color", "never", "--follow", "--glob", "!**/.git/**" }
      for _, flag in ipairs(opts.flags or {}) do
        local flag_value = flag_map[flag]
        if flag_value then append_flag_args(cmd, flag_value) end
      end
      for _, pattern in ipairs(opts.excludes or {}) do
        local glob = pattern
        if not vim.startswith(glob, "!") then glob = "!" .. glob end
        table.insert(cmd, "--glob")
        table.insert(cmd, glob)
      end
      return cmd
    end,
  }
end

function M.get(tool_key)
  if tool_key == "rg" then return rg_tool() end
  return fd_tool()
end

function M.is_flag_supported(tool, flag_key)
  return tool.flag_map and tool.flag_map[flag_key] ~= nil
end

function M.filter_flags(tool, flags)
  local filtered = {}
  for flag, val in pairs(flags or {}) do
    if M.is_flag_supported(tool, flag) then filtered[flag] = val end
  end
  return filtered
end

function M.flag_label(tool, flag_key)
  if tool.flag_map and tool.flag_map[flag_key] ~= nil then return tool.flag_map[flag_key] end
  return flag_key
end

return M

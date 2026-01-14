local M = {}
local H = {}

H.get_config = function(config)
  return vim.tbl_deep_extend("force", MiniPick.config, vim.b.minipick_config or {}, config or {})
end

H.full_path = function(path)
  return (vim.fn.fnamemodify(path, ":p"):gsub("(.)/$", "%1"))
end

local FlagManager = require("util.minipick_registry.flag_manager")

local function build_fd_command(flags, excludes)
  local cmd = { "fd", "--type", "f", "--color", "never", "--follow", "--exclude", ".git" }
  -- Add flags (including --hidden if enabled)
  for _, flag in ipairs(flags) do
    local flag_value = FlagManager.fd_flags[flag] or flag
    for _, part in ipairs(vim.split(flag_value, "%s+", { trimempty = true })) do
      table.insert(cmd, part)
    end
  end
  -- Add excludes
  for _, pattern in ipairs(excludes) do
    table.insert(cmd, "--exclude")
    table.insert(cmd, pattern)
  end
  return cmd
end

local function create_files_picker(MiniPick)
  return function(local_opts, opts)
    local_opts = vim.tbl_deep_extend("force", { tool = nil }, local_opts or {})
    local tool = "fd"
    local show = H.get_config().source.show or H.show_with_icons
    local default_opts = { source = { name = string.format("Files (%s)", tool), show = show } }
    opts = vim.tbl_deep_extend("force", default_opts, opts or {})

    local flags = local_opts.flags or { "hidden" }
    local excludes = local_opts.excludes or {}
    return MiniPick.builtin.cli({ command = build_fd_command(flags, excludes) }, opts)
  end
end

M.setup = function(MiniPick)
  MiniPick.registry.files_ext = create_files_picker(MiniPick)
end

return M

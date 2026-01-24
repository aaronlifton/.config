local M = {}
local H = {}
local P = require("util.minipick_registry.picker").H

local FileTool = require("util.minipick_registry.file_tool")

local function create_files_picker(MiniPick)
  return function(local_opts, opts)
    if not local_opts.tool then local_opts.tool = "fd" end

    local tool = FileTool.get(local_opts.tool)
    local show = P.get_config().source.show
    local default_opts = { source = { name = string.format("Files (%s)", tool.key), show = show } }
    opts = vim.tbl_deep_extend("force", default_opts, opts or {})

    local flags = local_opts.flags or { "hidden" }
    local excludes = local_opts.excludes or {}

    local command = tool.build_command({
      pattern = nil,
      flags = flags,
      excludes = excludes,
      regex_mode = false,
    })

    return MiniPick.builtin.cli({ command = command }, opts)
  end
end

M.setup = function(MiniPick)
  MiniPick.registry.files_ext = create_files_picker(MiniPick)
end

return M

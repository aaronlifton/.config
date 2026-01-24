local M = {}

local H = {}
local P = require("util.minipick_registry.picker").H

local FlagManager = require("util.flag_manager")
local Grep = require("util.minipick_registry.grep")
local GrepExt = require("util.minipick_registry.grep_ext")

local function create_rg_grep_picker(MiniPick)
  return function(local_opts, opts)
    local_opts = vim.tbl_extend("force", { tool = "rg", pattern = nil, globs = {}, flags = {} }, local_opts or {})
    local tool = local_opts.tool
    if tool == "fallback" or not P.is_executable(tool) then H.error("`rg_grep` needs non-fallback executable tool.") end

    local globs = P.is_array_of(local_opts.globs, "string") and local_opts.globs or {}
    local flags = FlagManager.resolve_rg_flags(P.is_array_of(local_opts.flags, "string") and local_opts.flags or nil)
    local formatted_name
    if opts and opts.source and opts.source.name then
      formatted_name = opts.source.name and (opts.source.name):format(" %s ") or nil
    end

    -- Show options (can be set via local_opts)
    local show_opts = {
      ts_highlight = local_opts.ts_highlight, -- nil = use global, false = disabled, true = enabled
      path_max_width = local_opts.path_max_width, -- nil = use global or no truncation
      path_truncate_mode = local_opts.path_truncate_mode, -- "head", "middle", "smart" (default)
    }

    local function build_name_suffix()
      return GrepExt.build_rg_name_suffix(globs, flags, show_opts)
    end

    local function build_name(pattern)
      local name_suffix = build_name_suffix()
      if formatted_name then
        return string.format("Grep '%s' (%s%s) | %s | %s", pattern, tool, name_suffix, formatted_name)
      end
      return string.format("Grep '%s' (%s%s)", pattern, tool, name_suffix)
    end

    local function get_show_func()
      return function(buf_id, items, query)
        Grep.grep_ts_show(buf_id, items, query, show_opts)
      end
    end

    local pattern = type(local_opts.pattern) == "string" and local_opts.pattern

    local name = build_name(pattern)
    local default_source = {
      name = name,
      show = get_show_func(),
      choose_marked = require("util.minipick_registry.trouble").trouble_choose_marked,
    }

    opts = vim.tbl_deep_extend("force", { source = default_source }, opts or {})
    opts.source.name = default_source.name

    local function refresh_items()
      local command = Grep.grep_get_command(pattern, globs, flags)
      MiniPick.set_picker_items_from_cli(command, { set_items_opts = { do_match = false } })
    end

    -- local function toggle_dotall()
    --   FlagManager.toggle_flag(flags, "dotall")
    --   MiniPick.set_picker_opts({ source = { name = build_name() } })
    --   refresh_items()
    -- end
    local function sync_query()
      MiniPick.set_picker_query(MiniPick.get_picker_query())
    end

    local mappings = GrepExt.build_rg_mappings(MiniPick, {
      globs = globs,
      flags = flags,
      show_opts = show_opts,
      build_name = function()
        return build_name(pattern)
      end,
      get_show_func = get_show_func,
      refresh = refresh_items,
      sync_query = sync_query,
      default_behavior = { refresh = true },
      show_behavior = { refresh = false, sync_query = true },
    })

    -- local mappings = FlagManager.build_rg_flag_mappings({
    --   add_glob = common_handlers.add_glob,
    --   remove_glob = common_handlers.remove_glob,
    --   toggle_no_ignore = common_handlers.toggle_no_ignore,
    --   toggle_hidden = common_handlers.toggle_hidden,
    --   toggle_iglob_pattern = common_handlers.toggle_iglob_pattern,
    --   toggle_extra_flag = common_handlers.toggle_extra_flag,
    --   toggle_dotall = toggle_dotall,
    --   toggle_ts_highlight = common_handlers.toggle_ts_highlight,
    --   toggle_path_width = common_handlers.toggle_path_width,
    -- })

    opts = vim.tbl_deep_extend("force", opts or {}, { mappings = mappings })
    -- vim.api.nvim_echo({ { "rg grep\n", "Title" }, { vim.inspect(opts.source.cwd), "Normal" } }, true, {})
    MiniPick.builtin.cli({ command = Grep.grep_get_command(pattern, globs, flags) }, opts)
  end
end

M.setup = function(MiniPick)
  MiniPick.registry.rg_grep = create_rg_grep_picker(MiniPick)
end

return M

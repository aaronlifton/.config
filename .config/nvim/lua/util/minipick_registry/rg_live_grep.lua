-- iglob treesitter pickerG
local M = {}

-- Helpers
local H = {}
local P = require("util.minipick_registry.picker").H

local FlagManager = require("util.flag_manager")
local Grep = require("util.minipick_registry.grep")
local GrepExt = require("util.minipick_registry.grep_ext")
local SnacksUtil = require("snacks.util")

local function create_rg_live_grep_picker(MiniPick)
  return function(local_opts, opts)
    local_opts = local_opts or {}
    if local_opts.tool == nil then local_opts.tool = "rg" end
    if local_opts.globs == nil then local_opts.globs = {} end
    if local_opts.flags == nil then local_opts.flags = {} end
    local tool = local_opts.tool -- or H.grep_get_tool()
    if tool == "fallback" or not P.is_executable(tool) then
      H.error("`grep_live` needs non-fallback executable tool.")
    end

    local globs = P.is_array_of(local_opts.globs, "string") and local_opts.globs or {}
    local flags = FlagManager.resolve_rg_flags(P.is_array_of(local_opts.flags, "string") and local_opts.flags or nil)
    local custom_name = opts.source.name or "Grep live"

    -- Show options (can be set via local_opts)
    local show_opts = {
      ts_highlight = local_opts.ts_highlight, -- nil = use global, false = disabled, true = enabled
      path_max_width = local_opts.path_max_width, -- nil = use global or no truncation
      path_truncate_mode = local_opts.path_truncate_mode, -- "head", "middle", "smart" (default)
    }

    local function build_name_suffix()
      return GrepExt.build_rg_name_suffix(globs, flags, show_opts)
    end

    local function build_name()
      local name_suffix = build_name_suffix()
      return string.format("%s (%s%s)", custom_name, tool, name_suffix)
    end

    local function get_show_func()
      return function(buf_id, items, query)
        Grep.grep_ts_show(buf_id, items, query, show_opts)
      end
    end

    local name = build_name()
    local default_source = {
      name = name,
      show = get_show_func(),
      choose_marked = require("util.minipick_registry.trouble").trouble_choose_marked,
    }

    opts = vim.tbl_deep_extend("force", { source = default_source }, opts or {})
    opts.source.name = default_source.name

    local cwd = P.full_path(opts.source.cwd or vim.fn.getcwd())
    -- Querytick is set inside of `match` instead of here so stale processes
    -- can't reuse the latest querytick.
    local spawn_opts = { cwd = cwd }
    local process
    local function do_match(_, _, query)
      ---@diagnostic disable-next-line: undefined-field
      pcall(vim.loop.process_kill, process)

      local querytick = MiniPick.get_querytick()
      -- if `do_match` is true, the displayed line (which includes filename + text)
      -- is matched, so an item that matches in both filename and text gets a
      -- higher score and bubbles to the top.
      local set_items_opts = { do_match = false, querytick = querytick }
      if #query == 0 then return MiniPick.set_picker_items({}, set_items_opts) end

      local search_pattern, iglob_patterns = Grep.parse_query(table.concat(query))

      if search_pattern == "" then return MiniPick.set_picker_items({}, set_items_opts) end

      local all_globs = vim.list_extend(vim.list_extend({}, iglob_patterns), globs)

      local command = Grep.grep_get_command(search_pattern, all_globs, flags)

      process = MiniPick.set_picker_items_from_cli(command, {
        -- This waits for the latest process to complete
        -- postprocess = function(items)
        --   if querytick ~= MiniPick.get_querytick() then return {} end
        --   return items
        -- end,
        set_items_opts = set_items_opts,
        spawn_opts = spawn_opts,
      })
    end

    local throttled_match
    do
      local last_args
      local function run()
        if not last_args then return end
        do_match(unpack(last_args))
      end
      local throttled = SnacksUtil.throttle(run, { ms = local_opts.throttle_ms or 20 })
      throttled_match = function(...)
        last_args = { ... }
        throttled()
      end
    end

    local mappings = GrepExt.build_rg_mappings(MiniPick, {
      globs = globs,
      flags = flags,
      show_opts = show_opts,
      build_name = build_name,
      get_show_func = get_show_func,
      default_behavior = { sync_query = true },
      show_behavior = { sync_query = true },
    })

    opts = vim.tbl_deep_extend(
      "force",
      opts or {},
      { source = { items = {}, match = throttled_match }, mappings = mappings }
    )
    -- opts.source.preview = require("util.minipick_registry.preview").preview
    return MiniPick.start(opts)
  end
end

M.setup = function(MiniPick)
  MiniPick.registry.rg_live_grep = create_rg_live_grep_picker(MiniPick)
end

return M

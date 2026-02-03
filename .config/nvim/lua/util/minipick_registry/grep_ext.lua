local M = {}

local FlagManager = require("util.flag_manager")

function M.build_rg_name_suffix(globs, flags, show_opts)
  local parts = {}
  if #globs > 0 then parts[#parts + 1] = table.concat(globs, ", ") end
  local flag_parts = {}
  for _, flag in ipairs(flags) do
    flag_parts[#flag_parts + 1] = FlagManager.rg_flags[flag] or flag
  end
  if show_opts.ts_highlight == false then flag_parts[#flag_parts + 1] = "no-ts" end
  if show_opts.path_max_width then flag_parts[#flag_parts + 1] = "path:" .. show_opts.path_max_width end
  if #flag_parts > 0 then parts[#parts + 1] = table.concat(flag_parts, ", ") end
  return #parts == 0 and "" or (" | " .. table.concat(parts, " | "))
end

local function sync_query()
  MiniPick.set_picker_query(MiniPick.get_picker_query())
end

function M.build_rg_mappings(MiniPick, ctx)
  local function update(opts, behavior)
    local source = { name = ctx.build_name() }
    if opts and opts.show then source.show = opts.show end
    MiniPick.set_picker_opts({ source = source })

    local behavior_opts = behavior or ctx.default_behavior or {}
    if behavior_opts.refresh and ctx.refresh then ctx.refresh() end
    if behavior_opts.sync_query then sync_query() end
  end

  local function add_glob()
    local ok, glob = pcall(vim.fn.input, "iglob pattern: ")
    if ok then table.insert(ctx.globs, glob) end
    update()
  end

  local function remove_glob()
    if #ctx.globs > 0 then
      table.remove(ctx.globs)
      update()
    end
  end

  local function toggle_no_ignore()
    FlagManager.toggle_patterns(ctx.flags, "no_ignore")
    update()
  end

  local function toggle_hidden()
    FlagManager.toggle_patterns(ctx.flags, "hidden")
    update()
  end

  local function toggle_extra_flag(flag_key)
    return function()
      FlagManager.toggle_patterns(ctx.flags, flag_key)
      update()
    end
  end

  local function toggle_ts_highlight()
    if ctx.show_opts.ts_highlight == nil then
      ctx.show_opts.ts_highlight = false
    else
      ctx.show_opts.ts_highlight = nil
    end
    update({ show = ctx.get_show_func() }, ctx.show_behavior)
  end

  local function toggle_path_width()
    local widths = ctx.path_widths or { nil, 60, 40, 80 }
    local current_idx = 1
    for i, w in ipairs(widths) do
      if ctx.show_opts.path_max_width == w then
        current_idx = i
        break
      end
    end
    ctx.show_opts.path_max_width = widths[(current_idx % #widths) + 1]
    update({ show = ctx.get_show_func() }, ctx.show_behavior)
  end

  local function toggle_iglob_pattern(pattern_key)
    return function()
      local pattern = FlagManager.iglob_patterns[pattern_key]
      if not FlagManager.toggle_glob_pattern(ctx.globs, pattern) then return end
      update()
    end
  end

  local function toggle_dotall()
    -- local dotall_pattern = "(?s)."
    -- local dotall_pattern = "(?s:.)"
    local dotall_pattern = ".*\\n(?s:.).*"
    FlagManager.toggle_patterns(ctx.flags, "dotall")
    local dotall_enabled = vim.tbl_contains(ctx.flags, "dotall")
    local query = MiniPick.get_picker_query()
    local query_str = table.concat(query)

    if dotall_enabled then
      -- Add (?s:.) after current query
      if not query_str:find(vim.pesc(dotall_pattern), 1, true) then query_str = query_str .. dotall_pattern end
    else
      -- Remove (?s:.) from query
      query_str = query_str:gsub(vim.pesc(dotall_pattern), "")
    end

    update()
    MiniPick.set_picker_query(vim.split(query_str, ""))
  end

  local mappings = FlagManager.build_rg_flag_mappings({
    add_glob = add_glob,
    remove_glob = remove_glob,
    toggle_no_ignore = toggle_no_ignore,
    toggle_hidden = toggle_hidden,
    toggle_iglob_pattern = toggle_iglob_pattern,
    toggle_extra_flag = toggle_extra_flag,
    toggle_ts_highlight = toggle_ts_highlight,
    toggle_path_width = toggle_path_width,
    toggle_dotall = toggle_dotall,
  })

  return mappings
end

return M

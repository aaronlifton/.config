local M = {}

local H = {}
H.is_executable = function(tool)
  if tool == "fallback" then return true end
  return vim.fn.executable(tool) == 1
end
H.is_array_of = function(x, ref_type)
  if not vim.tbl_islist(x) then return false end
  for i = 1, #x do
    if type(x[i]) ~= ref_type then return false end
  end
  return true
end
H.get_config = function(config)
  return vim.tbl_deep_extend("force", MiniPick.config, vim.b.minipick_config or {}, config or {})
end
H.full_path = function(path)
  return (vim.fn.fnamemodify(path, ":p"):gsub("(.)/$", "%1"))
end
local function parse_query(raw)
  local search, iglob = raw:match("^(.-)%s+%-%-%s+(.*)$")
  if not search then return vim.trim(raw), {} end

  local patterns = {}
  for _, part in ipairs(vim.split(vim.trim(iglob), "%s+", { trimempty = true })) do
    patterns[#patterns + 1] = part
  end

  return vim.trim(search), patterns
end

local function map_gsub(items, pattern, replacement)
  return vim.tbl_map(function(item)
    item, _ = string.gsub(item, pattern, replacement)
    return item
  end, items)
end

H.default_show_with_icons = function(buf_id, items, query)
  items = map_gsub(items, "%z", "#|#")
  items = require("mini.align").align_strings(items, {
    justify_side = { "left", "right", "right" },
    merge_delimiter = { "", " ", "", " ", "" },
    split_pattern = "#|#",
  })
  items = map_gsub(items, "#|#", "\0")

  local tab_spaces = string.rep(" ", vim.o.tabstop)
  local aligned_lines = vim.tbl_map(function(l)
    return l:gsub("%z", "│"):gsub("[\r\n]", " "):gsub("\t", tab_spaces)
  end, aligned_items)

  MiniPick.default_show(buf_id, items, query, { show_icons = true })
end

function H.grep_get_command(pattern, globs, flags)
  local res = {
    "rg",
    "--column",
    "--line-number",
    "--no-heading",
    "--field-match-separator",
    "\\x00",
    "--color=never",
  }
  if flags then
    if flags.no_ignore then table.insert(res, "--no-ignore") end
    if flags.hidden then table.insert(res, "--hidden") end
  end
  for _, g in ipairs(globs) do
    table.insert(res, "--iglob")
    -- NOTE: no `*` as default is important to not "override" ignoring files
    table.insert(res, g)
  end
  local case = vim.o.ignorecase and (vim.o.smartcase and "smart-case" or "ignore-case") or "case-sensitive"
  vim.list_extend(res, { "--" .. case, "--", pattern })
  return res
end

local function create_iglob_picker(MiniPick)
  return function(local_opts, opts)
    local function igrep_live(local_opts, opts)
      local_opts = vim.tbl_extend("force", { tool = "rg", globs = {}, flags = {} }, local_opts or {})
      local tool = local_opts.tool -- or H.grep_get_tool()
      if tool == "fallback" or not H.is_executable(tool) then
        H.error("`grep_live` needs non-fallback executable tool.")
      end

      local globs = H.is_array_of(local_opts.globs, "string") and local_opts.globs or {}
      local flags = {
        no_ignore = local_opts.flags.no_ignore == true,
        hidden = local_opts.flags.hidden == true,
      }
      local formatted_name
      if opts.source.name then formatted_name = opts.source.name and (opts.source.name):format(" %s ") or nil end

      local function build_name_suffix()
        local parts = {}
        if #globs > 0 then parts[#parts + 1] = table.concat(globs, ", ") end
        local flags_label = (flags.hidden and "H" or "") .. (flags.no_ignore and "I" or "")
        if flags_label ~= "" then parts[#parts + 1] = flags_label end
        return #parts == 0 and "" or (" | " .. table.concat(parts, " | "))
      end
      local name_suffix = build_name_suffix()
      local show = H.get_config().source.show or H.show_with_icons
      local function build_name()
        name_suffix = build_name_suffix()
        if formatted_name then return string.format("Grep live (%s%s) | %s", tool, name_suffix, formatted_name) end
        return string.format("Grep live (%s%s)", tool, name_suffix)
      end
      local name = build_name()
      local default_source = { name = name, show = show }

      opts = vim.tbl_deep_extend("force", { source = default_source }, opts or {})
      opts.source.name = default_source.name

      local cwd = H.full_path(opts.source.cwd or vim.fn.getcwd())
      local set_items_opts, spawn_opts = { do_match = false, querytick = H.querytick }, { cwd = cwd }
      local process
      local match = function(_, _, query)
        ---@diagnostic disable-next-line: undefined-field
        pcall(vim.loop.process_kill, process)

        if #query == 0 then return MiniPick.set_picker_items({}, set_items_opts) end

        local full_query = table.concat(query)
        local search_pattern, iglob_patterns = parse_query(full_query)

        if search_pattern == "" then return MiniPick.set_picker_items({}, set_items_opts) end

        local all_globs = vim.list_extend(vim.list_extend({}, iglob_patterns), globs)

        local command = H.grep_get_command(search_pattern, all_globs, flags)

        process = MiniPick.set_picker_items_from_cli(command, {
          set_items_opts = set_items_opts,
          spawn_opts = spawn_opts,
        })
      end

      local add_glob = function()
        local ok, glob = pcall(vim.fn.input, "iglob pattern: ")
        if ok then table.insert(globs, glob) end
        MiniPick.set_picker_opts({ source = { name = build_name() } })
        MiniPick.set_picker_query(MiniPick.get_picker_query())
      end

      local remove_glob = function()
        if #globs > 0 then
          table.remove(globs)
          MiniPick.set_picker_opts({ source = { name = build_name() } })
          MiniPick.set_picker_query(MiniPick.get_picker_query())
        end
      end

      local toggle_no_ignore = function()
        flags.no_ignore = not flags.no_ignore
        vim.notify("here")
        MiniPick.set_picker_opts({ source = { name = build_name() } })
        MiniPick.set_picker_query(MiniPick.get_picker_query())
      end

      local toggle_hidden = function()
        flags.hidden = not flags.hidden
        MiniPick.set_picker_opts({ source = { name = build_name() } })
        MiniPick.set_picker_query(MiniPick.get_picker_query())
      end

      local mappings = {
        add_glob = { char = "<C-o>", func = add_glob },
        remove_glob = { char = "<C-k>", func = remove_glob },
        toggle_no_ignore = { char = "<M-i>", func = toggle_no_ignore },
        toggle_hidden = { char = "<M-h>", func = toggle_hidden },
      }

      opts = vim.tbl_deep_extend("force", opts or {}, { source = { items = {}, match = match }, mappings = mappings })
      return MiniPick.start(opts)
    end
    return igrep_live(local_opts, opts)
  end
end

M.setup = function(MiniPick)
  MiniPick.registry.iglob = create_iglob_picker(MiniPick)
end

return M

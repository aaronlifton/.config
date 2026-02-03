---@class util.snacks.actions
---@field toggle_lob fun(string, snacks.Picker)
--@field toggle_flag fun(string, snacks.Picker)
--@field cycle_flag fun(string[]|string, snacks.Picker, string[]|nil)
--@field toggle_ft fun(string|table, snacks.Picker)
local M = {}

local flag_manager = require("util.flag_manager")

M.glob_definitions = {
  lua = "*.lua",
}
M.globs = {
  lua = false,
}
M.iglob_patterns = flag_manager.iglob_patterns
M.fd_flags = flag_manager.fd_flags
M.rg_flags = flag_manager.rg_flags

local function ensure_args(p)
  if type(p.opts.args) ~= "table" then p.opts.args = {} end
  return p.opts.args
end

local function split_args(value)
  if type(value) == "table" then return vim.deepcopy(value) end
  if type(value) == "string" then return vim.split(value, "%s+", { trimempty = true }) end
  return {}
end

local function resolve_flag_args(flag_map, flag_key)
  local flag = flag_map[flag_key] or flag_key
  return split_args(flag)
end

local function has_all_args(args, flag_args)
  local present = {}
  for _, arg in ipairs(args) do
    present[arg] = (present[arg] or 0) + 1
  end
  for _, arg in ipairs(flag_args) do
    if not present[arg] or present[arg] == 0 then return false end
    present[arg] = present[arg] - 1
  end
  return true
end

local function remove_args(args, flag_args)
  for _, flag in ipairs(flag_args) do
    for i = #args, 1, -1 do
      if args[i] == flag then
        table.remove(args, i)
        break
      end
    end
  end
end

local function add_args(args, flag_args)
  local present = {}
  for _, arg in ipairs(args) do
    present[arg] = true
  end
  for _, flag in ipairs(flag_args) do
    if not present[flag] then
      args[#args + 1] = flag
      present[flag] = true
    end
  end
end

local function toggle_args(p, flag_args)
  if type(flag_args) ~= "table" or #flag_args == 0 then return end

  local did_remove = false
  local args = ensure_args(p)

  if has_all_args(args, flag_args) then
    remove_args(args, flag_args)
    did_remove = true
  else
    add_args(args, flag_args)
  end
  p:refresh()

  return did_remove
end

---@param p snacks.Picker
function M.toggle_glob(glob_name, p)
  -- { current = false, file = true, float = false }
  -- vim.notify(vim.inspect(p._main.opts))
  p.opts.glob = p.opts.glob or {}

  local new_glob
  if M.globs[glob_name] then
    new_glob = {}
    table.remove(p.opts.glob)
  else
    if M.glob_definitions[glob_name] then
      new_glob = { M.glob_definitions[glob_name] }
    else
      new_glob = glob_name
    end
    vim.list_extend(p.opts.glob, { new_glob })
  end
  M.globs[glob_name] = not M.globs[glob_name]

  ---@diagnostic disable-next-line: undefined-field
  p:find()
end

function M.toggle_lob(pattern_key, p)
  local orig_pattern = pattern_key
  local pattern = M.iglob_patterns[pattern_key]
  if not pattern then pattern = orig_pattern end

  p.opts.glob = p.opts.glob or {}
  flag_manager.toggle_patterns(p.opts.glob, pattern)
  p:refresh()
end

function M.toggle_flag(flag_key, p)
  local flag_map = p.opts.source == "files" and M.fd_flags or M.rg_flags
  local flag = flag_map[flag_key]
  local flag_args = split_args(flag)
  return toggle_args(p, flag_args)
end

function M.cycle_flag(flag_keys, p, excl_flags)
  if type(flag_keys) == "string" then flag_keys = { flag_keys } end
  if type(flag_keys) ~= "table" or #flag_keys == 0 then return end

  local flag_map = p.opts.source == "files" and M.fd_flags or M.rg_flags
  local args = ensure_args(p)

  local current_index
  for i, flag_key in ipairs(flag_keys) do
    local flag_args = resolve_flag_args(flag_map, flag_key)
    if #flag_args > 0 and has_all_args(args, flag_args) then
      current_index = i
      break
    end
  end

  if type(excl_flags) == "table" then
    for _, flag_key in ipairs(excl_flags) do
      local flag_args = resolve_flag_args(flag_map, flag_key)
      if #flag_args > 0 then remove_args(args, flag_args) end
    end
  end

  local next_index = current_index and ((current_index % (#flag_keys + 1)) + 1) or 1
  if next_index <= #flag_keys then
    local next_args = resolve_flag_args(flag_map, flag_keys[next_index])
    if #next_args > 0 then add_args(args, next_args) end
  end

  p:refresh()
end

local function ensure_ft(p)
  if p.opts.ft == nil then
    p.opts.ft = {}
  elseif type(p.opts.ft) == "string" then
    p.opts.ft = { p.opts.ft }
  end
  return p.opts.ft
end

local file_ft_map = {
  lua = { "lua" },
  ruby = { "rb" },
  python = { "py" },
  js = { "js", "jsx" },
  ts = { "ts", "tsx" },
  markdown = { "md", "mdx", "markdown", "mdown", "mdwn", "mkd", "mkdn" },
}

local function expand_file_types(types)
  local expanded = {}
  local present = {}
  for _, t in ipairs(types) do
    local mapped = file_ft_map[t]
    local values = mapped or { t }
    for _, value in ipairs(values) do
      if not present[value] then
        expanded[#expanded + 1] = value
        present[value] = true
      end
    end
  end
  return expanded
end

function M.toggle_ft(ft_value, p)
  local types = {}
  if type(ft_value) == "string" then
    types = { ft_value }
  elseif type(ft_value) == "table" then
    types = vim.deepcopy(ft_value)
  else
    return
  end

  if #types == 0 then return end

  if p.opts.source == "files" then types = expand_file_types(types) end

  local ft = ensure_ft(p)
  local present = {}
  for _, t in ipairs(ft) do
    present[t] = true
  end
  local all_present = true
  for _, t in ipairs(types) do
    if not present[t] then
      all_present = false
      break
    end
  end

  if all_present then
    for _, t in ipairs(types) do
      for idx = #ft, 1, -1 do
        if ft[idx] == t then
          table.remove(ft, idx)
          break
        end
      end
    end
  else
    for _, t in ipairs(types) do
      if not present[t] then ft[#ft + 1] = t end
    end
  end

  p:refresh()
end

return M

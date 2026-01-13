local M = {}

local allowed_modes = { all = true, n = true, x = true, s = true, o = true, i = true, l = true, c = true, t = true }
local allowed_scopes = { all = true, global = true, buf = true }
local all_modes = { "n", "x", "s", "o", "i", "l", "c", "t" }

local function ensure_text_width(str, width)
  local len = vim.fn.strchars(str)
  if len >= width then return str end
  return str .. string.rep(" ", width - len)
end

local function get_callback_pos(maparg)
  if type(maparg.callback) ~= "function" then return nil, nil end
  local info = debug.getinfo(maparg.callback)
  local path = info.source:gsub("^@", "")
  if vim.fn.filereadable(path) == 0 then return nil, nil end
  return path, info.linedefined
end

local function build_items(mode, scope)
  local items, max_lhs_width = {}, 0
  local populate_modes = mode == "all" and all_modes or { mode }
  local populate_items = function(source)
    for _, m in ipairs(populate_modes) do
      for _, maparg in ipairs(source(m)) do
        local desc = maparg.desc ~= nil and vim.inspect(maparg.desc) or maparg.rhs
        local lhs = vim.fn.keytrans(maparg.lhsraw or maparg.lhs)
        max_lhs_width = math.max(vim.fn.strchars(lhs), max_lhs_width)
        table.insert(items, { lhs = lhs, desc = desc, maparg = maparg })
      end
    end
  end

  if scope == "all" or scope == "buf" then
    populate_items(function(m)
      return vim.api.nvim_buf_get_keymap(0, m)
    end)
  end
  if scope == "all" or scope == "global" then populate_items(vim.api.nvim_get_keymap) end

  for _, item in ipairs(items) do
    local buf_map_indicator = item.maparg.buffer == 0 and " " or "@"
    local lhs_text = ensure_text_width(item.lhs, max_lhs_width)
    item.text = string.format("%s %s │ %s │ %s", item.maparg.mode, buf_map_indicator, lhs_text, item.desc or "")
  end

  return items
end

M.setup = function(MiniPick)
  MiniPick.registry.keymaps_callback = function(local_opts, opts)
    local_opts = vim.tbl_deep_extend("force", { mode = "all", scope = "all" }, local_opts or {})
    if not allowed_modes[local_opts.mode] then
      vim.notify("Invalid keymaps mode: " .. tostring(local_opts.mode), vim.log.levels.ERROR)
      return
    end
    if not allowed_scopes[local_opts.scope] then
      vim.notify("Invalid keymaps scope: " .. tostring(local_opts.scope), vim.log.levels.ERROR)
      return
    end

    local items = build_items(local_opts.mode, local_opts.scope)

    local preview = function(buf_id, item)
      local path, lnum = get_callback_pos(item.maparg)
      if path ~= nil then
        item.path, item.lnum = path, lnum
        return MiniPick.default_preview(buf_id, item)
      end
      local lines = vim.split(vim.inspect(item.maparg), "\n")
      vim.api.nvim_buf_set_lines(buf_id, 0, -1, false, lines)
    end

    local choose = function(item)
      local path, lnum = get_callback_pos(item.maparg)
      if not path or not lnum then
        vim.notify("No callback source for this keymap", vim.log.levels.WARN)
        return
      end
      local target_win = MiniPick.get_picker_state().windows.target
      if target_win and vim.api.nvim_win_is_valid(target_win) then vim.api.nvim_set_current_win(target_win) end
      vim.cmd("edit " .. vim.fn.fnameescape(path))
      local win = target_win and vim.api.nvim_win_is_valid(target_win) and target_win or 0
      vim.api.nvim_win_set_cursor(win, { lnum, 0 })
      vim.cmd("normal! zz")
    end

    local default_source = {
      name = string.format("Keymaps (%s)", local_opts.scope),
      items = items,
      preview = preview,
      choose = choose,
    }

    opts = vim.tbl_deep_extend("force", { source = default_source }, opts or {})
    return MiniPick.start(opts)
  end
end

return M

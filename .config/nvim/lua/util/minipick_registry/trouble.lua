local M = {}

local H = {}

H.is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
H.is_valid_buf = function(buf_id)
  return type(buf_id) == "number" and vim.api.nvim_buf_is_valid(buf_id)
end
H.is_valid_win = function(win_id)
  return type(win_id) == "number" and vim.api.nvim_win_is_valid(win_id)
end
H.islist = vim.fn.has("nvim-0.10") == 1 and vim.islist or vim.tbl_islist

H.item_to_string = function(item)
  if type(item) == "string" then return item end
  if type(item) == "table" and type(item.text) == "string" then return item.text end
  return vim.inspect(item, { newline = " ", indent = "" })
end

H.parse_uri = function(x)
  local ok, path = pcall(vim.uri_to_fname, x)
  if not ok then return nil end
  if H.is_windows and x:find("^%a:") ~= nil and path:find("^%a:") ~= nil then return nil end
  return path
end

H.get_fs_type = function(path)
  if path == "" then return "none" end
  if vim.fn.filereadable(path) == 1 then return "file" end
  if vim.fn.isdirectory(path) == 1 then return "directory" end
  if H.parse_uri(path) ~= nil then return "uri" end
  return "none"
end

H.parse_path = function(x, cwd)
  if type(x) ~= "string" or x == "" then return nil end
  local location_pattern = "()%z(%d+)%z?(%d*)%z?(.*)$"
  local from, lnum, col, rest = x:match(location_pattern)
  local path = x:sub(1, (from or 0) - 1)
  path = path:sub(1, 1) == "~" and ((vim.loop.os_homedir() or "~") .. path:sub(2)) or path

  local path_type = H.get_fs_type(path)
  if path_type == "none" and path ~= "" then
    local base = cwd or vim.fn.getcwd()
    path = string.format("%s/%s", base, path)
    path_type = H.get_fs_type(path)
  end

  return path_type, path, tonumber(lnum), tonumber(col), rest or ""
end

H.parse_item_table = function(item)
  local buf_id = item.bufnr or item.buf_id or item.buf
  if H.is_valid_buf(buf_id) then
    return {
      type = "buffer",
      buf_id = buf_id,
      path = item.path or vim.api.nvim_buf_get_name(buf_id),
      lnum = item.lnum,
      end_lnum = item.end_lnum,
      col = item.col,
      end_col = item.end_col,
      text = item.text,
    }
  end

  if type(item.path) == "string" then
    local path_type = H.get_fs_type(item.path)
    if path_type == "file" or path_type == "uri" then
      return {
        type = path_type,
        path = item.path,
        lnum = item.lnum,
        end_lnum = item.end_lnum,
        col = item.col,
        end_col = item.end_col,
        text = item.text,
      }
    end

    if path_type == "directory" then return { type = "directory", path = item.path } end
  end

  return {}
end

H.parse_item = function(item, cwd)
  if type(item) == "table" then return H.parse_item_table(item) end

  local stritem = H.item_to_string(item)
  local ok, numitem = pcall(tonumber, stritem)
  if ok and H.is_valid_buf(numitem) then return { type = "buffer", buf_id = numitem } end

  local path_type, path, lnum, col, rest = H.parse_path(stritem, cwd)
  if path_type ~= "none" then return { type = path_type, path = path, lnum = lnum, col = col, text = rest } end

  return {}
end

local function build_minipick_title(MiniPick, is_active)
  local title = "<No picker>"
  if is_active then
    local source_name = MiniPick.get_picker_opts().source.name
    local prompt = table.concat(MiniPick.get_picker_query())
    title = source_name .. (prompt == "" and "" or (" : " .. prompt))
  end
  return title
end

---@return snacks.picker.Item[], boolean
local function build_trouble_items(items, cwd)
  local Item = require("trouble.item")
  local trouble_items = {}
  local has_location = false

  for _, item in ipairs(items) do
    local item_data = H.parse_item(item, cwd)
    if item_data.type == "file" or item_data.type == "buffer" or item_data.type == "uri" then
      local filename = H.parse_uri(item_data.path) or item_data.path
      local lnum = item_data.lnum
      local col = item_data.col
      local end_lnum = item_data.end_lnum
      local end_col = item_data.end_col
      local text = item_data.text

      local has_item_location = (lnum ~= nil or col ~= nil or (text ~= nil and text ~= ""))
      has_location = has_location or has_item_location

      if lnum ~= nil then lnum = math.max(lnum, 1) end
      if col ~= nil then col = math.max(col, 1) end
      if end_lnum ~= nil then end_lnum = math.max(end_lnum, 1) end
      if end_col ~= nil then end_col = math.max(end_col, 1) end
      if (lnum ~= nil or end_lnum ~= nil) and not H.is_valid_buf(item_data.buf_id) and filename ~= "" then
        local buf = vim.fn.bufadd(filename)
        if buf > 0 then
          vim.fn.bufload(buf)
          item_data.buf_id = buf
        end
      end
      if H.is_valid_buf(item_data.buf_id) then
        local line_count = vim.api.nvim_buf_line_count(item_data.buf_id)
        if lnum ~= nil then lnum = math.min(lnum, line_count) end
        if end_lnum ~= nil then end_lnum = math.min(end_lnum, line_count) end
      end

      local pos = lnum and { lnum, (col or 1) - 1 } or nil
      local end_pos = (end_lnum or end_col) and { end_lnum or lnum or 1, (end_col or col or 1) - 1 } or nil

      if not has_item_location then
        text = vim.fn.fnamemodify(filename, ":t")
        pos, end_pos = nil, nil
      elseif text then
        text = text:gsub("%z", "│")
      end

      trouble_items[#trouble_items + 1] = Item.new({
        source = "minipick",
        buf = item_data.buf_id,
        filename = filename,
        pos = pos,
        end_pos = end_pos,
        text = text,
        item = { original = item },
      })
    end
  end

  return trouble_items, has_location
end

local function ensure_trouble_source()
  if H._trouble_source_registered then return end
  local sources = require("trouble.sources")
  sources.register("minipick", {
    items = {},
    config = {
      modes = {
        minipick = {
          desc = "MiniPick results previously opened with trouble_choose_marked.",
          source = "minipick",
          groups = {
            { "cmd", format = "{hl:Title}MiniPick{hl} {count}" },
            { "filename", format = "{file_icon} {filename} {count}" },
          },
          sort = { "filename", "pos" },
          format = "{text:ts} {pos}",
        },
        minipick_files = {
          desc = "MiniPick file results previously opened with trouble_choose_marked.",
          source = "minipick",
          groups = {
            { "cmd", format = "{hl:Title}MiniPick{hl} {count}" },
          },
          sort = { "filename", "pos" },
          format = "{file_icon} {text}",
        },
      },
    },
    get = function(cb)
      cb(sources.sources.minipick.items or {})
    end,
  })
  H._trouble_source_registered = true
end

local function get_picker_cwd(minipick)
  local ok, opts = pcall(minipick.get_picker_opts)
  if ok and opts and opts.source and opts.source.cwd then return opts.source.cwd end
  return vim.fn.getcwd()
end

M.trouble_choose_marked = function(items, opts)
  local MiniPick = _G.MiniPick or require("mini.pick")
  if not H.islist(items) then error("`items` should be an array") end
  if #items == 0 then return end
  opts = vim.tbl_deep_extend("force", { list_type = "quickfix" }, opts or {})

  local list = {}
  local cwd = get_picker_cwd(MiniPick)
  local trouble_items, has_location = build_trouble_items(items, cwd)
  for _, item in ipairs(items) do
    local item_data = H.parse_item(item, cwd)
    if item_data.type == "file" or item_data.type == "buffer" or item_data.type == "uri" then
      local entry = { bufnr = item_data.buf_id, filename = H.parse_uri(item_data.path) or item_data.path }
      entry.lnum, entry.col = item_data.lnum or 1, item_data.col or 1
      if item_data.text and item_data.text ~= "" then entry.text = item_data.text:gsub("%z", "│") end
      entry.end_lnum, entry.end_col = item_data.end_lnum, item_data.end_col
      table.insert(list, entry)
    end
  end

  local is_active = MiniPick.is_picker_active()
  if #trouble_items > 0 then
    ensure_trouble_source()
    for _, titem in ipairs(trouble_items) do
      titem.item.cmd = "MiniPick"
    end
    local sources = require("trouble.sources")
    sources.sources.minipick.items = trouble_items
    vim.schedule(function()
      require("trouble").open({ mode = has_location and "minipick" or "minipick_files" })
    end)
    return
  end
  if #list == 0 then
    if not is_active then return end
    local choose = MiniPick.get_picker_opts().source.choose
    return choose(items[1])
  end

  local title = build_minipick_title(MiniPick, is_active)
  local list_data = { items = list, title = title, nr = "$" }

  local ok_trouble, trouble = pcall(require, "trouble")
  if opts.list_type == "location" then
    local win_target = MiniPick.get_picker_state().windows.target
    if not H.is_valid_win(win_target) then win_target = vim.api.nvim_get_current_win() end
    vim.fn.setloclist(win_target, {}, " ", list_data)
    if ok_trouble then
      vim.schedule(function()
        trouble.open({ mode = "loclist" })
      end)
    else
      vim.schedule(function()
        vim.cmd("lopen")
      end)
    end
  else
    vim.fn.setqflist({}, " ", list_data)
    if ok_trouble then
      vim.schedule(function()
        trouble.open({ mode = "quickfix" })
      end)
    else
      vim.schedule(function()
        vim.cmd("copen")
      end)
    end
  end
end

return M

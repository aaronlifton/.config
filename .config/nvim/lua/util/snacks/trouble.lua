---@class util.snacks.trouble
local M = {}

local function is_absolute(path)
  return path:match("^/") ~= nil or path:match("^%a:[/\\]") ~= nil or path:match("^%a[%w+.-]*://") ~= nil
end

---@param item snacks.picker.Item
---@return string?
function M.filename(item)
  if not item.file then return end

  local filename = item.file
  if item.cwd and not is_absolute(filename) then filename = item.cwd .. "/" .. filename end

  if not filename then return end

  return vim.fs.normalize(filename)
end

---@param item snacks.picker.Item
---@return trouble.Item
function M.item(item)
  local Item = require("trouble.item")

  return Item.new({
    source = "snacks",
    buf = item.buf,
    filename = M.filename(item),
    pos = item.pos,
    end_pos = item.end_pos,
    text = item.line or item.comment or item.label or item.name or item.detail or false,
    item = item,
  })
end

---@param items trouble.Item[]
---@return "snacks"|"snacks_files"
function M.mode(items)
  for _, item in ipairs(items) do
    if item.text then return "snacks" end
  end

  return "snacks_files"
end

---@param picker snacks.Picker
---@param opts? { type?: "all" | "selected" | "smart" }
---@return trouble.Item[]
function M.collect(picker, opts)
  opts = opts or {}

  local selected = picker:selected()
  local item_type = opts.type or "smart"
  local picker_items = {} ---@type snacks.picker.Item[]

  if item_type == "smart" then item_type = #selected == 0 and "all" or "selected" end

  if item_type == "all" then
    vim.list_extend(picker_items, picker:items())
  else
    vim.list_extend(picker_items, selected)
  end

  local trouble_items = {} ---@type trouble.Item[]
  for _, item in ipairs(picker_items) do
    trouble_items[#trouble_items + 1] = M.item(item)
  end

  return trouble_items
end

---@param picker snacks.Picker
---@param opts? { type?: "all" | "selected" | "smart", add?: boolean }
function M.open(picker, opts)
  opts = opts or {}

  local source = require("trouble.sources.snacks")
  if not opts.add then source.items = {} end

  vim.list_extend(source.items, M.collect(picker, opts))
  picker:close()

  vim.schedule(function()
    require("trouble").open({ mode = M.mode(source.items) })
  end)
end

---@param opts? { type?: "all" | "selected" | "smart", add?: boolean }
function M.wrap(opts)
  return function(picker)
    M.open(picker, vim.deepcopy(opts or {}))
  end
end

M.actions = {
  trouble_open = { action = M.wrap({ type = "smart" }), desc = "smart-open-with-trouble" },
  trouble_open_selected = { action = M.wrap({ type = "selected" }), desc = "open-with-trouble" },
  trouble_open_all = { action = M.wrap({ type = "all" }), desc = "open-all-with-trouble" },
  trouble_add = { action = M.wrap({ type = "smart", add = true }), desc = "smart-add-to-trouble" },
  trouble_add_selected = { action = M.wrap({ type = "selected", add = true }), desc = "add-to-trouble" },
  trouble_add_all = { action = M.wrap({ type = "all", add = true }), desc = "add-all-to-trouble" },
}

return M

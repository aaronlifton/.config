local M = {}
local H = {}
local P = require("util.minipick_registry.picker").H

local function get_path_cache()
  if H._path_cache ~= nil then return H._path_cache end
  H._path_cache = {
    ns = vim.api.nvim_create_namespace("minipick-filepaths"),
  }
  return H._path_cache
end

local function is_hidden_path(path)
  if path:sub(1, 1) == "." then return true end
  return path:find("/%.") ~= nil
end

-- Inspired by ~/.local/share/nvim/lazy/snacks.nvim/lua/snacks/picker/format.lua:42
local function highlight_path(buf_id, row, path, col_offset)
  if path == "" then return end

  local base_hl = P.hl_group_or("SnacksPickerFile", "MiniPickNormal")
  local dir_hl = P.hl_group_or("SnacksPickerDir", "MiniPickNormal")
  if is_hidden_path(path) then base_hl = P.hl_group_or("SnacksPickerPathHidden", base_hl) end

  local dir, base = path:match("^(.*)/([^/]+)$")
  local ext_opts = { hl_mode = "combine", priority = 120 }
  if dir and base then
    ext_opts.hl_group = dir_hl
    ext_opts.end_row = row
    ext_opts.end_col = col_offset + #dir + 1
    vim.api.nvim_buf_set_extmark(buf_id, get_path_cache().ns, row, col_offset, ext_opts)

    ext_opts.hl_group = base_hl
    ext_opts.end_row = row
    ext_opts.end_col = col_offset + #dir + 1 + #base
    vim.api.nvim_buf_set_extmark(buf_id, get_path_cache().ns, row, col_offset + #dir + 1, ext_opts)
  else
    ext_opts.hl_group = base_hl
    ext_opts.end_row = row
    ext_opts.end_col = col_offset + #path
    vim.api.nvim_buf_set_extmark(buf_id, get_path_cache().ns, row, col_offset, ext_opts)
  end
end

function M.show(local_opts)
  local path_max_width = local_opts.path_max_width or vim.g.minipick_path_max_width
  local path_truncate_mode = local_opts.path_truncate_mode or vim.g.minipick_path_truncate_mode or "smart"

  return function(buf_id, items, query)
    local display_items = items
    if path_max_width and path_max_width > 0 then
      display_items = vim.tbl_map(function(item)
        return Util.display.truncate_path(item, path_max_width, path_truncate_mode)
      end, items)
    end

    MiniPick.default_show(buf_id, display_items, query, { show_icons = true })

    local cache = get_path_cache()
    vim.api.nvim_buf_clear_namespace(buf_id, cache.ns, 0, -1)
    local lines = vim.api.nvim_buf_get_lines(buf_id, 0, -1, false)
    for i, item in ipairs(display_items) do
      local line = lines[i] or ""
      local prefix_len = #line - #item
      if prefix_len < 0 then prefix_len = 0 end
      highlight_path(buf_id, i - 1, item, prefix_len)
    end
  end
end

return M

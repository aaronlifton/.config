local M = {}

-- Custom MiniPick Buffers sorted by recency and with the ability to wipe out
-- the selected buffer by pressing <C-d> (Ctrl + d)
-- It will also not show the current buffer in the list.
local function create_my_buffers(MiniPick)
  local wipeout_cur = function()
    vim.api.nvim_buf_delete(MiniPick.get_picker_matches().current.bufnr, {})
  end

  -- Custom picker for buffers to sort them by last used
  local buffer_mappings = { wipeout = { char = "<C-d>", func = wipeout_cur } }
  return function()
    local items, cwd = {}, vim.fn.getcwd()
    for _, buf_info in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
      if buf_info.bufnr ~= vim.api.nvim_get_current_buf() then
        local name = vim.fs.relpath(cwd, buf_info.name) or buf_info.name
        table.insert(items, {
          text = name,
          bufnr = buf_info.bufnr,
          _lastused = buf_info.lastused,
        })
      end
    end

    table.sort(items, function(a, b)
      return a._lastused > b._lastused
    end)

    local show = function(buf_id, items_to_show, query)
      MiniPick.default_show(buf_id, items_to_show, query, { show_icons = true })
    end

    local opts = {
      source = { name = "Buffers", items = items, show = show },
      mappings = buffer_mappings,
      hinted = { enable = true, use_autosubmit = true },
    }
    return MiniPick.start(opts)
  end
end

M.setup = function(MiniPick)
  MiniPick.registry.my_buffers = create_my_buffers(MiniPick)
end

return M

local M = {}

local function create_bufferlines_ts(MiniExtra)
  return function(local_opts, opts)
    local show = function(buf_id, items, query, opts)
      if items and #items > 0 then -- one buffer, one ft: Enable highlighting
        local ft = vim.bo[items[1].bufnr].filetype
        vim.bo[buf_id].filetype = ft
      end
      MiniPick.default_show(buf_id, items, query, opts)
    end

    local_opts = vim.tbl_extend("force", { scope = "current" }, local_opts or {})
    opts = vim.tbl_deep_extend("force", { source = { show = show } }, opts or {})

    require("mini.extra").pickers.buf_lines(local_opts, opts)
  end
end

M.setup = function(MiniPick)
  MiniPick.registry.bufferlines_ts = create_bufferlines_ts(MiniPick)
end

return M

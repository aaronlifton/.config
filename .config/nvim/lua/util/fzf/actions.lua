---@class util.fzf.actions
local M = {}

local T = require("trouble.sources.fzf")

-- Append the current fzf buffer to the trouble list.
-- Fixes bug where __INFO is nil.
---@param selected string[]
---@param fzf_opts fzf.Opts
---@param opts? trouble.Mode|string
function M.trouble_add(selected, fzf_opts, opts)
  local cmd
  if fzf_opts.__INFO then
    cmd = fzf_opts.__INFO.cmd
  else
    cmd = fzf_opts.__call_opts.search
  end
  -- local cmd = fzf_opts.__INFO.cmd
  local path = require("fzf-lua.path")
  for _, line in ipairs(selected) do
    local item = T.item(path.entry_to_file(line, fzf_opts))
    item.item.cmd = cmd
    table.insert(T.items, item)
  end

  vim.schedule(function()
    opts = opts or {}
    if type(opts) == "string" then opts = { mode = opts } end
    opts = vim.tbl_extend("force", { mode = T.mode() }, opts)
    require("trouble").open(opts)
  end)
end

-- From trouble.nvim/lua/trouble/sources/fzf.lua
local smart_prefix = require("trouble.util").is_win() and "transform(IF %FZF_SELECT_COUNT% LEQ 0 (echo select-all))"
  or "transform([ $FZF_SELECT_COUNT -eq 0 ] && echo select-all)"

return {
  -- Add selected or all items to the trouble list.
  add_selected = { fn = M.trouble_add, prefix = smart_prefix, desc = "smart-add-to-trouble" },
}

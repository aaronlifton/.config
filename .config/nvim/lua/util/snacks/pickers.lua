---@class util.snacks.pickers
---@field pull_requests fun(opts?: snacks.picker.Config): snacks.picker.Config
local M = {}

setmetatable(M, {
  __index = function(t, k)
    ---@diagnostic disable-next-line: no-unknown
    t[k] = require("util.snacks.pickers." .. k)
    return rawget(t, k)
  end,
})

---@param picker snacks.Picker
---@param cmd_name? string
function M.run_picker_system(picker, cmd_name)
  local ns = vim.api.nvim_create_namespace("run_picker_system")
  ---@param cmd string[]
  ---@param opts? vim.SystemOpts
  ---@param on_exit? fun(out: vim.SystemCompleted)
  ---@return vim.SystemObj
  return function(cmd, opts, on_exit)
    on_exit = on_exit or function() end
    local timer = assert(vim.uv.new_timer())
    local cmd_text = cmd_name or table.concat(cmd, " ")
    local extmark_id = 999
    timer:start(
      0,
      80,
      vim.schedule_wrap(function()
        local virtual_text = {}
        table.insert(virtual_text, { cmd_text, "SnacksPickerDimmed" })
        table.insert(virtual_text, { " " })
        table.insert(virtual_text, { Snacks.util.spinner() .. " ", "SnacksPickerSpinner" })
        vim.api.nvim_buf_set_extmark(picker.input.win.buf, ns, 0, 0, {
          id = extmark_id,
          virt_text = virtual_text,
          virt_text_pos = "right_align",
        })
      end)
    )
    return vim.system(cmd, opts, function(out)
      timer:stop()
      timer:close()
      vim.schedule(function()
        vim.api.nvim_buf_del_extmark(picker.input.win.buf, ns, extmark_id)
        on_exit(out)
      end)
    end)
  end
end

return M

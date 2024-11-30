local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

local M = {}

--- Shows an input prompt at the cursor position
---@param title string Prompt title
---@param callback function callback to execute on submit
---@param opts nui_popup_options optionts
function M.cursor_input(title, callback, opts)
  opts = opts or {}
  local input = Input(
    vim.tbl_extend("force", {
      relative = "cursor",
      position = {
        row = -2,
        col = 0,
      },
      size = {
        width = 20,
      },
      border = {
        style = "rounded",
        text = {
          top = title and ("[" .. title .. "]") or nil,
          top_align = "center",
        },
      },
      win_options = {
        winhighlight = "Normal:Normal,FloatBorder:Normal",
      },
    }, opts),
    {
      prompt = "> ",
      default_value = "",
      on_close = function() end,
      on_submit = function(value)
        callback(value)
      end,
    }
  )
  -- stylua: ignore start
  input:map("i", "<esc>", function() input:unmount() end)
  -- stylua: enable end

  local instance = {}

  instance.mount = function()
    input:mount()

    input:on(event.BufLeave, function()
      input:unmount()
    end)
  end

  instance.mount()
end

return M

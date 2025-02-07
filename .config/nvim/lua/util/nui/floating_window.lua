local BasePopup = require("util.nui.base_popup")

---@class util.nui.FloatingWindow: NuiPopup
---@field hidden boolean
---@field super NuiPopup
local FloatingWindow = BasePopup:extend("FloatingWindow")

FloatingWindow.instance = nil

local default_opts = {
  size = { width = "50%", height = "50%" },
}

---@param opts base_popup_options
function FloatingWindow:init(opts)
  opts = vim.tbl_deep_extend("keep", opts, default_opts)
  opts = vim.tbl_deep_extend("force", {
    relative = "editor",
    position = "50%",
    on_mount = function(_popup)
      vim.cmd("startinsert!")
    end,
    win_options = {
      -- winhighlight = "Normal:Normal,FloatBorder:Normal",
      -- winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:PmenuSel,Search:None",
      cursorline = true,
    },
    enter = true,
    focusable = true,
    border = {
      style = "rounded",
      text = {
        top = opts.title or nil,
        top_align = "center",
      },
    },
    size = {
      width = opts.size.width,
      height = opts.size.height,
    },
    buf_options = {
      modifiable = true,
      readonly = false,
    },
  }, opts or {})

  self.hidden = false
  FloatingWindow.super.init(self, opts)
end

function FloatingWindow:toggle()
  if self.hidden then
    self:show()
    self.hidden = false
  else
    self:hide()
    self.hidden = true
  end
end

function FloatingWindow:mount()
  if self.hidden == true and FloatingWindow.instance then
    FloatingWindow.instance:show()
    return
  end

  local toggle = function()
    self:toggle()
  end
  self:set_keymap({
    ["<C-h>"] = {
      callback = toggle,
      desc = "Submit prompt",
    },
  })

  FloatingWindow.super.mount(self)
  FloatingWindow.instance = self
end

return FloatingWindow

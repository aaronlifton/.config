local BasePopup = require("util.nui.base_popup")

---@class util.nui.FloatingWindow: NuiPopup
---@field hidden boolean
---@field id string Unique identifier for this window
---@field super NuiPopup
local FloatingWindow = BasePopup:extend("FloatingWindow")

-- Table to store all window instances by their ID
FloatingWindow.instances = {}

-- Counter for generating unique IDs
FloatingWindow.id_counter = 0

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

  FloatingWindow.id_counter = FloatingWindow.id_counter + 1
  self.id = opts.id or ("window_" .. FloatingWindow.id_counter)

  self.hidden = false
  FloatingWindow.super.init(self, opts)
end

function FloatingWindow:toggle()
  if self.hidden then
    self.hidden = false
    self:show()
  else
    self.hidden = true
    self:hide()
  end
end

function FloatingWindow:mount()
  local toggle = function()
    self:toggle()
  end

  if FloatingWindow.instances[self.id] then
    FloatingWindow.instances[self.id]:show()
  else
    self:set_keymap({
      ["<C-h>"] = {
        callback = toggle,
        desc = "Toggle",
      },
    })
    FloatingWindow.super.mount(self)
    FloatingWindow.instances[self.id] = self
  end
end

-- Get a window by its ID
---@param id string The window ID
---@return util.nui.FloatingWindow|nil
function FloatingWindow.get_by_id(id)
  return FloatingWindow.instances[id]
end

-- Get all window instances
---@return table<string, util.nui.FloatingWindow>
function FloatingWindow.get_all()
  return FloatingWindow.instances
end

-- Remove a window from the instances table
function FloatingWindow:unmount()
  FloatingWindow.instances[self.id] = nil
  FloatingWindow.super.unmount(self)
end

return FloatingWindow

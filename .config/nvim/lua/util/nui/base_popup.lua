local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event

---@class base_popup_options: nui_popup_options
---@field title string
---@field on_submit function
---@field on_mount function
---@field on_close function
---
---@class BasePopup: NuiPopup
---@field options base_popup_options
---@field super NuiPopup
---@field extend function
local BasePopup = Popup:extend("BasePopup")

---@param options base_popup_options
function BasePopup:init(options)
  BasePopup.super.init(self, options)
end

function BasePopup:mount()
  BasePopup.super.mount(self)

  self:on(event.BufLeave, function()
    self:unmount()
  end)

  if self.options.on_mount then self.options.on_mount(self) end
end

--- Sets keymap for nui popup
---@param self NuiPopup
---@param mappings {mode: string|table<string>, callback: function, desc: string}
function BasePopup:set_keymap(mappings)
  for lhs, opts in pairs(mappings) do
    opts.mode = opts.mode or "n"

    if type(opts.mode) == "table" then
      for _, mode in ipairs(opts.mode) do
        self:map(mode, lhs, opts.callback, {
          noremap = true,
          silent = true,
          nowait = true,
          desc = opts.desc,
        })
      end
    else
      self:map(opts.mode, lhs, opts.callback, {
        noremap = true,
        silent = true,
        nowait = true,
        desc = opts.desc,
      })
    end
  end
end

return BasePopup

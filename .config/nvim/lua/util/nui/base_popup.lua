local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event

---@class base_popup_options: nui_popup_options
---@field title string
---@field on_submit function
---@field on_mount function
---@field on_close function
---
---@class util.nui.BasePopup: NuiPopup
---@field opts base_popup_options
---@field super NuiPopup
---@field extend function
local BasePopup = Popup:extend("BasePopup")

---@param opts base_popup_options
function BasePopup:init(opts)
  BasePopup.super.init(self, opts)
  self.opts = opts
end

function BasePopup:mount()
  BasePopup.super.mount(self)

  self:on(event.BufLeave, function()
    self:unmount()
  end)

  -- local close = self.close
  local close = function()
    if self.opts.on_close then self.opts.on_close() end
    self:unmount()
  end

  self:set_keymap({
    ["<ESC>"] = {
      callback = close,
      desc = "Close",
    },
    ["<C-c>"] = {
      callback = close,
      desc = "Close",
      mode = { "n", "i" },
    },
    ["Q"] = {
      callback = close,
      desc = "Close",
    },
  })

  if self.opts.on_mount then self.opts.on_mount(self) end
end

-- function BasePopup:close()
--   self.opts.on_close()
--   self:unmount()
-- end

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

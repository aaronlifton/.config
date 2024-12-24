local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event

---@class Box: NuiPopup
local Box = Popup:extend("Box")

function Box:init(options)
  ---@type nui_popup_options
  options = vim.tbl_deep_extend("force", {
    enter = true,
    focusable = true,
    relative = "editor",
    border = {
      style = "rounded",
      text = {
        top = options.title or " Box ",
        top_align = "center",
      },
    },
    position = {
      row = "50%",
      col = "50%",
    },
    size = {
      width = options.width or 40,
      height = options.height or 3,
    },
    buf_options = {
      modifiable = true,
      readonly = false,
    },
  }, options or {})

  Box.super.init(self, options)
  self.options = options
end

function Box:mount()
  Box.super.mount(self)

  -- Unmount when leaving buffer
  self:on(event.BufLeave, function()
    self:unmount()
  end)

  if self.options.on_mount then self.options.on_mount(self) end
end

function Box:on_key(key, callback, opts)
  opts = opts or {}
  self:map("n", key, callback, {
    noremap = true,
    silent = true,
    nowait = true,
    desc = opts.desc,
  })
end

function Box:set_keymap(mappings)
  for key, mapping in pairs(mappings) do
    if type(mapping) == "function" then
      self:on_key(key, mapping)
    else
      self:on_key(key, mapping.callback, {
        desc = mapping.desc,
      })
    end
  end
end

return Box

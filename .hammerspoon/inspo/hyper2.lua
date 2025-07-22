-- Hyper key
---@class hyper: hs.hotkey.modal
---@field pressed fun()
---@field released fun()
---@field enter fun()
---@field exit fun()
local hyper = hs.hotkey.modal.new({}, nil)

hyper.pressed = function()
  hyper:enter()
  hs.timer.doAfter(1, function()
    hyper:exit()
  end)
end

hyper.released = function()
  hyper:exit()
end

hs.hotkey.bind({}, "f19", hyper.pressed, hyper.released)
local hyperKey = K.mod.hyper

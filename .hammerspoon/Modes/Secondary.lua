local SecondaryModes = {}

local logger = hs.logger.new("vim_mode", "info")

-- Initialize ModalMgr
---@type table
local modal_mgr = spoon.ModalMgr

-- Create a variable to track current mode
local current_mode = nil

-- Function for mode entered/exited
local mode_entered = function(mode)
  logger.d("Entered " .. mode.name)
  current_mode = mode.name
  if mode.name ~= "off" then mode.label:show() end
end

local mode_exited = function(mode)
  logger.d("Exited " .. mode.name)
  current_mode = nil
  mode.label:hide()
end

-- Function to create a new mode with ModalMgr
local function new_mode(name)
  modal_mgr:new(name)
  -- Note: modal_list is documented in the ModalMgr spoon code
  ---@diagnostic disable-next-line: undefined-field
  local mode = {
    name = name,
    modal = modal_mgr.modal_list[name],
    label = require("labels").new("Secondary Leader Key", "Bottom Right"),
  }
  -- Define what happens when mode is entered/exited
  mode.modal.entered = function()
    mode_entered(mode)
  end
  mode.modal.exited = function()
    mode_exited(mode)
  end
  return mode
end

local SMode = new_mode("Secondary")

local modes = {
  smode = SMode,
}

local key_stroke_fn = require("utils").key_stroke_fn
local system_key_stroke_fn = require("utils").system_key_stroke_fn

local bind_fn = function(mode, mod, key, fn, can_repeat)
  local pressed_fn = nil
  local released_fn = nil
  local repeat_fn = nil

  if not can_repeat then
    released_fn = fn
  else
    pressed_fn = fn
    repeat_fn = fn
  end
  if mode then mode.modal:bind(mod, key, pressed_fn, released_fn, repeat_fn) end
end

local bind_key = function(mode, source_mod, source_key, target_mod, target_key, can_repeat)
  local fn = key_stroke_fn(target_mod, target_key)
  bind_fn(mode, source_mod, source_key, fn, can_repeat)
end

bind_key(HyperBinding, {}, "k", {}, function()
  logger.i("Switching to Secondary Mode")
  switch_to_mode(SMode)
end, true)

local function switch_to_mode(mode)
  if current_mode then modal_mgr:deactivate({ current_mode }) end
  modal_mgr:activate({ mode.name }, "#FFBD2E", true)
end

bind_key(SMode, {}, "h", {}, function()
  logger.i("SMode-h activated")
end, true)

return SecondaryModes

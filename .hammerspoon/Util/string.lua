-- https://github.com/fuelingtheweb/fuelingzsh/blob/master/dotfiles/.hammerspoon/Modes/Code.lua
---@class hs.util.string
local M = {}
M.__index = M

function M.starts_with(needle, haystack)
  return haystack:sub(1, #needle) == needle
end

function M.contains(needle, haystack)
  return string.find(haystack, needle)
end

function M.trim(s)
  return s:gsub("^%s*(.-)%s*$", "%1")
end

function M.trim_right(s)
  return s:gsub("(.-)%s*$", "%1")
end

function M.selected()
  local function yank_normal()
    if App.is_current(App.bundles.cursor) then
      hs.eventtap.keyStroke({ "cmd", "shift" }, "c")
    else
      hs.eventtap.keyStroke({ "cmd" }, "c")
    end
  end
  return Clipboard.preserve(yank_normal, function(value)
    for k, v in pairs(hs.pasteboard.contentTypes()) do
      if v == "public.file-url" then return nil end
    end

    return value
  end)
end

return M

local Clipboard = {}
Clipboard.__index = Clipboard

function Clipboard.get()
  return hs.pasteboard.getContents()
end

function Clipboard.set(value)
  hs.pasteboard.setContents(value)
end

function Clipboard.clear()
  hs.pasteboard.clearContents()
end

function Clipboard.preserve(callback, cleanupCallback)
  local original = Clipboard.get()
  Clipboard.clear()

  callback()

  local value = Clipboard.get()

  if cleanupCallback then value = cleanupCallback(value) end

  Clipboard.set(original)

  return value
end

return Clipboard

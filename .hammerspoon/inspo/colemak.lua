-- Reload config when any lua file in config directory changes
-- From https://gist.github.com/prenagha/1c28f71cb4d52b3133a4bff1b3849c3e
function reloadConfig(files)
  doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then doReload = true end
  end
  if doReload then hs.reload() end
end
local myWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
hs.alert.show("Config loaded")

-- A global variable for the Hyper Mode
hyper = hs.hotkey.modal.new({}, "F18")

-- Enter Hyper Mode when F19 (Hyper/Capslock) is pressed
function enterHyperMode()
  hyper.triggered = false
  hyper:enter()
  hs.alert.show("Hyper on")
end

-- Leave Hyper Mode when F19 (Hyper/Capslock) is pressed,
-- send ESCAPE if no other keys are pressed.
function exitHyperMode()
  hyper:exit()
  -- if not hyper.triggered then
  --   hs.eventtap.keyStroke({}, 'ESCAPE')
  -- end
  hs.alert.show("Hyper off")
end

-- Bind the Hyper key
f19 = hs.hotkey.bind({}, "F19", enterHyperMode, exitHyperMode)

-- Vim Colemak bindings (hzColemak)
-- Basic Movements {{{2

-- h - move left {{{3
function left()
  hs.eventtap.keyStroke({}, "Left", 0)
end
hyper:bind({}, "h", left, nil, left)
-- }}}3

-- n - move down {{{3
function down()
  hs.eventtap.keyStroke({}, "Down", 0)
end
hyper:bind({}, "n", down, nil, down)
-- }}}3

-- e - move up {{{3
function up()
  hs.eventtap.keyStroke({}, "Up", 0)
end
hyper:bind({}, "e", up, nil, up)
-- }}}3

-- i - move right {{{3
function right()
  hs.eventtap.keyStroke({}, "Right", 0)
end
hyper:bind({}, "i", right, nil, right)
-- }}}3

-- ) - right programming brace {{{3
function rbroundL()
  hs.eventtap.keyStrokes("(")
end
hyper:bind({}, "k", rbroundL, nil, rbroundL)
-- }}}3

-- ) - left programming brace {{{3
function rbroundR()
  hs.eventtap.keyStrokes(")")
end
hyper:bind({}, "v", rbroundR, nil, rbroundR)
-- }}}3

-- o - open new line below cursor {{{3
hyper:bind({}, "o", nil, function()
  local app = hs.application.frontmostApplication()
  if app:name() == "Finder" then
    hs.eventtap.keyStroke({ "cmd" }, "o", 0)
  else
    hs.eventtap.keyStroke({}, "Return", 0)
  end
end)
-- }}}3

-- Extend+AltGr layer
-- Delete {{{3

-- cmd+h - delete character before the cursor {{{3
local function delete()
  hs.eventtap.keyStroke({}, "delete", 0)
end
hyper:bind({ "cmd" }, "h", delete, nil, delete)
-- }}}3

-- cmd+i - delete character after the cursor {{{3
local function fndelete()
  hs.eventtap.keyStroke({}, "Right", 0)
  hs.eventtap.keyStroke({}, "delete", 0)
end
hyper:bind({ "cmd" }, "i", fndelete, nil, fndelete)
-- }}}3

-- ) - right programming brace {{{3
function rbcurlyL()
  hs.eventtap.keyStrokes("{")
end
hyper:bind({ "cmd" }, "k", rbcurlyL, nil, rbcurlyL)
-- }}}3

-- ) - left programming brace {{{3
function rbcurlyR()
  hs.eventtap.keyStrokes("}")
end
hyper:bind({ "cmd" }, "v", rbcurlyR, nil, rbcurlyR)
-- }}}3

-- Extend+Shift

-- ) - right programming brace {{{3
function rbsqrL()
  hs.eventtap.keyStrokes("[")
end
hyper:bind({ "shift" }, "k", rbsqrL, nil, rbsqrL)
-- }}}3

-- ) - left programming brace {{{3
function rbsqrR()
  hs.eventtap.keyStrokes("]")
end
hyper:bind({ "shift" }, "v", rbsqrR, nil, rbsqrR)
-- }}}3

-- Special Movements
-- w - move to next word {{{3
function word()
  hs.eventtap.keyStroke({ "alt" }, "Right", 0)
end
hyper:bind({}, "w", word, nil, word)
-- }}}3

-- b - move to previous word {{{3
function back()
  hs.eventtap.keyStroke({ "alt" }, "Left", 0)
end
hyper:bind({}, "b", back, nil, back)
-- }}}3

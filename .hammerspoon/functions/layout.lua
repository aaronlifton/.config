local M = {}

-- local layouts = {
-- 	edit_obsidian = {
-- 		{ "Safari", nil, laptopScreen, hs.layout.left50, nil, nil },
-- 		{ "Mail", nil, laptopScreen, hs.layout.right48, nil, nil },
-- 		{ "iTunes", "iTunes", laptopScreen, hs.layout.maximized, nil, nil },
-- 		{ "iTunes", "MiniPlayer", laptopScreen, nil, nil, hs.geometry.rect(0, -48, 400, 48) },
-- 	},
-- }
-- M.set_layout = function(layout_name)
-- 	hs.layout.apply(layouts[layout_name])
-- end

local function focus(appName)
  local app = hs.application.get(appName)
  if app then app:activate() end
end

local function move_windows(appName, gridSettings)
  local app = hs.application.get(appName)
  local wins
  if app then wins = app:allWindows() end
  if wins then
    for _, win in ipairs(wins) do
      hs.grid.set(win, gridSettings)
    end
    focus(appName)
  end
end

local function define_layout(name, key, layout)
  hs.hotkey.bind(K.mod.hyper, tostring(key), function()
    hs.alert.show("Layout: " .. name)
    for _, app in ipairs(layout) do
      local appName = app[1]
      local gridSettings = app[2]
      local config = app[3] or {}
      move_windows(appName, gridSettings)
      if config.focus then focus(appName) end
    end
  end)
end

define_layout("Code", 2, {
  { "Google Chrome", "0,0 2x2" },
  { "Kitty", "8,0 4x2", { focus = true } },
})

return M

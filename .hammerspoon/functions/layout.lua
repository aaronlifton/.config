local M = {}

local layouts = {
	edit_obsidian = {
		{ "Safari", nil, laptopScreen, hs.layout.left50, nil, nil },
		{ "Mail", nil, laptopScreen, hs.layout.right50, nil, nil },
		{ "iTunes", "iTunes", laptopScreen, hs.layout.maximized, nil, nil },
		{ "iTunes", "MiniPlayer", laptopScreen, nil, nil, hs.geometry.rect(0, -48, 400, 48) },
	},
}
M.set_layout = function(layout_name)
	hs.layout.apply(layouts[layout_name])
end

return M

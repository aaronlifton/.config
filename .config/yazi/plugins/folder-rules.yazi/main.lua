local function setup()
	ps.sub("cd", function()
		local cwd = cx.active.current.cwd
		if cwd:ends_with("Downloads") then
			ya.emit("sort", { "btime", reverse = true, dir_first = false })
		elseif cwd:ends_with("Code") or cwd.parent.ends_with("Code") then
			ya.emit("sort", { "mtime", reverse = true, dir_first = true })
			-- else
			-- 	ya.emit("sort", { "alphabetical", reverse = false, dir_first = true })
		end
	end)
end

return { setup = setup }

local window = require("hs.window")
local logger = require("functions/logger")
local grid = require("hs.grid")

window.animationDuration = 0
grid.MARGINX = 0
grid.MARGINY = 0
grid.GRIDWIDTH = 2
grid.GRIDHEIGHT = 2

local M = {}

M.restorable_frames = {}

-- Move a window to the given coordinates
-- top/left/width/height as a percent of the screen
-- window (optional) the window to move, defaults to the focused window
function M.push(params)
	local window = params["window"] or hs.window.focusedWindow()
	local windowFrame = window:frame()
	local screen = window:screen()
	local screenFrame = screen:frame()

	local moved = false
	function cas(old, new)
		if old ~= new then
			moved = true
		end
		return new
	end

	windowFrame.x = cas(windowFrame.x, screenFrame.x + (screenFrame.w * (params["left"] or 0)))
	windowFrame.y = cas(windowFrame.y, screenFrame.y + (screenFrame.h * (params["top"] or 0)))
	windowFrame.w = cas(windowFrame.w, screenFrame.w * (params["width"] or 1))
	windowFrame.h = cas(windowFrame.h, screenFrame.h * (params["height"] or 1))

	window:setFrame(windowFrame, { duration = 0 })
	return moved
end

function M.thunk_push(params)
	function thunk()
		M.push(params)
	end
	return thunk
end

function M.grid(cell)
	hs.grid.set(hs.window.focusedWindow(), cell)
	return true
end

function M.thunk_grid(cell)
	function thunk()
		M.grid(cell)
	end
	return thunk
end

-- M.last_maximized_window_id = nil
-- M.last_maximized_original_frame = nil
-- M.is_maximizing = false
-- M.timers = {
-- 	maximized = nil,
-- }
-- function M.toggle_maximize()
-- 	if M.is_maximizing then
-- 		return
-- 	end
--
-- 	M.is_maximizing = true
-- 	local status, error = pcall(function()
-- 		local window = hs.window.focusedWindow()
-- 		-- if not window:isMaximizable() then
-- 		-- 	return
-- 		-- end
-- 		-- if not window:isStandard() then
-- 		-- 	return
-- 		-- end
-- 		-- if not window:isVisible() then
-- 		-- 	return
-- 		-- end
-- 		logger.d("called")
--
-- 		local frame = window:frame()
-- 		local maximizedFrame = nil
-- 		if hs.screen.mainScreen() then
-- 			maximizedFrame = hs.screen.mainScreen():frame()
-- 		else
-- 			return
-- 		end
-- 		local maximized = frame.w == maximizedFrame.w -- and frame.h == maximizedFrame.h
-- 		logger.d(frame, maximizedFrame, maximized)
--
-- 		logger.d("----maximized----:", maximized)
-- 		if maximized then
-- 			if M.timers.maximized and M.last_maximized_window_id then
-- 				logger.d("within window")
-- 				M.timers.maximized:stop()
-- 				M.timers.maximized = nil
--
-- 				logger.d("restoring last maximized window")
-- 				local window = hs.window.get(M.last_maximized_window_id)
-- 				window.setFrameInScreenBounds(M.last_maximized_original_frame)
-- 			else
-- 				logger.d("not within window")
-- 			end
-- 			M.last_maximized_window_id = nil
-- 			M.last_maximized_original_frame = nil
-- 			logger.d("here")
-- 		else
-- 			logger.d("saving last maximized window")
-- 			local window = hs.window.focusedWindow()
-- 			frame = window:frame()
-- 			-- store current frame position
-- 			prevFrameSizes[curWin:id()] = hs.geometry.copy(frame)
-- 			window:maximize()
-- 			M.is_maximizing = false
-- 		end
-- 	end)
-- 	if error then
-- 		logger.d("---error occured---")
-- 		logger.e(error)
-- 		M.is_maximizing = false
-- 		if M.timers.maximized then
-- 			M.timers.maximized:stop()
-- 		end
-- 		M.timers.maximized = nil
-- 		M.last_maximized_window_id = nil
-- 		M.last_maximized_original_frame = nil
-- 	end
-- end
--

M.maximize_window = grid.maximizeWindow

return M

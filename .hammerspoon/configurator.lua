local M = {}

function M.initConfig(C)
  C.screenCount = #hs.screen.allScreens()
end

return M

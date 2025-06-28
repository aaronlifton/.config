local M = {}

---@param c base46.Colors
---@param hi base46.HighlightsTable
M.setup = function(c, hi)
  hi.DevIconDefault = { guifg = c.red }
  hi.DevIconc = { guifg = c.blue }
  hi.DevIconcss = { guifg = c.blue }
  hi.DevIcondeb = { guifg = c.cyan }
  hi.DevIconDockerfile = { guifg = c.cyan }
  hi.DevIconhtml = { guifg = c.baby_pink }
  hi.DevIconjpeg = { guifg = c.dark_purple }
  hi.DevIconjpg = { guifg = c.dark_purple }
  hi.DevIconjs = { guifg = c.sun }
  hi.DevIconkt = { guifg = c.orange }
  hi.DevIconlock = { guifg = c.red }
  hi.DevIconlua = { guifg = c.blue }
  hi.DevIconmp3 = { guifg = c.white }
  hi.DevIconmp4 = { guifg = c.white }
  hi.DevIconout = { guifg = c.white }
  hi.DevIconpng = { guifg = c.dark_purple }
  hi.DevIconpy = { guifg = c.cyan }
  hi.DevIcontoml = { guifg = c.blue }
  hi.DevIconts = { guifg = c.teal }
  hi.DevIconttf = { guifg = c.white }
  hi.DevIconrb = { guifg = c.pink }
  hi.DevIconrpm = { guifg = c.orange }
  hi.DevIconvue = { guifg = c.vibrant_green }
  hi.DevIconwoff = { guifg = c.white }
  hi.DevIconwoff2 = { guifg = c.white }
  hi.DevIconxz = { guifg = c.sun }
  hi.DevIconzip = { guifg = c.sun }
  hi.DevIconZig = { guifg = c.orange }
  hi.DevIconMd = { guifg = c.blue }
  hi.DevIconTSX = { guifg = c.blue }
  hi.DevIconJSX = { guifg = c.blue }
  hi.DevIconSvelte = { guifg = c.red }
  hi.DevIconJava = { guifg = c.orange }
  hi.DevIconDart = { guifg = c.cyan }
end

return M

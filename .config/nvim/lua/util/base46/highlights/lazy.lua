local M = {}

---@param c base46.Colors
---@param hi base46.HighlightsTable
M.setup = function(c, hi)
  hi.LazyNormal = "Normal"
  hi.LazyH1 = { guibg = c.green, guifg = c.black }
  hi.LazyButton = { guibg = c.one_bg, guifg = c.light_grey }
  hi.LazyH2 = { guifg = c.red, gui = "bold", gui = "underline" }
  hi.LazyReasonPlugin = { guifg = c.red }
  hi.LazyValue = { guifg = c.teal }
  hi.LazyDir = { guifg = c.base05 }
  hi.LazyUrl = { guifg = c.base05 }
  hi.LazyCommit = { guifg = c.green }
  hi.LazyNoCond = { guifg = c.red }
  hi.LazySpecial = { guifg = c.blue }
  hi.LazyReasonFt = { guifg = c.purple }
  hi.LazyOperator = { guifg = c.white }
  hi.LazyReasonKeys = { guifg = c.teal }
  hi.LazyTaskOutput = { guifg = c.white }
  hi.LazyCommitIssue = { guifg = c.pink }
  hi.LazyReasonEvent = { guifg = c.yellow }
  hi.LazyReasonStart = { guifg = c.white }
  hi.LazyReasonRuntime = { guifg = c.nord_blue }
  hi.LazyReasonCmd = { guifg = c.sun }
  hi.LazyReasonSource = { guifg = c.cyan }
  hi.LazyReasonImport = { guifg = c.white }
  hi.LazyProgressDone = { guifg = c.green }
end

return M

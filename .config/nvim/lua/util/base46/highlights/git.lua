local M = {}

---@param c base46.Colors
---@param hi base46.HighlightsTable
M.setup = function(c, hi)
  -- https://github.com/neovim/neovim/blob/master/runtime/syntax/gitcommit.vim
  hi.gitcommitOverflow = { guifg = c.base08 }
  hi.gitcommitSummary = { guifg = c.base0B }
  hi.gitcommitComment = { guifg = c.base03 }
  hi.gitcommitUntracked = { guifg = c.base03 }
  hi.gitcommitDiscarded = { guifg = c.base03 }
  hi.gitcommitSelected = { guifg = c.base03 }
  hi.gitcommitHeader = { guifg = c.base0E }
  hi.gitcommitSelectedType = { guifg = c.base0D }
  hi.gitcommitUnmergedType = { guifg = c.base0D }
  hi.gitcommitDiscardedType = { guifg = c.base0D }
  hi.gitcommitBranch = { guifg = c.base09, gui = "bold" }
  hi.gitcommitUntrackedFile = { guifg = c.base0A }
  hi.gitcommitUnmergedFile = { guifg = c.base08, gui = "bold" }
  hi.gitcommitDiscardedFile = { guifg = c.base08, gui = "bold" }
  hi.gitcommitSelectedFile = { guifg = c.base0B, gui = "bold" }

  -- GitSigns
  hi.GitSignsAdd = { guifg = c.vibrant_green }
  hi.GitSignsChange = { guifg = c.blue }
  hi.GitSignsDelete = { guifg = c.red }
end

return M

local M = {}

---@param c base46.Colors
---@param hi base46.HighlightsTable
M.setup = function(c, hi)
  hi.NvimTreeFolderIcon = { guifg = c.folder_bg }
  hi.NvimTreeFolderName = { guifg = c.folder_bg }
  hi.NvimTreeOpenedFolderName = { guifg = c.folder_bg }
  hi.NvimTreeEmptyFolderName = { guifg = c.folder_bg }

  hi.NvimTreeFolderArrowOpen = { guifg = c.folder_bg }
  hi.NvimTreeFolderArrowClosed = { guifg = c.grey_fg }

  hi.NvimTreeIndentMarker = { guifg = c.grey_fg }

  hi.NvimTreeNormal = { guibg = c.darker_black }
  hi.NvimTreeNormalNC = { guibg = c.darker_black }
  hi.NvimTreeEndOfBuffer = { guifg = c.darker_black }
  hi.NvimTreeCursorLine = { guibg = c.black2 }

  hi.NvimTreeWinSeparator = { guifg = c.darker_black, guibg = c.darker_black }
  hi.NvimTreeWindowPicker = { guifg = c.red, guibg = c.black2 }

  hi.NvimTreeGitNew = { guifg = c.yellow }
  hi.NvimTreeGitDeleted = { guifg = c.red }
  hi.NvimTreeGitIgnored = { guifg = c.light_grey }
  hi.NvimTreeGitDirty = { guifg = c.red }
  hi.NvimTreeSpecialFile = { guifg = c.yellow, gui = "bold" }
  hi.NvimTreeRootFolder = { guifg = c.red, gui = "bold" }
end

return M

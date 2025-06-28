local M = {}

---@param c base46.Colors
---@param hi base46.HighlightsTable
M.setup = function(c, hi)
  hi.CmpItemAbbr = { guifg = c.white }
  hi.CmpItemAbbrMatch = { guifg = c.blue, gui = "bold" }
  hi.CmpItemMenu = { guifg = c.light_grey, gui = "italic" }

  hi.CmpItemKindConstant = { guifg = c.base09 }
  hi.CmpItemKindFunction = { guifg = c.base0D }
  hi.CmpItemKindIdentifier = { guifg = c.base08 }
  hi.CmpItemKindField = { guifg = c.base08 }
  hi.CmpItemKindVariable = { guifg = c.base0E }
  hi.CmpItemKindSnippet = { guifg = c.red }
  hi.CmpItemKindText = { guifg = c.base0B }
  hi.CmpItemKindStructure = { guifg = c.base0E }
  hi.CmpItemKindType = { guifg = c.base0A }
  hi.CmpItemKindKeyword = { guifg = c.base07 }
  hi.CmpItemKindMethod = { guifg = c.base0D }
  hi.CmpItemKindConstructor = { guifg = c.blue }
  hi.CmpItemKindFolder = { guifg = c.base07 }
  hi.CmpItemKindModule = { guifg = c.base0A }
  hi.CmpItemKindProperty = { guifg = c.base08 }
  hi.CmpItemKindEnum = { guifg = c.blue }
  hi.CmpItemKindUnit = { guifg = c.base0E }
  hi.CmpItemKindClass = { guifg = c.teal }
  hi.CmpItemKindFile = { guifg = c.base07 }
  hi.CmpItemKindInterface = { guifg = c.green }
  hi.CmpItemKindColor = { guifg = c.white }
  hi.CmpItemKindReference = { guifg = c.base05 }
  hi.CmpItemKindEnumMember = { guifg = c.purple }
  hi.CmpItemKindStruct = { guifg = c.base0E }
  hi.CmpItemKindValue = { guifg = c.cyan }
  hi.CmpItemKindEvent = { guifg = c.yellow }
  hi.CmpItemKindOperator = { guifg = c.base05 }
  hi.CmpItemKindTypeParameter = { guifg = c.base08 }
  hi.CmpItemKindCopilot = { guifg = c.green }
  hi.CmpItemKindCodeium = { guifg = c.vibrant_green }
  hi.CmpItemKindTabNine = { guifg = c.baby_pink }
end

return M

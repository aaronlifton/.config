local M = {}

---@param c base46.Colors
---@param hi base46.HighlightsTable
M.setup = function(c, hi)
  hi.Comment = { guifg = c.grey_fg }

  hi.Constant = { guifg = c.base09 }
  hi.String = { guifg = c.base0B }
  hi.Character = { guifg = c.base08 }
  hi.Number = { guifg = c.base09 }
  hi.Boolean = { guifg = c.base09 }
  hi.Float = { guifg = c.base09 }

  hi.Identifier = { guifg = c.base08, guisp = "none" }
  hi.Function = { guifg = c.base0D }

  hi.Statement = { guifg = c.base08 }
  hi.Conditional = { guifg = c.base0E }
  hi.Repeat = { guifg = c.base0A }
  hi.Label = { guifg = c.base0A }
  hi.Operator = { guifg = c.base05, guisp = "none" }
  hi.Keyword = { guifg = c.base0E }
  hi.Exception = { guifg = c.base08 }

  hi.PreProc = { guifg = c.base0A }
  hi.Include = { guifg = c.base0D }
  hi.Define = { guifg = c.base0E, guisp = "none" }
  hi.Macro = { guifg = c.base08 }

  hi.Type = { guifg = c.base0A, guisp = "none" }
  hi.StorageClass = { guifg = c.base0A }
  hi.Structure = { guifg = c.base0E }
  hi.Typedef = { guifg = c.base0A }

  hi.Special = { guifg = c.base0C }
  hi.SpecialChar = { guifg = c.base0F }
  hi.Tag = { guifg = c.base0A }
  hi.Debug = { guifg = c.base08 }
  hi.Delimiter = { guifg = c.base0F }
  hi.Error = { guifg = c.base00, guibg = c.base08 }
  hi.Todo = { guifg = c.base0A, guibg = c.base01 }
end

return M

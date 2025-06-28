local M = {}

---@param c base46.Colors
---@param hi base46.HighlightsTable
M.setup = function(c, hi)
   hi.Normal = { guifg = c.base05, guibg = c.base00 }
   hi.Underlined = { gui = "underline" }
   hi.TooLong = { guifg = c.base08 }
   hi.Bold = { gui = "bold" }
   hi.Italic = { gui = "italic" }
   hi.Comment = { gui = "italic" }

   -- Spell
   hi.SpellBad = { gui = "undercurl", guisp = c.base08 }
   hi.SpellCap = { gui = "undercurl", guisp = c.base0D }
   hi.SpellLocal = { gui = "undercurl", guisp = c.base0C }
   hi.SpellRare = { gui = "undercurl", guisp = c.base0E }

   hi.NonText = { guifg = c.grey_fg }

   hi.Search = { guifg = c.base01, guibg = c.base0A }
   hi.IncSearch = { guifg = c.base01, guibg = c.base09 }
   hi.Substitute = { guifg = c.base01, guibg = c.base0A, guisp = "none" }

   -- Diffs
   hi.DiffAdd = { guifg = c.blue }
   hi.DiffChange = { guifg = c.light_grey }
   hi.DiffDelete = { guifg = c.red }
   hi.DiffText = { guifg = c.white, guibg = c.black2 }

   hi.SignColumn = { guifg = c.base03, guisp = "NONE" }

   hi.ModeMsg = { guifg = c.base0B }
   hi.MoreMsg = { guifg = c.base0B }
   hi.WarningMsg = { guifg = c.base08 }
   hi.ErrorMsg = { guifg = c.base08, guibg = c.base00 }
   hi.QuickFixLine = { guibg = c.base01, guisp = "none" }

   -- Pop-up menu
   hi.Pmenu = { guibg = c.one_bg }
   hi.PmenuSbar = { guibg = c.one_bg }
   hi.PmenuSel = { guibg = c.pmenu_bg, guifg = c.black }
   hi.PmenuThumb = { guibg = c.grey }

   hi.TabLine = { guifg = c.base03, guibg = c.base01 }
   hi.TabLineFill = { guifg = c.base03, guibg = c.base01 }
   hi.TabLineSel = { guifg = c.base0B, guibg = c.base01, gui = "bold" }

   -- hi.StatusLine = { guifg = c.light_grey, guibg = c.statusline_bg }
   hi.StatusLine = { guifg = c.base06 }
   -- hi.StatusLineNC = { guifg = c.base03, guibg = c.one_bg }
   hi.StatusLineNC = { guifg = c.base03 }
   hi.MiniTablineHidden = { guifg = c.base03, guibg = nil }
   hi.MiniTablineModifiedHidden = { guibg = c.one_bg3 }

   hi.WinBar = { guifg = c.base05, guibg = nil }
   hi.WinBarNC = { guifg = c.base04, guibg = nil }

   hi.WildMenu = { guifg = c.base08, guibg = c.base0A }

   hi.Folded = { guifg = c.base05, guibg = c.black2 }
   hi.FoldColumn = { guifg = c.base0C, guibg = c.base01 }

   -- Floating windows
   hi.FloatBorder = { guifg = c.blue }
   hi.NormalFloat = { guibg = c.darker_black }

   hi.WinSeparator = { guifg = c.line }

   -- From kepano/flexoki-neovim:
   --
   --    The MatchWord groups don't actually exist, but we define them here
   --    to link to them in plugin specific files instead of redefining the
   --    same group multiple times
   --
   hi.MatchTag = { guifg = c.base08, guibg = c.base02 }
   hi.MatchWord = { guibg = c.grey, guifg = c.white }
   hi.MatchParen = "MatchWord"

   hi.Conceal = { guibg = "NONE" }
   hi.Directory = { guifg = c.base0D }

   hi.SpecialKey = { guifg = c.base03 }
   hi.Title = { guifg = c.base0D, guisp = "none" }
   hi.Question = { guifg = c.base0D }

   hi.LineNr = { guifg = c.grey }
   hi.Cursor = { guifg = c.base00, guibg = c.base05 }
   hi.CursorLine = { guibg = c.black2 }
   hi.CursorLineNr = { guifg = c.white }
   hi.CursorColumn = { guibg = c.black2, guisp = "none" }
   hi.ColorColumn = { guibg = c.black2, guisp = "none" }
   hi.Visual = { guibg = c.base02 }
   hi.VisualNOS = { guifg = c.base08 }

   -- Command-line expressions highlighting
   hi.NvimInternalError = { guifg = c.red }
end

return M

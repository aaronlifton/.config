local M = {}

---@param c base46.Colors
---@param hi base46.HighlightsTable
M.setup = function(c, hi)
   -- LSP References
   hi.LspReferenceText = { guifg = c.darker_black, guibg = c.white }
   hi.LspReferenceRead = { guifg = c.darker_black, guibg = c.white }
   hi.LspReferenceWrite = { guifg = c.darker_black, guibg = c.white }

   -- Lsp Diagnostics
   hi.DiagnosticHint = { guifg = c.purple }
   hi.DiagnosticError = { guifg = c.red }
   hi.DiagnosticWarn = { guifg = c.yellow }
   hi.DiagnosticInfo = { guifg = c.green }

   hi.DiagnosticFloatingHint = "DiagnosticHint"
   hi.DiagnosticFloatingError = "DiagnosticError"
   hi.DiagnosticFloatingWarn = "DiagnosticWarn"
   hi.DiagnosticFloatingInfo = "DiagnosticInfo"

   hi.LspSignatureActiveParameter = { guifg = c.black, guibg = c.green }
   hi.LspInlayHint = { guibg = c.black2, guifg = c.light_grey }

   -- LSP Semantic Highlights
   hi["@lsp.type.class"] = "Structure"
   hi["@lsp.type.decorator"] = "Function"
   hi["@lsp.type.enum"] = "Type"
   hi["@lsp.type.enumMember"] = "Constant"
   hi["@lsp.type.function"] = "@function"
   hi["@lsp.type.interface"] = "Structure"
   hi["@lsp.type.macro"] = "@macro"
   hi["@lsp.type.method"] = "@function.method"
   hi["@lsp.type.namespace"] = "@module"
   hi["@lsp.type.parameter"] = "@variable.parameter"
   hi["@lsp.type.property"] = "@property"
   hi["@lsp.type.struct"] = "Structure"
   hi["@lsp.type.type"] = "@type"
   hi["@lsp.type.typeParamater"] = "TypeDef"
   hi["@lsp.type.variable"] = "@variable"
   hi["@event"] = { fg = c.base08 }
   hi["@modifier"] = { fg = c.base08 }
   hi["@regexp"] = { fg = c.base0F }
end

return M

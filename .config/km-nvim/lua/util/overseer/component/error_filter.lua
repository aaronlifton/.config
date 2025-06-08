---@class diagnostic
---@field lnum integer
---@field filename string
---@field text string

return {
  desc = "Error Filter",
  editable = false,
  serializable = true,
  constructor = function()
    return {
      ---@param result {diagnostics: diagnostic[]|nil}
      on_preprocess_result = function(self, task, result)
        if not result.diagnostics then
          return
        end
        ---@param diagnostic diagnostic
        result.diagnostics = vim.tbl_filter(function(diagnostic)
          return diagnostic.message:find("error")
        end, result.diagnostics)
      end,
    }
  end,
}

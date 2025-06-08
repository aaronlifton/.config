return {
  "hrsh7th/nvim-cmp",
  ---@param opts cmp.ConfigSchema
  opts = function(_, opts)
    local cmp = require("cmp")
    opts.preselect = cmp.PreselectMode.None
    opts.formatting.format = function(entry, item)
      local icons = require("util.icons").kinds
      if icons[item.kind] then item.kind = icons[item.kind] end

      return item
    end
    opts.formatting.fields = { "kind", "abbr", "menu" }
    opts.window.completion.col_offset = -2
  end,
}

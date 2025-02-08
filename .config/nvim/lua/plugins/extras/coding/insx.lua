return {
  "hrsh7th/nvim-insx",
  event = "VimEnter",
  config = function(_, opts)
    require("insx.preset.standard").setup()

    local insx = require("insx")
    local endwise = require("insx.recipe.endwise")
    insx.add("<CR>", endwise(endwise.builtin))
    -- insx.add(">", endwise(auto_tag().builtin))
  end,
}

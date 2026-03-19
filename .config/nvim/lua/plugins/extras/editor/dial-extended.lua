return {
  { import = "lazyvim.plugins.extras.editor.dial" },
  {
    "monaqa/dial.nvim",
    opts = function(_, opts)
      local augend = require("dial.augend")
      return vim.tbl_deep_extend("force", opts, {
        dials_by_ft = {
          ruby = "ruby",
        },
        groups = {
          ruby = {
            augend.constant.new({
              elements = { "if", "unless" },
              word = true, -- if false, "sand" is incremented into "sor", "doctor" into "doctand", etc.
              cyclic = true, -- "or" is incremented into "and".
            }),
          },
        },
      })
    end,
  },
}

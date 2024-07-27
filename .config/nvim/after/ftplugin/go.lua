ac("BufRead", {
  pattern = "*.go",
  callback = function()
    local ai = require("mini.ai")
    vim.b.miniai_config = {
      custom_textobjects = {
        P = ai.gen_spec.treesitter({ a = "@parameter.outer", i = "@parameter.inner" }),
      },
    }
  end,
})

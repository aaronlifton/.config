vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*.js",
  callback = function()
    local ai = require("mini.ai")
    vim.b.miniai_config = {
      custom_textobjects = {
        j = ai.gen_spec.treesitter({
          a = { "@jsx.attr" },
          i = { "@jsx.attr" },
        }),
        T = ai.gen_spec.treesitter({
          a = { "@jsx.self_closing_element", "@jsx.element" },
          i = { "@jsx.self_closing_element", "@jsx.element" },
        }),
      },
    }
  end,
})

if LazyVim.has("mini.ai") then
  local ai = require("mini.ai")
  vim.b.miniai_config = {
    custom_textobjects = {
      j = ai.den_spec.treesitter({
        a = { "@jsx.attr" },
        i = { "@jsx.attr" },
      }),
      T = ai.gen_spec.treesitter({
        a = { "@jsx.self_closing_element", "@jsx.element" },
        i = { "@jsx.self_closing_element", "@jsx.element" },
      }),
      I = ai.gen_spec.treesitter({
        a = { "@jest.it" },
        i = { "@jest.it" },
      }),
      D = ai.gen_spec.treesitter({
        a = { "@jest.describe" },
        i = { "@jest.describe" },
      }),
    },
  }
end

if LazyVim.is_loaded("nvim-treesitter") and LazyVim.is_loaded("nvim-treesitter-textobjects") then
  ---@diagnostic disable-next-line: missing-fields
  require("nvim-treesitter.configs").setup({
    textobjects = {
      move = {
        goto_next_start = {
          ["]i"] = "@jest.it",
          ["]D"] = "@jest.describe",
        },
        goto_next_end = {
          ["]I"] = "@jest.it",
        },
        goto_previous_start = {
          ["[i"] = "@jest.it",
          ["[D"] = "@jest.describe",
        },
        goto_previous_end = {
          -- [<C-d>
          ["[a\4"] = "@jest.describe",
          ["[I"] = "@jest.it",
        },
      },
    },
  })
  require("nvim-treesitter.textobjects.move").attach(0, "javascript")
else
  vim.api.nvim_echo({ { "nvim-treesitter not loaded", "Error" } }, true, {})
end

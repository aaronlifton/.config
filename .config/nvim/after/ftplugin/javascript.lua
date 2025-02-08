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
              ["[D"] = "@jest.describe",
              ["[I"] = "@jest.it",
            },
          },
        },
      })
      local bufnr = vim.fn.bufnr()
      require("nvim-treesitter.textobjects.move").attach(bufnr, "ruby")
    else
      vim.api.nvim_echo({ { "nvim-treesitter not loaded", "Error" } }, true, {})
    end
  end,
})

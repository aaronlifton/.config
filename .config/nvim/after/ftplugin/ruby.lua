vim.opt_local.iskeyword:append("_,@-@,?,!")
-- Handle treesitter not indenting properly following a period.
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/3363
vim.cmd("autocmd FileType ruby setlocal indentkeys-=.")

vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*_spec.rb",
  callback = function()
    local ai = require("mini.ai")
    vim.b.miniai_config = {
      custom_textobjects = {
        C = ai.gen_spec.treesitter({
          a = { "@rspec.context" },
          i = { "@rspec.context" },
        }),
        I = ai.gen_spec.treesitter({
          a = { "@rspec.it" },
          i = { "@rspec.it" },
        }),
        E = ai.gen_spec.treesitter({
          a = { "@rspec.expect" },
          i = { "@rspec.expect" },
        }),
        M = ai.gen_spec.treesitter({
          a = { "@rspec.matcher" },
          i = { "@rspec.matcher" },
        }),
        D = ai.gen_spec.treesitter({
          a = { "@rspec.describe" },
          i = { "@rspec.describe" },
        }),
      },
    }
    if LazyVim.is_loaded("nvim-treesitter") then
      require("nvim-treesitter.configs").setup({
        textobjects = {
          move = {
            goto_next_start = {
              ["]r"] = "@rspec.context",
              ["]i"] = "@rspec.it",
              ["]O"] = "@rspec.describe",
              -- ["]]"] = "@structure.outer",
            },
            goto_next_end = {
              ["[I"] = "@rspec.it",
              ["]R"] = "@rspec.context",
              -- ["]["] = "@structure.outer",
            },
            goto_previous_start = {
              ["[r"] = "@rspec.context",
              ["[i"] = "@rspec.it",
              ["[O"] = "@rspec.describe",
              -- ["[["] = "@structure.outer",
            },
            goto_previous_end = {
              ["[R"] = "@rspec.context",
              ["]I"] = "@rspec.it",
              -- ["[]"] = "@structure.outer",
            },
          },
        },
      })
    else
      vim.api.nvim_echo({ { "nvim-treesitter not loaded", "Error" } }, true, {})
    end
  end,
})

vim.opt_local.iskeyword:append("_,@-@,?,!")
-- Handle treesitter not indenting properly following a period.
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/3363
vim.cmd("autocmd FileType ruby setlocal indentkeys-=.")

-- Don't run twice on the same buffer
local buffers = {}

vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*_spec.rb",
  callback = function()
    local buf = vim.api.nvim_get_current_buf()
    if buffers[buf] then return false end

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
    if LazyVim.is_loaded("nvim-treesitter") and LazyVim.is_loaded("nvim-treesitter-textobjects") then
      ---@diagnostic disable-next-line: missing-fields
      require("nvim-treesitter.configs").setup({
        textobjects = {
          move = {
            goto_next_start = {
              ["]c"] = "@rspec.context",
              ["]i"] = "@rspec.it",
              ["]D"] = "@rspec.describe",
            },
            goto_next_end = {
              ["]I"] = "@rspec.it",
              ["]C"] = "@rspec.context",
            },
            goto_previous_start = {
              ["[c"] = "@rspec.context",
              ["[i"] = "@rspec.it",
              ["[D"] = "@rspec.describe",
            },
            goto_previous_end = {
              ["[C"] = "@rspec.context",
              ["[I"] = "@rspec.it",
            },
          },
        },
      })
      local bufnr = vim.fn.bufnr()
      require("nvim-treesitter.textobjects.move").attach(bufnr, "ruby")
    else
      vim.api.nvim_echo({ { "nvim-treesitter not loaded", "Error" } }, true, {})
    end

    buffers[buf] = true
  end,
})

-- vim.notify(vim.inspect(vim.lsp.get_clients()[1].config.init_options))

vim.opt_local.iskeyword:append("_,@-@,?,!")
-- Handle treesitter not indenting properly following a period.
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/3363
vim.cmd("autocmd FileType ruby setlocal indentkeys-=.")

-- RSpec
-- Only configure RSpec settings for spec files
if not vim.fn.expand("%"):match("_spec.rb$") then return end

-- Don't configure twice for the same buffer
if vim.b.ruby_rspec_configured then return end

if LazyVim.has("mini.ai") then
  local ai = require("mini.ai")
  vim.b.miniai_config = {
    custom_textobjects = {
      C = ai.gen_spec.treesitter({
        a = { "@rspec.context" },
        i = { "@rspec.context" },
        desc = "RSpec context",
      }),
      I = ai.gen_spec.treesitter({
        a = { "@rspec.it" },
        i = { "@rspec.it" },
        desc = "RSpec it block",
      }),
      E = ai.gen_spec.treesitter({
        a = { "@rspec.expect" },
        i = { "@rspec.expect" },
        desc = "RSpec expect",
      }),
      M = ai.gen_spec.treesitter({
        a = { "@rspec.matcher" },
        i = { "@rspec.matcher" },
        desc = "RSpec matcher",
      }),
      D = ai.gen_spec.treesitter({
        a = { "@rspec.describe" },
        i = { "@rspec.describe" },
        desc = "RSpec describe block",
      }),
    },
  }

  -- Programmatically generate keymaps from the ai_config
  local ai_keymaps = require("util.ai_keymaps")
  ai_keymaps.generate_buffer_keymaps({
    mode = { "o", "x" }, -- Generate for both operator-pending and visual modes
    prefix = "", -- No prefix needed
    buffer = true, -- Make these buffer-local
  })
end

if LazyVim.is_loaded("nvim-treesitter") and LazyVim.is_loaded("nvim-treesitter-textobjects") then
  ---@diagnostic disable-next-line: missing-fields
  require("nvim-treesitter").setup({
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
  -- require("nvim-treesitter.textobjects.move").attach(0, "ruby")
else
  vim.api.nvim_echo({ { "nvim-treesitter not loaded", "Error" } }, true, {})
end

-- Mark buffer as configured
vim.b.ruby_rspec_configured = true

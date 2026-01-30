return {
  {
    "zbirenbaum/copilot.lua",
    -- event = "InsertEnter",
    enabled = false,
    opts = {
      suggestion = {
        enabled = false,
        auto_trigger = false,
      },
      -- LazyVim defaults:
      -- suggestion = {
      --   enabled = not vim.g.ai_cmp,
      --   auto_trigger = true,
      --   hide_during_completion = vim.g.ai_cmp,
      --   keymap = {
      --     accept = false, -- handled by nvim-cmp / blink.cmp
      --     next = "<M-]>",
      --     prev = "<M-[>",
      --   },
      -- },
      -- panel = { enabled = false },
      -- filetypes = {
      --   markdown = true,
      --   help = true,
      -- },
      -- Seems to eat up a lot of credits
      filetypes = {
        AvantePromptInput = false,
        mchat = false,
      },
      nes = {
        enabled = false,
      },
      -- copilot_model = "grok-code-fast-1",
    },
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      -- Remove duplicate copilot icon
      -- /Users/$USER/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/ai/sidekick.lua:26
      -- /Users/$USER/.local/share/nvim/lazy/LazyVim/lua/lazyvim/plugins/extras/ai/copilot.lua:62
      if opts.sections.lualine_x[2] then opts.sections.lualine_x.remove(2) end
    end,
  },
}

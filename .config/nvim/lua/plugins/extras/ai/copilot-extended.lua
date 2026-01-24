return {
  "zbirenbaum/copilot.lua",
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
    },
    nes = {
      enabled = false,
    },
    -- copilot_model = "grok-code-fast-1",
  },
}

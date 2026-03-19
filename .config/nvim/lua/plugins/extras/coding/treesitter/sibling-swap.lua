return {
  "Wansmer/sibling-swap.nvim",
  dependencies = "nvim-treesitter/nvim-treesitter",
  opts = {
    use_default_keymaps = false,
    highlight_node_at_cursor = true,
  },
  -- stylua: ignore
  keys = {
    -- Sidekick uses <C-.> to toggle, so use <M-.>
    -- { "<C-.>", function() require("sibling-swap").swap_with_right() end, desc = "Move Node Right" },
    -- { "<C-,>", function() require("sibling-swap").swap_with_left() end, desc = "Move Node Left" },
    { "<M-.>", function() require("sibling-swap").swap_with_right() end, desc = "Move Node Right" },
    { "<M-,>", function() require("sibling-swap").swap_with_left() end, desc = "Move Node Left" },
  },
}

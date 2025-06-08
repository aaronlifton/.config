return {
  "lewis6991/gitsigns.nvim",
  optional = true,
  enabled = function()
    return not Util.lazy.has_plugin_extra("editor.mini-diff")
  end,
  opts = {
    yadm = { enable = true },
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
      delay = 5,
      ignore_whitespace = false,
    },
  },
  keys = {
    -- stylua: ignore
    { "<leader>uB", "<cmd>Gitsigns toggle_current_line_blame<CR>", desc = "Toggle Line Blame" },
    { "<leader>ghe", "<cmd>Gitsigns toggle_deleted<CR>", desc = "Deletions Inline" },
  },
}

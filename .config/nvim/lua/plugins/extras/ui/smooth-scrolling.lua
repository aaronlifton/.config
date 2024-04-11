return {
  "declancm/cinnamon.nvim",
  event = "VeryLazy",
  opts = {
    default_keymaps = true,
    extra_keymaps = false,
    extended_keymaps = false,
    default_delay = 2,
  },
  -- init = function()
  --   local map = vim.keymap.set
  --   map({ "n", "x" }, "<ScrollWheelUp>", "<Cmd>lua Scroll('<ScrollWheelUp>')<CR>")
  --   map({ "n", "x" }, "<ScrollWheelDown>", "<Cmd>lua Scroll('<ScrollWheelDown>')<CR>")
  -- end,
}

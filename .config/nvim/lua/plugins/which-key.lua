return {
  "folke/which-key.nvim",
  opts = {
    presets = {
      operators = true,
    },
    ignore_missing = false,
    icons = {
      group = "",
    },
    layout = {
      align = "center",
    },
    defaults = {
      ["<leader>ci"] = { name = "info" },
      ["<leader><tab>"] = { name = "󰓩 tabs" },
      ["<leader>b"] = { name = "󰖯 buffer" },
      ["<leader>c"] = { name = " code" },
      ["<leader>f"] = { name = "󰈔 file/find" },
      ["<leader>g"] = { name = " git" },
      ["<leader>l"] = { name = "󰒲 lazy" },
      ["<leader>q"] = { name = "󰗼 quit/session" },
      ["<leader>s"] = { name = " search" },
      ["<leader>t"] = { name = "󰙨 test" },
      ["<leader>u"] = { name = " ui" },
      ["<leader>w"] = { name = "󱂬 windows" },
      ["<leader>x"] = { name = "󰁨 diagnostics/quickfix" },
    },
  },
}

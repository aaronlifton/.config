return {
  "rafcamlet/nvim-luapad",
  name = "luapad",
  config = function(_, opts)
    require("luapad").setup(opts)
  end,
  keys = {
    { "<leader>Lp", "<cmd>Luapad<cr>", desc = "Luapad" },
    { "<leader>Lr", "<cmd>Luarun<cr>", desc = "Luarun" },
  },
}

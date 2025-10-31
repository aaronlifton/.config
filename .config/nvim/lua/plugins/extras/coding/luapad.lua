return {
  "rafcamlet/nvim-luapad",
  filetype = "lua",
  name = "luapad",
  config = function(_, opts)
    require("luapad").setup(opts)
  end,
  keys = {
    { "<leader>Lp", "<cmd>Luapad<cr>", desc = "Luapad" },
    { "<leader>Lr", "<cmd>Luarun<cr>", desc = "Luarun" },
  },
}

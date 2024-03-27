return {
  {
    "echasnovski/mini.splitjoin",
    version = false,
    opts = {
      -- mappings = {
      --   toggle = "gS",
      --   split = "",
      --   join = "",
      -- },
    },
    config = function(_, opts) require("mini.splitjoin").setup(opts) end,
  },
}

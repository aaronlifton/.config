return {
  {
    "Darazaki/indent-o-matic",
    opts = {},
    event = { "BufReadPre", "BufNewFile" },
    config = function(_, opts)
      require("indent-o-matic").setup(opts)
    end,
  },
}

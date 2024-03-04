local num_registers = 20
return {
  {
    "1riz/telescope-macros.nvim",
    config = function(_, opts)
      require("macros.macros").setup(opts)
      require("telescope").load_extension("macros")
    end,
    opts = {
      num_registers = num_registers,
    },
    init = function()
      require("macros.macros").setup({ num_registers = num_registers })
    end,
  },
}

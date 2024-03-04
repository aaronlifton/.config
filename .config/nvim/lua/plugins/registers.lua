return {
  {
    -- https://github.com/tversteeg/registers.nvim
    "tversteeg/registers.nvim",
    config = function(_, opts)
      require("registers").setup(vim.tbl_extend("force", opts, {}))
    end,
    keys = {
      { '"', false },
      { '<leader>"', mode = { "n", "v" } },
      { "<C-R>", mode = "i" },
    },
    -- {
    --   "tversteeg/registers.nvim",
    --   name = "registers",
    --   keys = {
    --     { '"', mode = { "n", "v" } },
    --     { "<C-R>", mode = "i" },
    --   },
    --   cmd = "Registers",
    -- },
  },
}

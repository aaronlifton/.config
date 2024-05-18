return {
  {
    "echasnovski/mini.splitjoin",
    enabled = false,
    lazy = false,
    -- version = false,
    -- opts = {
    --   mappings = {
    --     toggle = "gS",
    --     split = "",
    --     join = "",
    --   },
    -- },
    config = function(_, opts)
      require("mini.splitjoin").setup()
    end,
  },
}

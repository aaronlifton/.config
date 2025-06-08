return {
  {
    "echasnovski/mini.pairs",
    enabled = false,
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "windwp/nvim-autopairs",
      opts = {
        fast_wrap = {},
        disable_filetype = { "vim" },
      },
      config = function(_, opts)
        require("nvim-autopairs").setup(opts)

        -- setup cmp for autopairs
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end,
    },
  },
}

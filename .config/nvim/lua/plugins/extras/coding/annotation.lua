return {
  { import = "lazyvim.plugins.extras.coding.neogen" },
  {
    "danymat/neogen",
    keys = {
      {
        "<leader>cnt",
        function()
          require("neogen").generate({ type = "type" })
        end,
        desc = "Annotate Type",
      },
      {
        "<leader>cnf",
        function()
          require("neogen").generate({ type = "func" })
        end,
        desc = "Annotate Function",
      },
      {
        "<leader>cN",
        function()
          require("neogen").generate()
        end,
        desc = "Generate Annotations (Neogen)",
      },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        mode = "n",
        {
          "<leader>cn",
          group = "Annotate",
          icon = { icon = LazyVim.config.icons.kinds["TypeParameter"], color = "orange" },
        },
      },
    },
  },
}

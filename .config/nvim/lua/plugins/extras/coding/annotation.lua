local prefix = "<leader>cn"

return {
  { import = "lazyvim.plugins.extras.coding.neogen" },
  {
    "danymat/neogen",
    opts = {
      placeholders_text = {
        ["description"] = "",
      },
      languages = {
        lua = {},
      },
    },
    keys = {
      {
        prefix .. "t",
        function()
          require("neogen").generate({ type = "type" })
        end,
        desc = "Annotate Type",
      },
      {
        prefix .. "f",
        function()
          require("neogen").generate({ type = "func" })
        end,
        desc = "Annotate Function",
      },
      {
        prefix .. "c",
        function()
          require("neogen").generate({ type = "class" })
        end,
        desc = "Annotate Function",
      },
      -- {
      --   "<leader>cN",
      --   function()
      --     require("neogen").generate()
      --   end,
      --   desc = "Generate Annotations (Neogen)",
      -- },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        mode = "n",
        {
          prefix,
          group = "Annotate",
          icon = { icon = LazyVim.config.icons.kinds["TypeParameter"], color = "white" }, -- " "
        },
      },
    },
  },
}

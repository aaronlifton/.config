return {
  { import = "lazyvim.plugins.extras.coding.neogen" },
  {
    "danymat/neogen",
    opts = {
      snippet_engine = "nvim",
    },
    -- stylua: ignore
    -- keys = {
    --   { "<leader>ad", function() require("neogen").generate() end, desc = "Default Annotation" },
    --   { "<leader>aC", function() require("neogen").generate({ type = "class" }) end, desc = "Class" },
    --   { "<leader>af", function() require("neogen").generate({ type = "func" }) end, desc = "Function" },
    --   { "<leader>at", function() require("neogen").generate({ type = "type" }) end, desc = "Type" },
    --   { "<leader>aF", function() require("neogen").generate({ type = "file" }) end, desc = "File" },
    -- },
  },
}

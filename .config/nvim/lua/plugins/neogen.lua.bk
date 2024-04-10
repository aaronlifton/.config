return {
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
    -- Uncomment next line if you want to follow only stable versions
    -- version = "*"
    opts = {
      snippet_engine = "luasnip",
      enabled = true,
      placeholders_text = {
        description = "",
      },
      languages = {
        lua = {
          template = {
            annotation_convention = "ldoc",
          },
        },
        python = {
          template = {
            annotation_convention = "google_docstrings",
          },
        },
        rust = {
          template = {
            annotation_convention = "rustdoc",
          },
        },
        javascript = {
          template = {
            annotation_convention = "jsdoc",
          },
        },
        typescript = {
          template = {
            annotation_convention = "tsdoc",
          },
        },
        typescriptreact = {
          template = {
            annotation_convention = "tsdoc",
          },
        },
      },
    },
    keys = {
      -- {
      --   "<leader>cgf",
      --   function()
      --     require("neogen").generate({ type = "func" })
      --   end,
      -- },
      -- {
      --   "<leader>cgc",
      --   function()
      --     require("neogen").generate({ type = "class" })
      --   end,
      -- },
      -- {
      --   "<leader>cgt",
      --   function()
      --     require("neogen").generate({ type = "type" })
      --   end,
      -- },
      -- { "<leader>ad", function() require("neogen").generate() end, desc = "Default Annotation" },
      -- { "<leader>aC", function() require("neogen").generate({ type = "class" }) end, desc = "Class" },
      -- { "<leader>af", function() require("neogen").generate({ type = "func" }) end, desc = "Function" },
      -- { "<leader>at", function() require("neogen").generate({ type = "type" }) end, desc = "Type" },
      -- { "<leader>aF", function() require("neogen").generate({ type = "file" }) end, desc = "File" },
      {
        "<leader>cgd",
        function()
          require("neogen").generate()
        end,
        desc = "Default Annotation",
      },
      {
        "<leader>cgc",
        function()
          require("neogen").generate({ type = "class" })
        end,
        desc = "Class",
      },
      {
        "<leader>cgf",
        function()
          require("neogen").generate({ type = "func" })
        end,
        desc = "Function",
      },
      {
        "<leader>cgt",
        function()
          require("neogen").generate({ type = "type" })
        end,
        desc = "Type",
      },
      {
        "<leader>cgF",
        function()
          require("neogen").generate({ type = "file" })
        end,
        desc = "File",
      },
    },
  },
}

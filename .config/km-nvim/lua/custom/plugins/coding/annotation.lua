local prefix = "<leader>cn"

return {
  {
    "danymat/neogen",
    dependencies = Util.lazy.has_plugin("mini.snippets") and { "mini.snippets" } or {},
    cmd = "Neogen",
    keys = {
      {
        "<leader>cn",
        function()
          require("neogen").generate()
        end,
        desc = "Generate Annotations (Neogen)",
      },
    },
    opts = function(_, opts)
      if opts.snippet_engine ~= nil then return end

      local map = {
        ["LuaSnip"] = "luasnip",
        ["mini.snippets"] = "mini",
        ["nvim-snippy"] = "snippy",
        ["vim-vsnip"] = "vsnip",
      }

      for plugin, engine in pairs(map) do
        if Util.lazy.has_plugin(plugin) then
          opts.snippet_engine = engine
          return
        end
      end

      if vim.snippet then opts.snippet_engine = "nvim" end
    end,
  },
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
          icon = { icon = Util.lazy.config.icons.kinds["TypeParameter"], color = "white" }, -- " "
        },
      },
    },
  },
}

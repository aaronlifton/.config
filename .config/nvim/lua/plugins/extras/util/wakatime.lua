return {
  {
    "fiqryq/wakastat.nvim",
    dependencies = { "rebelot/heirline.nvim" },
    config = function()
      require("wakastat").setup({
        args = { "--today" }, -- or "--week", "--month"
        -- format = "Coding Time: %s", -- customize text display
        format = ": %s", -- customize text display
        update_interval = 300, -- seconds between updates
      })
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    optional = true,
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, 2, {
        function()
          return require("wakastat").wakatime()
        end,
        cond = function()
          return package.loaded["wakastat"] and require("wakastat").exists()
        end,
      })
    end,
  },
}

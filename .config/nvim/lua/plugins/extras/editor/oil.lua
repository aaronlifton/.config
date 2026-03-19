return {
  "stevearc/oil.nvim",
  dependencies = {
    { "nvim-mini/mini.icons", opts = {} },
  },
  ---@module 'oil'
  ---@type oil.SetupOpts
  opts = {
    delete_to_trash = true,
    float = {
      max_height = 45,
      max_width = 90,
    },
    keymaps = {
      ["q"] = "actions.close",
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>fO", function() require("oil").toggle_float() end, desc = "Toggle Oil" },
  },
}

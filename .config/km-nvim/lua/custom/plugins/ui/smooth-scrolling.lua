local use_latest_cinnamon = true

return {
  {
    import = "lazyvim.plugins.extras.ui.mini-animate",
    enabled = function()
      return vim.g.smooth_scroll_provider == "mini.animate"
    end,
  },
  {
    "declancm/cinnamon.nvim",
    event = "VeryLazy",
    cond = vim.g.smooth_scroll_provider == "cinnamon" and use_latest_cinnamon,
    config = function()
      require("cinnamon").setup({
        -- keymaps = { extra = true },
        options = { delay = 5 },
      })

      local keymaps = {
        ["<C-u>"] = "<C-u>zz",
        ["<C-d>"] = "<C-d>zz",
        ["n"] = "nzzzv",
        ["N"] = "Nzzzv",
      }

      local scroll = require("cinnamon").scroll

      for key, value in pairs(keymaps) do
        vim.keymap.set("n", key, function()
          scroll(value)
        end)
      end
    end,
  },
  {
    "declancm/cinnamon.nvim",
    cond = vim.g.smooth_scroll_provider == "cinnamon" and not use_latest_cinnamon,
    commit = "ad3c258eb8d4f73427c27417625c45df6ce1585e",
    pin = true,
    event = "VeryLazy",
    opts = {
      default_keymaps = true,
      extra_keymaps = false,
      extended_keymaps = false,
      default_delay = 2,
    },
    -- init = function()
    --   local map = vim.keymap.set
    --   map({ "n", "x" }, "<ScrollWheelUp>", "<Cmd>lua Scroll('<ScrollWheelUp>')<CR>")
    --   map({ "n", "x" }, "<ScrollWheelDown>", "<Cmd>lua Scroll('<ScrollWheelDown>')<CR>")
    -- end,
  },
}

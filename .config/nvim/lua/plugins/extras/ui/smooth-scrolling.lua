if vim.g.animation_provider == "mini.animate" then
  return {
    import = "lazyvim.plugins.extras.ui.mini-animate",
  }
end

local use_latest = true
if use_latest then
  return {
    "declancm/cinnamon.nvim",
    event = "VeryLazy",
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
  }
else
  return {
    "declancm/cinnamon.nvim",
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
  }
end

-- if use_latest then
--   return {
--     "declancm/cinnamon.nvim",
--     event = "VeryLazy",
--     opts = {
--       keymaps = {
--         basic = true,
--         extra = false,
--       },
--       options = {
--         delay = 2,
--         -- max_delta = {
--         --   line = 150,
--         --   column = 200,
--         -- },
--       },
--     },
--     -- init = function()
--     --   local map = vim.keymap.set
--     --   map({ "n", "x" }, "<scrollwheelup>", "<cmd>lua scroll('<scrollwheelup>')<cr>")
--     --   map({ "n", "x" }, "<scrollwheeldown>", "<cmd>lua scroll('<scrollwheeldown>')<cr>")
--     -- end,
--     config = function(_, opts)
--       local config = require("cinnamon.config")
--       local scroll = require("cinnamon.scroll").scroll
--       config.setup(opts)
--       -- local keymaps = config.get().keymaps
--
--       -- half-window movements:
--       vim.keymap.set({ "n", "x" }, "<c-u>", function()
--         scroll("<c-u>")
--       end)
--       vim.keymap.set({ "n", "x" }, "<c-d>", function()
--         scroll("<c-d>")
--       end)
--
--       -- page movements:
--       vim.keymap.set({ "n", "x" }, "<c-b>", function()
--         scroll("<c-b>")
--       end)
--       vim.keymap.set({ "n", "x" }, "<c-f>", function()
--         scroll("<c-f>")
--       end)
--       vim.keymap.set({ "n", "x" }, "<pageup>", function()
--         scroll("<pageup>")
--       end)
--       vim.keymap.set({ "n", "x" }, "<pagedown>", function()
--         scroll("<pagedown>")
--       end)
--
--       -- paragraph movements:
--       vim.keymap.set({ "n", "x" }, "{", function()
--         scroll("{")
--       end)
--       vim.keymap.set({ "n", "x" }, "}", function()
--         scroll("}")
--       end)
--
--       -- previous/next search result:
--       -- vim.keymap.set("n", "n", function() m.scroll("n") end)
--       -- vim.keymap.set("n", "n", function() m.scroll("n") end)
--       -- vim.keymap.set("n", "*", function() m.scroll("*") end)
--       -- vim.keymap.set("n", "#", function() m.scroll("#") end)
--       -- vim.keymap.set("n", "g*", function() m.scroll("g*") end)
--       -- vim.keymap.set("n", "g#", function() m.scroll("g#") end)
--       --
--       -- -- previous/next cursor location:
--       -- vim.keymap.set("n", "<c-o>", function() m.scroll("<c-o>") end)
--       -- vim.keymap.set("n", "<c-i>", function() m.scroll("<c-i>") end)
--       --stylua: ignore end
--     end,
--   }
-- else

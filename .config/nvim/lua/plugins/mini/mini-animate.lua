-- disable resize animation
return {
  {
    "echasnovski/mini.animate",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      -- disable sliding edgy windows
      opts.resize = opts.resize or {}
      opts.resize.enable = false
      opts.open = opts.open or {}
      opts.open.enable = false
      opts.close = opts.close or {}
      opts.close.enable = false
      -- echo opts
      -- vim.api.nvim_echo({ { vim.inspect(opts), "Normal" } }, true, {})
    end,
  },
  --   {
  --     "echasnovski/mini.animate",
  --     event = "VeryLazy",
  --     opts = function()
  --       -- don't use animate when scrolling with the mouse
  --       local mouse_scrolled = false
  --       for _, scroll in ipairs({ "Up", "Down" }) do
  --         local key = "<ScrollWheel" .. scroll .. ">"
  --         vim.keymap.set({ "", "i" }, key, function()
  --           mouse_scrolled = true
  --           return key
  --         end, { expr = true })
  --       end
  --
  --       local animate = require("mini.animate")
  --       return {
  --         resize = {
  --           timing = animate.gen_timing.linear({ duration = 100, unit = "total" }),
  --         },
  --         scroll = {
  --           timing = animate.gen_timing.linear({ duration = 150, unit = "total" }),
  --           subscroll = animate.gen_subscroll.equal({
  --             predicate = function(total_scroll)
  --               if mouse_scrolled then
  --                 mouse_scrolled = false
  --                 return false
  --               end
  --               return total_scroll > 1
  --             end,
  --           }),
  --         },
  --       }
  --     end,
  --   },
}

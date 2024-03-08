-- Lazyvim
return {
  -- better yank/paste
  {
    "gbprod/yanky.nvim",
    dependencies = { { "kkharji/sqlite.lua", enabled = not jit.os:find("Windows") } },
    opts = function(_, opts)
      local utils = require("yanky.utils")
      local mapping = require("yanky.telescope.mapping")
      opts.highlight = { timer = 250 }
      opts.ring = { storage = jit.os:find("Windows") and "shada" or "sqlite" }
      opts.picker = {
        telescope = {
          use_default_mappings = false,
          mappings = {
            default = mapping.put("p"),
            i = {
              ["<c-g>"] = mapping.put("p"),
              ["<c-h>"] = mapping.put("P"),
              ["<c-x>"] = mapping.delete(),
              ["<c-r>"] = mapping.set_register(utils.get_default_register()),
            },
            n = {
              p = mapping.put("p"),
              P = mapping.put("P"),
              d = mapping.delete(),
              r = mapping.set_register(utils.get_default_register()),
            },
          },
        },
      }
    end,
    keys = {
        -- stylua: ignore
      { "<leader>sy", function() require("telescope").extensions.yank_history.yank_history({}) end, mode = { "n", "v" }, desc = "Yank History" },
      -- { "<leader>p", function() require("telescope").extensions.yank_history.yank_history({ }) end, desc = "Open Yank History" },
      -- { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank text" },
      -- { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after cursor" },
      -- { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before cursor" },
      -- { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put yanked text after selection" },
      -- { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put yanked text before selection" },
      -- { "[y", "<Plug>(YankyCycleForward)", desc = "Cycle forward through yank history" },
      -- { "]y", "<Plug>(YankyCycleBackward)", desc = "Cycle backward through yank history" },
      -- { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      -- { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      -- { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put indented after cursor (linewise)" },
      -- { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put indented before cursor (linewise)" },
      -- { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and indent right" },
      -- { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and indent left" },
      -- { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put before and indent right" },
      -- { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put before and indent left" },
      -- { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put after applying a filter" },
      -- { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put before applying a filter" },
    },
  },
}

-- return {
--   {
--     name = "yanky",
--     -- opts = {
--     --   ring = {
--     --     history_length = 100,
--     --     storage = "shada",
--     --     storage_path = vim.fn.stdpath("data") .. "/databases/yanky.db", -- Only for sqlite storage
--     --     sync_with_numbered_registers = true,
--     --     cancel_event = "update",
--     --     ignore_registers = { "_" },
--     --     update_register_on_cycle = false,
--     --   },
--     -- },
--     keys = {
--       -- { "<leader>y", false },
--       -- {
--       --   "<leader>y",
--       --   function()
--       --     require("yanky").yank()
--       --   end,
--       -- },
--       -- {
--       --   "<leader>Y",
--       --   function()
--       --     require("yanky").put({ register = true })
--       --   end,
--       -- },
--       -- ? motion = char, line, v, block
--       -- {
--       --   "<leader>gy",
--       --   function()
--       --     require("yanky").yank({ motion = "char" })
--       --   end,
--       -- },
--       -- {
--       --   "<leader>p",
--       --   function()
--       --     require("yanky").put({ after = true })
--       --   end,
--       -- },
--       -- {
--       --   "<leader>P",
--       --   function()
--       --     require("yanky").put({ after = true, register = true })
--       --   end,
--       -- },
--       -- {
--       --   "<leader>gp",
--       --   function()
--       --     require("yanky").put({ after = true, count = vim.v.count })
--       --   end,
--       -- },
--       -- {
--       --   "<leader>gP",
--       --   function()
--       --     require("yanky").put({ after = true, register = true, count = vim.v.count })
--       --   end,
--       -- },
--       -- { "<leader>gy", function() require("yanky").yank({ motion = "v" }) end },
--     },
--   },
-- }

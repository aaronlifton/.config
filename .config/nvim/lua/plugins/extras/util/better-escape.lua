return {
  "max397574/better-escape.nvim",
  -- event = "InsertEnter",
  event = "VeryLazy",
  opts = {
    -- timeout = 300, -- equal to vim.o.timeoutlen
    -- default_mappings = false,
    -- mappings = {
    --   i = { j = { k = "<Esc>", j = "<Esc>" } },
    --   t = {
    --     j = {
    --       k = "<C-\\><C-n>",
    --     },
    --   },
    -- },

    -- To prevent kk from triggering escape in file finders
    mappings = {
      i = {
        --  first_key[s]
        j = {
          --  second_key[s]
          k = "<Esc>",
          j = "<Esc>",
        },
        k = {
          k = false,
        },
        [" "] = {
          ["<tab>"] = function()
            -- Defer execution to avoid side-effects
            vim.defer_fn(function()
              -- set undo point
              vim.o.ul = vim.o.ul
              require("luasnip").expand_or_jump()
            end, 1)
          end,
        },
      },
      c = {
        j = {
          k = "<C-c>",
          j = "<C-c>",
        },
      },
      t = {
        j = {
          k = "<C-\\><C-n>",
        },
      },
      v = {
        j = {
          k = "<Esc>",
        },
      },
      s = {
        j = {
          k = "<Esc>",
        },
      },
    },
  },
}

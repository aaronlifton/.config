-- [";"] = { "n", "x", "o" },
-- [","] = { "n", "x", "o" },

return {
  {
    "jonatan-branting/nvim-better-n",
    enabled = false,
    config = function()
      -- local better_n = require("better-n")
      -- better_n.setup({
      --   -- False by default. If set to true, the keys will work like the
      --   -- native semicolon/comma, i.e., forward/backward is understood in
      --   -- relation to the last motion.
      --   relative_directions = true,
      --   -- By default, all modes are included.
      --   modes = { "n", "x", "o" },
      --   mappings = {
      --     [";"] = { "n", "x", "o" },
      --     [","] = { "n", "x", "o" },
      --     ["F"] = { "n", "x" },
      --     ["f"] = { "n", "x" },
      --     -- ["s"] = { "n", "x"},
      --     -- ["S"] = {}
      --   },
      -- })
      require("better-n").setup({
        callbacks = {
          mapping_executed = function(_mode, _key)
            -- Clear highlighting, indicating that `n` will not goto the next
            -- highlighted search-term
            vim.cmd([[ nohl ]])
          end,
        },
        mappings = {
          ["*"] = { previous = "<s-n>", next = "n" },
          ["#"] = { previous = "<s-n>", next = "n" },
          ["f"] = { previous = ",", next = ";" },
          ["t"] = { previous = ",", next = ";" },
          ["F"] = { previous = ",", next = ";" },
          ["T"] = { previous = ",", next = ";" },

          ["/"] = { previous = "<s-n>", next = "n", cmdline = true },
          ["?"] = { previous = "<s-n>", next = "n", cmdline = true },

          -- -- I want `n` to always go forward, and `<s-n>` to always go backwards
          -- ["#"] = { previous = "n", next = "<s-n>" },
          -- ["F"] = { previous = ";", next = "," },
          --
          -- ["t"] = { previous = ";", next = "," },
          -- ["T"] = { previous = ";", next = "," },
          --
          --
          -- -- Setting `cmdline = true` ensures that `n` will only be
          -- -- overwritten if the search command is succesfully executed
          -- ["?"] = { previous = "n", next = "<s-n>", cmdline = true },
        },
      })
      vim.keymap.set("n", "n", require("better-n").n, { nowait = true })
      vim.keymap.set("n", "<s-n>", require("better-n").shift_n, { nowait = true })
    end,
  },
}

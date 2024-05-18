return {
  "nvim-neotest/neotest",
  dependencies = { "nvim-neotest/nvim-nio" },
  opts = {
    -- Can be a list of adapters like what neotest expects,
    -- or a list of adapter names,
    -- or a table of adapter names, mapped to adapter configs.
    -- The adapter will then be automatically loaded with the config.
    adapters = {},
    -- Example for loading neotest-go with a custom config
    -- adapters = {
    --   ["neotest-go"] = {
    --     args = { "-tags=integration" },
    --   },
    -- },
    -- status = { virtual_text = true },
    -- output = { open_on_run = true },
    consumers = {
      overseer = require("neotest.consumers.overseer"),
    },
    overseer = {
      enabled = true,
      force_default = true,
    },
    quickfix = {
      open = function()
        if LazyVim.has("trouble.nvim") then
          require("trouble").open({ mode = "quickfix", focus = false })
          -- else
          vim.cmd("copen")
        end
      end,
    },
  },
}

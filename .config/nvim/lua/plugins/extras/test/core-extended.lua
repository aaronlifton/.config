return {
  "nvim-neotest/neotest",
  optional = true,
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
    -- consumers = {},
    -- overseer = {
    --   enabled = true,
    --   -- When this is true (the default), it will replace all neotest.run.* commands
    --   force_default = true,
    -- },
    discovery = {
      filter_dir = function(dir)
        return not vim.startswith(dir, "node_modules")
      end,
    },
  },
}

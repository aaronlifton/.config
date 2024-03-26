return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "olimorris/neotest-rspec",
      "marilari88/neotest-vitest",
      "stevearc/overseer.nvim",
    },
    opts = {
      consumers = {
        overseer = require("neotest.consumers.overseer"),
      },
      overseer = {
        enabled = true,
        force_default = true,
      },
    },
    config = function(opts)
      opts.adapters = opts.adapters or {}
      table.insert(opts.adapters, require("neotest-vitest"))
      require("neotest").setup(opts)
    end,
  },
}

--     adapters = {
--       ["neotest-rspec"] = {
--         -- NOTE: By default neotest-rspec uses the system wide rspec gem instead of the one through bundler
--         -- rspec_cmd = function()
--         --   return vim.tbl_flatten({
--         --     "bundle",
--         --     "exec",
--         --     "rspec",
--         --   })
--         -- end,
--       },
--     },
--   },
-- },
-- {
--   "olimorris/neotest-rspec",
--   lazy = false,
--   -- adapters = {
--   --   require("neotest-rspec")({
--   --     rspec_cmd = function()
--   --       return vim.tbl_flatten({
--   --         "docker",
--   --         "compose",
--   --         "exec",
--   --         "-i",
--   --         "-w", "/app",
--   --         "-e", "RAILS_ENV=test",
--   --         "app",
--   --         "bundle",
--   --         "exec",
--   --         "rspec"
--   --       })
--   --     end,
--   --
--   --     transform_spec_path = function(path)
--   --       local prefix = require('neotest-rspec').root(path)
--   --       return string.sub(path, string.len(prefix) + 2, -1)
--   --     end,
--   --
--   --     results_path = "tmp/rspec.output"
--   --   })
--   -- }
-- },

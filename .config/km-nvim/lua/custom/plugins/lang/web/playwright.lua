return {
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "thenbe/neotest-playwright",
    },
    opts = function(_, opts)
      vim.list_extend(opts.adapters, {
        require("neotest-playwright").adapter({
          options = {
            persist_project_selection = true,
            enable_dynamic_test_discovery = true,
            get_playwright_binary = function()
              return "/users/aaron/code/venv/bin/playwright"
            end,
          },
        }),
      })
      opts.consumers = opts.consumers or {}
      vim.list_extend(opts.consumers, {
        -- add to your list of consumers
        playwright = require("neotest-playwright.consumers").consumers,
      })
    end,
  },
  -- {
  --   "thenbe/neotest-playwright",
  --   keys = {
  --     {
  --       "<leader>ta",
  --       function()
  --         require("neotest").playwright.attachment()
  --       end,
  --       desc = "Launch test attachment",
  --     },
  --   },
  -- },
}

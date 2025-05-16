local sql_ft = { "sql", "mysql", "plsql" }
local enable_dadbod = false

return {
  { import = "lazyvim.plugins.extras.lang.sql" },
  -- Disable dadbod
  { "tpope/vim-dadbod", enabled = enable_dadbod },
  { "kristijanhusak/vim-dadbod-completion", enabled = enable_dadbod },
  not enable_dadbod
      and {
        "saghen/blink.cmp",
        optional = true,
        opts = function(_, opts)
          -- Remove 'dadbod' from providers if it exists
          vim.api.nvim_echo({ { vim.inspect(opts.providers) } }, true, {})

          opts.sources.providers.dadbod = nil
          opts.sources.default = vim.tbl_filter(function(provider)
            return provider ~= "dadbod"
          end, opts.sources.default)
        end,
      }
    or {},
  {
    "kristijanhusak/vim-dadbod-ui",
    enabled = enable_dadbod,
    dependencies = {
      {
        "folke/which-key.nvim",
        opts = {
          spec = {
            mode = "n",
            { "<leader>D", group = "database", icon = { icon = "" } },
          },
        },
      },
    },
  },
  --
  {
    "kristijanhusak/vim-dadbod-completion",
    cond = enable_dadbod,
    optional = true,
    dependencies = {
      { "jsborjesson/vim-uppercase-sql", ft = sql_ft },
    },
    keys = {
      { "<leader>Da", "<cmd>DBUIAddConnection<cr>", desc = "Add Connection" },
      { "<leader>Du", "<cmd>DBUIToggle<cr>", desc = "Toggle UI" },
      { "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Find Buffer" },
      { "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename Buffer" },
      { "<leader>Dq", "<cmd>DBUILastQueryInfo<cr>", desc = "Last Query Info" },
    },
  },

  {
    "mason-org/mason.nvim",
    optional = true,
    opts = {
      ensure_installed = { "sqlls" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        sqlls = {},
      },
    },
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "sqlite",
        "postgresql-16",
      },
    },
  },
}

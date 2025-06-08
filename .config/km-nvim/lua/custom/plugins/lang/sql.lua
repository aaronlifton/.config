local sql_ft = { "sql", "mysql", "plsql" }
local enable_dadbod = false

return {
  {
    "tpope/vim-dadbod",
    enabled = enable_dadbod,
    cmd = "DB",
  },

  {
    "kristijanhusak/vim-dadbod-completion",
    enabled = enable_dadbod,
    dependencies = {
      { "vim-dadbod" },

      { "jsborjesson/vim-uppercase-sql", ft = sql_ft },
    },

    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = sql_ft,
        callback = function()
          if LazyVim.has_extra("coding.nvim-cmp") then
            local cmp = require("cmp")

            -- global sources
            ---@param source cmp.SourceConfig
            local sources = vim.tbl_map(function(source)
              return { name = source.name }
            end, cmp.get_config().sources)

            -- add vim-dadbod-completion source
            table.insert(sources, { name = "vim-dadbod-completion" })

            -- update sources for the current buffer
            cmp.setup.buffer({ sources = sources })
          end
        end,
      })
    end,
    keys = {
      { "<leader>Da", "<cmd>DBUIAddConnection<cr>", desc = "Add Connection" },
      { "<leader>Du", "<cmd>DBUIToggle<cr>", desc = "Toggle UI" },
      { "<leader>Df", "<cmd>DBUIFindBuffer<cr>", desc = "Find Buffer" },
      { "<leader>Dr", "<cmd>DBUIRenameBuffer<cr>", desc = "Rename Buffer" },
      { "<leader>Dq", "<cmd>DBUILastQueryInfo<cr>", desc = "Last Query Info" },
    },
  },

  {
    "kristijanhusak/vim-dadbod-ui",
    enabled = enable_dadbod,
    cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
    dependencies = {
      { "vim-dadbod" },
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
    keys = {
      { "<leader>D", "<cmd>DBUIToggle<CR>", desc = "Toggle DBUI" },
    },
    init = function()
      local data_path = vim.fn.stdpath("data")

      vim.g.db_ui_auto_execute_table_helpers = 1
      vim.g.db_ui_save_location = data_path .. "/dadbod_ui"
      vim.g.db_ui_show_database_icon = true
      vim.g.db_ui_tmp_query_location = data_path .. "/dadbod_ui/tmp"
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_use_nvim_notify = true

      -- NOTE: The default behavior of auto-execution of queries on save is disabled
      -- this is useful when you have a big query that you don't want to run every time
      -- you save the file running those queries can crash neovim to run use the
      -- default keymap: <leader>S
      vim.g.db_ui_execute_on_save = false
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = { ensure_installed = { "sql" } },
  },

  -- blink.cmp integration
  {
    "saghen/blink.cmp",
    optional = true,
    opts = {
      sources = {
        default = { "dadbod" },
        providers = {
          dadbod = { name = "Dadbod", module = "vim_dadbod_completion.blink" },
        },
      },
    },
    dependencies = {
      "kristijanhusak/vim-dadbod-completion",
    },
  },
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
  -- Linters & formatters
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "sqlfluff" } },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = function(_, opts)
      for _, ft in ipairs(sql_ft) do
        opts.linters_by_ft[ft] = opts.linters_by_ft[ft] or {}
        table.insert(opts.linters_by_ft[ft], "sqlfluff")
      end
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      opts.formatters.sqlfluff = {
        args = { "format", "--dialect=ansi", "-" },
      }
      for _, ft in ipairs(sql_ft) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "sqlfluff")
      end
    end,
  },
  -- Disable dadbod
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

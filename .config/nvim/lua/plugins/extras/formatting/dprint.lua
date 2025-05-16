local formatters = { "dprint", stop_after_first = true }
DprintNotified = false

return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "dprint" } },
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    ---@class PluginLspOpts
    opts = {
      servers = {
        dprint = {
          enabled = false,
        },
      },
    },
  },
  -- TODO: Check if lsp dprint can format instead of conform
  -- {
  --   "neovim/nvim-lspconfig",
  --   optional = true,
  --   ---@class PluginLspOpts
  --   opts = {
  --     servers = {
  --       dprint = {
  --         filetypes = {
  --           -- "javascript",
  --           -- "typescript",
  --           "typescriptreact",
  --           "javascriptreact",
  --           "astro",
  --           "svelte",
  --           "vue",
  --           -- 'json',
  --           -- 'jsonc',
  --           "markdown",
  --           "toml",
  --         },
  --         on_new_config = function(new_config)
  --           local buf = vim.api.nvim_get_current_buf()
  --           new_config.enabled = require("conform").get_formatter_info("dprint", buf).available
  --         end,
  --       },
  --     },
  --   },
  -- },
  {
    "stevearc/conform.nvim",
    ---@param opts conform.setupOpts
    opts = function(_, opts)
      -- opts.formatters_by_ft = opts.formatters_by_ft or {}
      -- for _, ft in ipairs({ "jsonc", "json" }) do
      --   opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
      --   vim.list_extend(opts.formatters_by_ft[ft], json_formatters)
      -- end
      -- for _, ft in ipairs({ "typescriptreact", "javascriptreact", "astro", "svelte", "vue" }) do
      --   opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
      --   -- vim.list_extend(opts.formatters_by_ft[ft], formatters)
      --   table.insert(opts.formatters_by_ft[ft], "dprint")
      -- end
      require("util.conform").add_formatters(opts, {
        jsonc = formatters,
        json = formatters,
        -- javascript = formatters,
        -- typescript = formatters,
        typescriptreact = formatters,
        javascriptreact = formatters,
        astro = formatters,
        svelte = formatters,
        vue = formatters,
      })
      opts.formatters = opts.formatters or {}
      opts.formatters = vim.tbl_deep_extend("force", opts.formatters, {
        dprint = {
          require_cwd = vim.g.dprint_needs_config,
          prepend_args = function(self, ctx)
            ---@diagnostic disable-next-line: param-type-mismatch
            local has_dprint = self.cwd(self, ctx)
            if not vim.g.dprint_needs_config and not has_dprint then
              if not DprintNotified then
                vim.api.nvim_echo({ { "Using dprint default config" } }, true, {})
                DprintNotified = true
              end
              return { "-c", vim.fn.stdpath("config") .. "/rules/dprint.json" }
            end
            return {}
          end,
        },
        -- Add dprint to the first formatter in the list
        markdown = function(bufnr)
          return { require("util.conform").first(bufnr, "prettier", "dprint"), "markdownlint-cli2", "markdown-toc" }
        end,
        ["markdown.mdx"] = function(bufnr)
          return { require("util.conform").first(bufnr, "prettier", "dprint"), "markdownlint-cli2", "markdown-toc" }
        end,
      })
    end,
  },
}

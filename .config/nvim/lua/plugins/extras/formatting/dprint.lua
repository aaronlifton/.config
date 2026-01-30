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
  {
    "stevearc/conform.nvim",
    ---@param opts conform.setupOpts
    opts = function(_, opts)
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

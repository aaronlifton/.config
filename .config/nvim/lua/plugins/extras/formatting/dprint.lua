-- local lsp_util = require("util.lsp")
local dprint_filenames = { "dprint.json", ".dprint.json", "dprint.jsonc", ".dprint.jsonc" }
local json_formatters = { "prettierd", "prettier", "dprint", "biome", stop_after_first = true }
local formatters = { "dprint", "biome", "prettierd", "prettier", stop_after_first = true }
local use_global_dprint_formatter = false
DprintNotified = false

return {
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "dprint" } },
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        dprint = {
          filetypes = {
            -- "javascript",
            -- "typescript",
            "typescriptreact",
            "javascriptreact",
            "astro",
            "svelte",
            "vue",
            -- 'json',
            -- 'jsonc',
            "markdown",
            -- 'python',
            "toml",
            -- 'rust',
            -- 'roslyn',
          },
          on_new_config = function(new_config)
            local buf = vim.api.nvim_get_current_buf()
            new_config.enabled = require("conform").get_formatter_info("dprint", buf).available
          end,
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        jsonc = json_formatters,
        json = json_formatters,
        -- javascript = formatters,
        -- typescript = formatters,
        typescriptreact = formatters,
        javascriptreact = formatters,
        astro = formatters,
        svelte = formatters,
        vue = formatters,
      },
      formatters = {
        dprint = {
          condition = function(_, ctx)
            return use_global_dprint_formatter
              or vim.fs.find(dprint_filenames, { path = ctx.filename, upward = true })[1]
          end,
          prepend_args = function(_)
            local has_dprint = vim.fs.find(dprint_filenames, { upward = true })[1]
            if use_global_dprint_formatter and not has_dprint then
              if not DprintNotified then
                vim.api.nvim_echo({ { "Using dprint default config" } }, true, {})
                DprintNotified = true
              end
              return { "-c", vim.fn.stdpath("config") .. "/rules/dprint.json" }
            end
          end,
        },
        biome = {
          condition = function(_, ctx)
            return vim.fs.find({ "biome.json" }, { path = ctx.filename, upward = true })[1]
          end,
        },
      },
    },
  },
}

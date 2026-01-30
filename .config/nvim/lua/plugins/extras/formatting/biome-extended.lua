-- NOTE: now using biome lsp. need to `biome init` in a repo to active it.

-- Adapted from lazyvim.extras.formatters.biome to support global prettier
-- config (vim.g.lazyvim_prettier_needs_config = true)

-- https://biomejs.dev/internals/language-support/
local supported = {
  "astro",
  "css",
  "graphql",
  -- "html",
  "javascript",
  "javascriptreact",
  "json",
  "jsonc",
  "svelte",
  "typescript",
  "typescriptreact",
  "vue",
}

return {
  {
    "mason-org/mason.nvim",
    opts = { ensure_installed = { "biome" } },
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    ---@class PluginLspOpts
    opts = {
      servers = {
        biome = {
          enabled = true,
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    ---@param opts ConformOpts
    opts = function(_, opts)
      opts.formatters_by_ft = opts.formatters_by_ft or {}
      for _, ft in ipairs(supported) do
        opts.formatters_by_ft[ft] = opts.formatters_by_ft[ft] or {}
        table.insert(opts.formatters_by_ft[ft], "biome")
      end

      opts.formatters = opts.formatters or {}
      opts.formatters.biome = {
        command = "mise which biome",
        require_cwd = true,
      }
    end,
  },
}

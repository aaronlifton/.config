local lsp_util = require("util.lsp")

return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "dprint" })
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      local util = require("conform.util")
      lsp_util.add_formatters(opts, {
        ["jsonc"] = { "dprint" },
        ["json"] = { "dprint" },
        ["javascript"] = { "dprint" },
        ["typescript"] = { "dprint" },
        ["typescriptreact"] = { "dprint" },
        ["javascriptreact"] = { "dprint" },
        ["astro"] = { "dprint" },
        ["svelte"] = { "dprint" },
        ["vue"] = { "dprint" },
      })

      lsp_util.add_formatter_settings(opts, {
        dprint = {
          prepend_args = { "-c", vim.fn.stdpath("config") .. "/rules/dprint.json" },
          cwd = util.root_file({
            -- https://prettier.io/docs/en/configuration.html
            "dprint.json",
            "dprint.jsonc",
            ".dprint.json",
            ".dprint.jsonc",
            "package.json",
          }),
        },
      })

      -- return opts
    end,
  },
}

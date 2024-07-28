local lsp_util = require("util.lsp")
local dprint_filenames = { "dprint.json", ".dprint.json", "dprint.jsonc", ".dprint.jsonc" }
local notified = false
local use_global_dprint_formatter = true
return {
  {
    "williamboman/mason.nvim",
    opts = { ensure_installed = { "dprint" } },
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      local conform = require("conform")

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
        -- dprint runs biome itself, so always enable it unless it's a
        -- prettier/eslint project (e.g. react native, remix, some nextjs
        -- projects, etc.) if use_global_dprint_formatter is true, prefer to run
        -- biome through dprint, as it's more performant
        dprint = {
          condition = function(_, ctx)
            if use_global_dprint_formatter then
              local has_prettier = conform.get_formatter_info("prettier", ctx.buf).available
              local biome_available = conform.get_formatter_info("biome", ctx.buf).available
              local has_eslint = LazyVim.lsp.get_clients({ name = "eslint", bufnr = buf })[1]
              return not has_prettier and not has_eslint and not biome_available
            else
              local has_dprint = vim.fs.find(dprint_filenames, { upward = true })[1]
              return has_dprint
            end
          end,
          -- If use_global_dprint_formatter is false, prefer to use dprint's default config
          -- prepend_args = { "-c", vim.fn.stdpath("config") .. "/rules/dprint.json" },
          prepend_args = function(ctx)
            -- Use a base dprint config for non-dprint projects, as dprint is the default formatter
            local has_dprint = vim.fs.find(dprint_filenames, { upward = true })[1]
            if not has_dprint then
              if not notified then
                vim.api.nvim_echo({ { "Using dprint default config" } }, true, {})
                notified = true
              end
              return { "-c", vim.fn.stdpath("config") .. "/rules/dprint.json" }
            end
          end,
        },
        biome = {
          condition = function(_, ctx)
            -- dprint will run biome itself, so disable biome if dprint is used
            -- as the defaut global formatter
            if use_global_dprint_formatter then
              return false
            end
            local has_biome = vim.fs.find({ "biome.json" }, { path = ctx.filename, upward = true })[1]
            return has_biome
          end,
        },
      })
    end,
  },
}

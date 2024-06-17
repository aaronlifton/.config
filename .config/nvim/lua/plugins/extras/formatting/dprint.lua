local lsp_util = require("util.lsp")
local dprint_filenames = { "dprint.json", ".dprint.json", "dprint.jsonc", ".dprint.jsonc" }
local notified = false
local use_global_dprint_formatter = true
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

      local prettier_settings = {
        condition = function(_, ctx)
          local dprint_available = conform.get_formatter_info("dprint", ctx.buf).available
          local biome_available = conform.get_formatter_info("biome", ctx.buf).available
          return not biome_available and not dprint_available
        end,
      }
      lsp_util.add_formatter_settings(opts, {
        -- dprint runs biome itself, so always enable it unless it's a
        -- prettier/eslint project (e.g. React Native, Remix, some NextJS projects, etc.)
        -- prefer to run biome through dprint, as it's more performant
        dprint = {
          condition = function(_, ctx)
            if use_global_dprint_formatter then
              local has_prettier = vim.fs.find({ ".prettierrc.js" }, { upward = true })[1]
              local has_eslint = vim.fs.find({ ".eslintrc.js" }, { upward = true })[1]
              local biome_available = conform.get_formatter_info("biome", ctx.buf).available
              return not has_prettier and not has_eslint and not biome_available
              -- return not require("conform").get_formatter_info("prettier", ctx.buf).available
              --   and not require("conform").get_formatter_info("biome", ctx.buf).available
            else
              local has_dprint = vim.fs.find(dprint_filenames, { upward = true })[1]
              return has_dprint
            end
          end,
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
            local has_dprint_config = vim.fs.find(dprint_filenames, { upward = true })[1]
            local has_biome = vim.fs.find({ "biome.json" }, { path = ctx.filename, upward = true })[1]
            return has_biome and not has_dprint_config
          end,
        },
        prettier = prettier_settings,
        prettierd = prettier_settings,
      })
    end,
  },
}

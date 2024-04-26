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
      lsp_util.set_formatters(opts, {
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
          -- condition = function(ctx)
          --   return vim.fs.find({
          --     "dprint.json",
          --     ".dprint.jsonc",
          --     -- "dprint.jsonc",
          --     -- ".dprint.jsonc",
          --   }, { path = ctx.filename, upward = true })[1]
          -- end,
          -- TODO: remove since there is now a condition
          cwd = util.root_file({
            "dprint.json",
            "dprint.jsonc",
            ".dprint.json",
            ".dprint.jsonc",
            "package.json", -- added this line
          }),
        },
      })

      local slow_format_filetypes = {}
      require("conform").setup({
        format_on_save = function(bufnr)
          if slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end
          local function on_format(err)
            if err and err:match("timeout$") then
              slow_format_filetypes[vim.bo[bufnr].filetype] = true
            end
          end

          return { timeout_ms = 200, lsp_fallback = true }, on_format
        end,

        format_after_save = function(bufnr)
          if not slow_format_filetypes[vim.bo[bufnr].filetype] then
            return
          end
          return { lsp_fallback = true }
        end,
      })
      -- return opts
    end,
  },
}

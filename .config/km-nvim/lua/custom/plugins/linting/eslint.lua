-- From ~/.local/share/nvim/lazy/nvim-lspconfig/lua/lspconfig/configs/eslint.lua:4
-- Copied here so it can be run synchronously to fix prettier diagnostics before
-- running default lsp formatting. It might be more sycnhronous than running it
-- via `vim.cmd("EslintFixAll")`.
  vim.g.lazyvim_eslint_auto_format = true
local auto_format = vim.g.lazyvim_eslint_auto_format == nil or vim.g.lazyvim_eslint_auto_format

local eslint_fix_all = function(opts)
  opts = opts or {}

  local util = require("lspconfig.util")
  local eslint_lsp_client = util.get_active_client_by_name(opts.bufnr, "eslint")
  if eslint_lsp_client == nil then return end

  local request
  if opts.sync then
    request = function(bufnr, method, params)
      eslint_lsp_client.request_sync(method, params, nil, bufnr)
    end
  else
    request = function(bufnr, method, params)
      eslint_lsp_client.request(method, params, nil, bufnr)
    end
  end

  local bufnr = util.validate_bufnr(opts.bufnr or 0)
  return request(0, "workspace/executeCommand", {
    command = "eslint.applyAllFixes",
    arguments = {
      {
        uri = vim.uri_from_bufnr(bufnr),
        version = vim.lsp.util.buf_versions[bufnr],
      },
    },
  })
end

return {
  {
    "neovim/nvim-lspconfig",
    -- other settings removed for brevity
    opts = {
      ---@type lspconfig.options
      servers = {
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectories = { mode = "auto" },
            format = auto_format,
          },
        },
      },
      setup = {
        eslint = function()
          if not auto_format then
            return
          end

          local function get_client(buf)
            return Util.lazy.lsp.get_clients({ name = "eslint", bufnr = buf })[1]
          end

          local formatter = Util.lazy.lsp.formatter({
            name = "eslint: lsp",
            primary = false,
            priority = 200,
            filter = "eslint",
          })

          -- Use EslintFixAll on Neovim < 0.10.0
          if not pcall(require, "vim.lsp._dynamic") then
            formatter.name = "eslint: EslintFixAll"
            formatter.sources = function(buf)
              local client = get_client(buf)
              return client and { "eslint" } or {}
            end
            formatter.format = function(buf)
              local client = get_client(buf)
              if client then
                local diag = vim.diagnostic.get(buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
                if #diag > 0 then
                  vim.cmd("EslintFixAll")
                end
              end
            end
          end

          -- register the formatter with LazyVim
          LazyVim.format.register(formatter)
        end,
      },
    },
  },

  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "eslint",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        -- https://github.com/Microsoft/vscode-eslint#settings-options
        eslint = {
          rulesCustomizations = {
            { rule = "object-curly-spacing", severity = "off", fixable = false },
          },
        },
      },
      setup = {
        eslint = function()
          local function get_client(buf)
            return Util.lazy.lsp.get_clients({ name = "eslint", bufnr = buf })[1]
          end

          local formatter = Util.lazy.lsp.formatter({
            name = "eslint: lsp",
            primary = false,
            priority = 200,
            filter = "eslint",
          })

          -- Override Eslint LSP formatter with EslintFixAll to support prettier/prettier diagnostics
          formatter.name = "eslint: EslintFixAll"
          formatter.sources = function(buf)
            local client = get_client(buf)
            return client and { "eslint" } or {}
          end

          local old_format = formatter.format
          local run_eslint_fix_all = function(buf)
            -- vim.notify("Running EslintFixAll", "info", { title = "LazyVim" })

            -- Executes synchronously based on ~/.local/share/nvim/lazy/nvim-lspconfig/lua/lspconfig/configs/eslint.lua:156
            -- But is vim.cmd synchronous?
            -- vim.cmd("EslintFixAll")
            local _, err = eslint_fix_all({ bufnr = buf, sync = true })
            if err then vim.notify(("Error:\n%s"):format(err), "error", { title = "EslintFixAll" }) end
          end

          formatter.format = function(buf)
            local client = get_client(buf)
            if client then
              local diag = vim.diagnostic.get(buf, { severity = { vim.diagnostic.severity.ERROR } })
              if #diag == 0 then return end

              local has_prettier_diag = false
              for _, d in pairs(diag) do
                if d.code == "prettier/prettier" then
                  has_prettier_diag = true
                  break
                end
              end

              if has_prettier_diag then
                run_eslint_fix_all(buf)
                -- run_lsp_format(buf)
              else
                old_format(buf)
                return
              end
            end
          end

          -- register the formatter with LazyVim
          LazyVim.format.register(formatter)
        end,
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = function(_, opts)
      -- opts.formatters_by_ft["javascript"] = { "eslint_d" }
      -- opts.formatters_by_ft["javascript"] = { "prettierd" }
      -- Format with LSP instead
      opts.formatters_by_ft["javascript"] = {}
    end,
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        eslint = {
          prepend_args = function()
            local util = require("util.system")
            if util.hostname() == "ali-d7jf7y.local" then return { "-c", ".eslintrc.js", "--quiet" } end
          end,
        },
        eslint_d = {
          prepend_args = function()
            local util = require("util.system")
            if util.hostname() == "ali-d7jf7y.local" then return { "-c", ".eslintrc.js", "--quiet" } end
          end,
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters = {
        eslint_d = {
          prepend_args = function()
            local util = require("util.system")
            if util.hostname() == "ali-d7jf7y.local" then return { "--quiet" } end
          end,
        },
      },
    },
  },
}
 

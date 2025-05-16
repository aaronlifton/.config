-- local prettier = { "prettierd", "prettier", stop_after_first = true }
local prettier = { "prettier" }

local config_file_names = {
  -- https://prettier.io/docs/en/configuration.html
  ".prettierrc",
  ".prettierrc.json",
  ".prettierrc.yml",
  ".prettierrc.yaml",
  ".prettierrc.json5",
  ".prettierrc.js",
  ".prettierrc.cjs",
  ".prettierrc.mjs",
  ".prettierrc.toml",
  "prettier.config.js",
  "prettier.config.cjs",
  "prettier.config.mjs",
}

return {
  { import = "lazyvim.plugins.extras.formatting.prettier" },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "prettierd",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      -- formatters_by_ft = {
      --   ["javascript"] = prettier,
      --   ["javascriptreact"] = prettier,
      --   ["typescript"] = prettier,
      --   ["typescriptreact"] = prettier,
      --   ["vue"] = prettier,
      --   ["css"] = prettier,
      --   ["scss"] = prettier,
      --   ["less"] = prettier,
      --   ["html"] = prettier,
      --   ["json"] = prettier,
      --   ["jsonc"] = prettier,
      --   ["yaml"] = prettier,
      --   ["markdown"] = prettier,
      --   ["markdown.mdx"] = prettier,
      --   ["graphql"] = prettier,
      --   ["handlebars"] = prettier,
      -- },
      formatters = {
        prettierd = {
          require_cwd = false,
          env = {
            PRETTIERD_DEFAULT_CONFIG = vim.fn.stdpath("config") .. "/rules/.prettierrc.json",
          },
        },
        prettier = {
          prepend_args = function(_, ctx)
            local has_config = vim.fs.root(ctx.dirname, function(name, path)
              if vim.tbl_contains(config_file_names, name) then return true end
            end)
            if not has_config then return { "--config", vim.fn.stdpath("config") .. "/rules/.prettierrc.json" } end
          end,
        },
      },
    },
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "prettier",
      },
    },
  },
}

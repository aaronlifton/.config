local source_action = function()
  local errors = {}

  for line in io.lines("build.log") do
    local parts = vim.split(line, ":")
    local filename = parts[1]
    local linenr = parts[2]
    local colnr = parts[3]
    local text = parts[4]

    table.insert(errors, {
      filename = filename,
      lnum = linenr,
      col = colnr,
      text = text,
    })
  end
  vim.fn.setqflist(errors)
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      { "virchau13/tree-sitter-astro" },
    },
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "astro" })
      end
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- astro = {},
        astro = {
          handlers = {
            ["textDocument/publishDiagnostics"] = function(err, result, ctx, config)
              require("ts-error-translator").translate_diagnostics(err, result, ctx, config)
              vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx, config)
            end,
          },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "astro-language-server" })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local lsp_util = require("util.lsp")
      lsp_util.add_linters(opts, {
        -- astro uses eslint instead of biome because eslint has astro rules
        -- ["astro"] = { "eslint_d", "stylelint" },
        ["astro"] = { "eslint" },
      })
    end,
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    ensure_installed = {
      "astro",
    },
  },
  -- {
  --   "folke/which-key.nvim",
  --   opts = {
  --     defaults = {
  --       ["<leader>xa"] = { name = " database" },
  --     },
  --   },
  -- },
}

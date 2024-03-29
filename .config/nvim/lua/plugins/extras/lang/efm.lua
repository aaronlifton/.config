return {
  {
    "mattn/efm-langserver",
    dependencies = {
      {
        "creativenull/efmls-configs-nvim",
        version = false,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    -- opts = {
    --   servers = {},
    -- },
    config = function(_, opts)
      -- local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      require("lspconfig").efm.setup({
        init_options = { documentFormatting = true, documentRangeFormatting = true },
        filetypes = { "mdx", "fennel", "fish", "gitcommit", "sql" },
        settings = {
          rootMarkers = { ".git/" },
          languages = {
            -- css = { require("efmls-configs.linters.stylelint") },
            -- lua = {
            --   require("efmls-configs.linters.luacheck"),
            --   -- require("efmls-configs.formatters.stylua"),
            -- },
            fennel = {
              require("efmls-configs.formatters.fnlfmt"),
            },
            fish = {
              require("efmls-configs.linters.fish"),
            },
            gitcommit = {
              require("efmls-configs.linters.gitlint"),
            },
            sql = {
              require("efmls-configs.formatters.sql-formatter"),
            },
            mdx = {
              require("efmls-configs.formatters.prettier"),
              require("efmls-configs.formatters.cbfmt"),
            },
            -- go = {
            --   require("efmls-configs.linters.djlint"),
            --   require("efmls-configs.linters.go_revive"),
            -- },
            -- deno = {
            --   require("efmls-configs.formatters.deno_fmt"),
            -- },
          },
        },
      })

      local lsp_fmt_group = vim.api.nvim_create_augroup("LspFormattingGroup", {})
      vim.api.nvim_create_autocmd("BufWritePost", {
        group = lsp_fmt_group,
        callback = function(ev)
          local efm = vim.lsp.get_active_clients({ name = "efm", bufnr = ev.buf })

          if vim.tbl_isempty(efm) then return end

          vim.cmd("echo 'here'")
          vim.lsp.buf.format({ name = "efm" })
        end,
      })
    end,
  },
}

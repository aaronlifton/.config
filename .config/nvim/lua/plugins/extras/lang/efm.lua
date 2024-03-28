return {
  {
    "mattn/efm-langserver",
    dependencies = {
      {
        "creativenull/efmls-configs-nvim",
        version = "v0.2.x",
      },
    },
    config = function(_, opts)
      require("lspconfig").efm.setup({
        init_options = { documentFormatting = true, documentRangeFormatting = true },
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
    end,
  },
}

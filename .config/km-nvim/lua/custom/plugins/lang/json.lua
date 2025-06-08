return {
  -- add json to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "json5" } },
  },

  -- yaml schema support
  {
    "b0o/SchemaStore.nvim",
    lazy = true,
    version = false, -- last release is way too old
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        jsonls = {
          -- lazy-load schemastore when needed
          on_new_config = function(new_config)
            new_config.settings.json.schemas = new_config.settings.json.schemas or {}
            vim.list_extend(
              new_config.settings.json.schemas,
              require("schemastore").json.schemas({
                extra = {
                  {
                    description = "Lua Language Server Configuration JSON Schema",
                    fileMatch = ".luarc.json",
                    name = ".luarc.json",
                    url = "https://github.com/LuaLS/vscode-lua/raw/master/setting/schema.json",
                  },
                  -- {
                  --   description = "Zed Theme Schema 0.2.0",
                  --   fileMatch = ".zedtheme.json",
                  --   name = ".zedtheme.json",
                  --   url = "https://zed.dev/schema/themes/v0.2.0.json",
                  -- },
                },
              })
            )
          end,
          settings = {
            json = {
              format = {
                enable = true,
              },
              validate = { enable = true },
            },
          },
        },
      },
    },
  },
  {
    "gennaro-tedesco/nvim-jqx",
    ft = { "json", "json5", "yaml" },
    cmd = { "JqxList", "JqxQuery" },
    keys = {
      { "<leader>cj", ft = { "json", "yaml" }, "<cmd>JqxList<cr>", desc = "Jqx List" },
    },
  },
}

return {
  { import = "lazyvim.plugins.extras.lang.json" },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
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
                },
              })
            )
          end,
          settings = {
            json = {
              format = {
                -- changed this from LazyVim
                enable = false,
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
    ft = { "json", "yaml" },
    cmd = { "JqxList", "JqxQuery" },
    keys = {
      { "<leader>cj", ft = { "json", "yaml" }, "<cmd>JqxList<cr>", desc = "Jqx List" },
    },
  },
}

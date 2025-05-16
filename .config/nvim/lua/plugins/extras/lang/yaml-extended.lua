return {
  { import = "lazyvim.plugins.extras.lang.yaml" },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    ---@class PluginLspOpts
    opts = {
      servers = {
        yamlls = {
          settings = {
            yaml = {
              schemas = {
                ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
                ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
                ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
              },
            },
          },
        },
      },
    },
  },
}

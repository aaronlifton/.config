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
  -- {
  --   "someone-stole-my-name/yaml-companion.nvim",
  --   dependencies = {
  --     { "neovim/nvim-lspconfig" },
  --     { "nvim-lua/plenary.nvim" },
  --     { "nvim-telescope/telescope.nvim" },
  --   },
  --   opts = {},
  --   config = function(_, opts)
  --     if LazyVim.has("telescope") then
  --       require("telescope").load_extension("yaml_schema")
  --     end
  --   end,
  --   keys = {
  --     { "<leader>sY", "<cmd>Telescope yaml_schema<cr>", desc = "YAML schemas" },
  --   },
  -- },
}

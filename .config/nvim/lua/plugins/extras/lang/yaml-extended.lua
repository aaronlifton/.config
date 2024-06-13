return {
  {
    "someone-stole-my-name/yaml-companion.nvim",
    dependencies = {
      { "neovim/nvim-lspconfig" },
      { "nvim-lua/plenary.nvim" },
      { "nvim-telescope/telescope.nvim" },
    },
    opts = {},
    config = function(_, opts)
      if LazyVim.has("telescope") then
        require("telescope").load_extension("yaml_schema")
      end
    end,
    keys = {
      { "<leader>sy", "<cmd>Telescope yaml_schema<cr>" },
    },
  },
}

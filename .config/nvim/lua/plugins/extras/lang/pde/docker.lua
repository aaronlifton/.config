if not require("config").pde.docker then
  return {}
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = { "dockerfile" },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = opts.sources or {}
      vim.list_extend(opts.sources, {
        nls.builtins.diagnostics.hadolint,
      })
    end,
    dependencies = {
      "mason.nvim",
      opts = function(_, opts)
        opts.ensure_installed = opts.ensure_installed or {}
        vim.list_extend(opts.ensure_installed, { "hadolint" })
      end,
    },
  },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = {
      servers = {
        dockerls = {},
        docker_compose_language_service = {},
      },
    },
  },
  {
    "telescope.nvim",
    optional = true,
    dependencies = {
      {
        "lpoto/telescope-docker.nvim",
        opts = {},
        config = function(_, opts)
          require("telescope").load_extension("docker")
        end,
        keys = {
          { "<leader>fd", "<Cmd>Telescope docker<CR>", desc = "Docker" },
        },
      },
    },
  },
}

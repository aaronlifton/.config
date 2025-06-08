return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "dockerfile" } },
  },
  {
    "mason.nvim",
    opts = { ensure_installed = { "hadolint" } },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        dockerfile = { "hadolint" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        dockerls = {},
        docker_compose_language_service = {},
      },
    },
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "docker",
      },
    },
  },
  {
    "skanehira/denops-docker.vim",
    enabled = false,
    dependencies = {
      "vim-denops/denops.vim",
    },
    cond = function()
      return vim.fn.executable("docker") == 1 and vim.fn.executable("deno") == 1
    end,
  },
}

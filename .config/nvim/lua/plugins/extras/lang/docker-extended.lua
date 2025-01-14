return {
  { import = "lazyvim.plugins.extras.lang.docker" },
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

return {
  {
    "EthanJWright/vs-tasks.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/popup.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      {
        'Joakker/lua-json5',
        run = './install.sh'
      }
    },
  }
}

local filetypes = {
  "gitcommit",
  "octo",
  "NeogitCommitMessage",
}

return {
  "hrsh7th/nvim-cmp",
  dependencies = {
    "petertriho/cmp-git",
    opts = {},
  },
  opts = function(_, opts)
    require("cmp_git").setup({
      filetypes = filetypes,
      github = {
        hosts = { "git.synack.com" },
      },
    })

    local cmp = require("cmp")
    cmp.setup.filetype(filetypes, {
      sources = cmp.config.sources({
        { name = "git" },
      }, {
        { name = "buffer" },
      }),
    })
  end,
}

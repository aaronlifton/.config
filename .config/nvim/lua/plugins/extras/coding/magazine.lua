-- https://github.com/iguanacucumber/magazine.nvim
return {
  { --* the completion engine *--
    "iguanacucumber/magazine.nvim",
    name = "nvim-cmp", -- Otherwise highlighting gets messed up
  },

  --* the sources *--
  { "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
  { "iguanacucumber/mag-nvim-lua", name = "cmp-nvim-lua" },
  { "iguanacucumber/mag-buffer", name = "cmp-buffer" },
  { "iguanacucumber/mag-cmdline", name = "cmp-cmdline" },

  { "https://codeberg.org/FelipeLema/cmp-async-path" }, -- not by me, but better than cmp-path
}

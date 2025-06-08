#!/usr/bin/env -S nvim -l

vim.env.LAZY_STDPATH = ".tests"
load(vim.fn.system("curl -s https://raw.githubusercontent.com/folke/lazy.nvim/main/bootstrap.lua"))()

-- Setup lazy.nvim
require("lazy.minit").busted({
  spec = {
    "Util.lazy/starter",
    "mason-org/mason-lspconfig.nvim",
    "mason-org/mason.nvim",
    "nvim-treesitter/nvim-treesitter",
  },
})

-- To use this, you can run:
-- nvim -l ./tests/busted.lua tests
-- If you want to inspect the test environment, run:
-- nvim -u ./tests/busted.lua

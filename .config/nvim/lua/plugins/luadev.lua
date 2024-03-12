return {
  {
    "rafcamlet/nvim-luapad",
    name = "luapad",
    config = function(_, opts)
      require("luapad").setup(opts)
    end,
    keys = {
      { "<leader>Lp", "<cmd>Luapad<cr>", desc = "Luapad" },
      { "<leader>Lr", "<cmd>Luarun<cr>", desc = "Luarun" },
    },
  },
  -- {
  --   "ii14/neorepl.nvim",
  --   name = "neorepl",
  --   config = function(_, opts)
  --     require("neorepl").setup(opts)
  --   end,
  -- },
  -- {
  --   "nvim-luadev",
  --   name = "luadev",
  --   config = function(_, _opts)
  --     require("luadev").setup({
  --       -- library = {
  --       --   vimruntime = true,
  --       --   plugins = true,
  --       -- },
  --       -- include = {
  --       --   "<Plug>luadev",
  --       -- },
  --       -- run = {
  --       --   "require('luadev').run()",
  --       -- },
  --       -- eval = {
  --       --   "require('luadev').eval()",
  --       -- },
  --     })
  --   end,
  -- },
}

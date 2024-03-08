return {
  {
    "rafcamlet/nvim-luapad",
    name = "luapad",
    config = function(_, opts)
      require("luapad").setup(opts)
    end,
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

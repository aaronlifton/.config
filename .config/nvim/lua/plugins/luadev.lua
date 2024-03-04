return {
  {
    "nvim-luadev",
    lazy = false,
    name = "luadev",
    config = function(_, _opts)
      require("luadev").setup({
        -- library = {
        --   vimruntime = true,
        --   plugins = true,
        -- },
        -- include = {
        --   "<Plug>luadev",
        -- },
        -- run = {
        --   "require('luadev').run()",
        -- },
        -- eval = {
        --   "require('luadev').eval()",
        -- },
      })
    end,
  },
}

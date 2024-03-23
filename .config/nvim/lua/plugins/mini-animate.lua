-- disable resize animation
return {
  {
    "echasnovski/mini.animate",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      -- disable sliding edgy windos
      opts.resize.enable = false
    end,
  },
}

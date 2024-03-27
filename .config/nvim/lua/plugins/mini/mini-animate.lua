-- disable resize animation
return {
  {
    "echasnovski/mini.animate",
    optional = true,
    event = "VeryLazy",
    opts = function(_, opts)
      -- disable sliding edgy windows
      opts.resize = opts.resize or {}
      opts.resize.enable = false
      opts.open = opts.open or {}
      opts.open.enable = false
      opts.close = opts.close or {}
      opts.close.enable = false
      -- echo opts
      -- vim.api.nvim_echo({ { vim.inspect(opts), "Normal" } }, true, {})
    end,
  },
}

return {
  "sainnhe/edge",
  lazy = false,
  config = function(_, opts)
    -- Optionally configure and load the colorscheme
    -- directly inside the plugin declaration.
    vim.g.edge_enable_italic = true
    -- vim.cmd.colorscheme("edge")
  end,
}

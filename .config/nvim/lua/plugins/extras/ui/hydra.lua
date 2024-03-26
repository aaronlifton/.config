return {
  "anuvyklack/hydra.nvim",
  dependencies = "anuvyklack/keymap-layer.nvim",
  config = function()
    require("mappings").hydra()
  end,
}

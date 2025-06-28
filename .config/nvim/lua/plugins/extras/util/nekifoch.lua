return {
  "NeViRAIDE/nekifoch.nvim",
  build = "chmod +x ./install.sh && ./install.sh",
  cmd = "Nekifoch",
  opts = {
    kitty_conf_path = "~/.config/kitty/kitty.conf",
    borders = "rounded", --available values are: 'rounded', 'single', 'double', 'shadow', 'solid', 'none'
  },
  config = true,
}

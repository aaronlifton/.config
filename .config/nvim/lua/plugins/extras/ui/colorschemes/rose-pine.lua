return {
  "rose-pine/neovim",
  name = "rose-pine",
  opts = {
    highlight_groups = {
      EndOfBuffer = { fg = "base" },
    },
    disable_background = true,
    styles = {
      italic = false,
    },
  },
  config = function()
    vim.cmd("colorscheme rose-pine")
  end,
}

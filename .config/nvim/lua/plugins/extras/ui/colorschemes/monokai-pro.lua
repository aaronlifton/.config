return {
  "loctvl842/monokai-pro.nvim",
  name = "monokai-pro",
  opts = {
    terminal_colors = true,
    devicons = true, -- highlight the icons of `nvim-web-devicons`
    filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
    plugins = {
      indent_blankline = {
        context_highlight = "pro", -- default | pro
        context_start_underline = false,
      },
    },
  },
  lazy = false,
}

return {
  "nvchad/ui",
  opts = {
    ui = {
      statusline = {
        enabled = false,
      },
      tabufline = {
        enabled = false,
      },
      cmp = {
        icons_left = false, -- only for non-atom styles!
        style = "default", -- default/flat_light/flat_dark/atom/atom_colored
        abbr_maxwidth = 60,
        format_colors = {
          tailwind = false, -- will work for css lsp too
          icon = "󱓻",
        },
      },
    },
  },
  config = function()
    require("nvchad")
  end,
}

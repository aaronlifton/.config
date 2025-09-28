return {
  "scottmckendry/cyberdream.nvim",
  lazy = true,
  name = "cyberdream",
  opts = {},
  config = function()
    -- local colors = require("cyberdream.colors").default
    require("cyberdream").setup({
      variant = "default",
      italic_comments = true,
      hide_fillchars = true,
      borderless_pickers = true,
      terminal_colors = true,
      transparent = false,
      extensions = {
        cmp = true,
        fzflua = true,
        grapple = true,
        grugfar = true,
        helpview = true,
        lazy = true,
        leap = true,
        markdown = true,
        mini = true,
        neogit = true,
        noice = true,
        notify = true,
        snacks = true,
        treesitter = true,
        treesittercontext = true,
        trouble = true,
        whichkey = true,
      },
      -- theme = {
      --   highlights = {
      --     Constant = { fg = colors.magenta },
      --     -- 19:43:22 msg_show CmpItemMenu   xxx guifg=#7b8496 guibg=#16181a
      --     -- CmpItemMenu = f
      --   },
      -- },
    })
  end,
  dependencies = {
    {
      "nvim-lualine/lualine.nvim",
      optional = true,
      opts = function(_, opts)
        opts.options.component_separators = nil
        opts.options.section_separators = nil
      end,
    },
  },
}

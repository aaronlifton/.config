return {
  "scottmckendry/cyberdream.nvim",
  lazy = true,
  name = "cyberdream",
  opts = {},
  config = function()
    -- local colors = require("cyberdream.colors").default
    require("cyberdream").setup({
      italic_comments = true,
      hide_fillchars = true,
      borderless_telescope = true,
      terminal_colors = true,
      transparent = true,
      -- theme = {
      --   highlights = {
      --     Constant = { fg = colors.magenta },
      --     -- 19:43:22 msg_show CmpItemMenu   xxx guifg=#7b8496 guibg=#16181a
      --     -- CmpItemMenu = f
      --   },
      -- },
    })
    local x = function() end
  end,
}

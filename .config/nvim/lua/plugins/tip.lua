return {
  "TobinPalmer/Tip.nvim",
  event = "VimEnter",
  enabled = false,
  init = function()
    -- Default config
    --- @type Tip.config
    require("tip").setup({
      seconds = 2,
      title = "Tip!",
      url = "https://vtip.43z.one",
    })
  end,
}

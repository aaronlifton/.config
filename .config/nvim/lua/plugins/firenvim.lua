return {
  {
    "glacambre/firenvim",
    -- @type firenvim
    -- Lazy load firenvim
    -- Explanation: https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    enabled = not not vim.g.started_by_firenvim and not vim.g.vscode,
    build = function()
      require("lazy").load({ plugins = { "firenvim" }, wait = true })
      vim.fn["firenvim#install"](0)
    end,
  },
}

-- local enabled = {
--   "LazyVim",
--   "dial.nvim",
--   "flit.nvim",
--   "lazy.nvim",
--   "leap.nvim",
--   "mini.ai",
--   "mini.comment",
--   "mini.move",
--   "mini.pairs",
--   "mini.surround",
--   "nvim-treesitter",
--   "nvim-treesitter-textobjects",
--   "nvim-ts-context-commentstring",
--   "snacks.nvim",
--   "ts-comments.nvim",
--   "vim-repeat",
--   "yanky.nvim",
-- }
--
-- local Config = require("lazy.core.config")
-- Config.options.checker.enabled = false
-- Config.options.change_detection.enabled = false
-- Config.options.defaults.cond = function(plugin)
--   return vim.tbl_contains(enabled, plugin.name) or plugin.vscode
-- end

return {
  {
    "glacambre/firenvim",
    -- Lazy load firenvim
    -- https://github.com/folke/lazy.nvim/discussions/463#discussioncomment-4819297
    lazy = not vim.g.started_by_firenvim,
    build = ":call firenvim#install(0)",
    config = function()
      vim.g.firenvim_config = {
        localSettings = {
          [".*"] = {
            takeover = "never",
            -- selector = 'textarea:not([readonly], [aria-readonly]), div[role="textbox"]'
            selector = "textarea:not([readonly], [aria-readonly])",
            cmdline = "firenvim",
          },
          ["https://google.com/"] = { takeover = "never", priority = 1 },
        },
      }
    end,
    init = function()
      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        pattern = { "github.com_*.txt", "git.*.com_*.txt" },
        command = "set filetype=markdown",
      })
    end,
  },
  { "folke/noice.nvim", cond = not vim.g.started_by_firenvim },
  { "ibhagwan/fzf-lua", cond = not vim.g.started_by_firenvim },
  { "lualine.nvim", cond = not vim.g.started_by_firenvim },
  { "folke/persistence.nvim", cond = not vim.g.started_by_firenvim },
  -- {
  --     "LazyVim/LazyVim",
  --     config = function(_, opts)
  --       opts = opts or {}
  --       -- disable the colorscheme
  --       opts.colorscheme = function() end
  --       require("lazyvim").setup(opts)
  --     end,
  --   }
}

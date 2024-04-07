-- since this is just an example spec, don't actually load anything here and return an empty specmarkdown
-- stylua: ignore
-- if true then return {} end

-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin", -- "material", "everforest", "night-owl", "gruvbox_baby", "tokyonight"
      use_diagnostic_signs = true,
      concurrency = 20
    },
  },
  -- {
  --   "ahmedkhalf/project.nvim",
  --   enabled = not vim.g.vscode,
  --   config = function()
  --     require("project_nvim").setup()
  --     -- {
  --     -- your configuration comes here
  --     -- or leave it empty to use the default settings
  --     -- refer to the configuration section below
  --     -- }
  --   end
  -- },
  {
    "numToStr/Comment.nvim",
    version = false,
    config = function()
      require("Comment").setup()
    end,
  },
  -- {
  --   "karb94/neoscroll.nvim",
  --   -- enabled = not vim.g.vscode,
  --   config = function()
  --     return {
  --       -- All these keys will be mapped to their corresponding default scrolling animation
  --       mappings = { '<C-u>', '<C-d>', '<C-b>', '<C-f>',
  --         '<C-y>', '<C-e>', 'zt', 'zz', 'zb' },
  --       hide_cursor = true,          -- Hide cursor while scrolling
  --       stop_eof = true,             -- Stop at <EOF> when scrolling downwards
  --       respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
  --       cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
  --       easing_function = nil,       -- Default easing function
  --       pre_hook = nil,              -- Function to run before the scrolling animation starts
  --       post_hook = nil,             -- Function to run after the scrolling animation ends
  --       performance_mode = false,    -- Disable "Performance Mode" on all buffers.
  --     }
  --   end
  -- },
  { "tpope/vim-repeat", event = "VeryLazy" },
  {
    "shortcuts/no-neck-pain.nvim",
    event = "VeryLazy",
    version = "*",
    config = function()
      require("no-neck-pain").setup()
    end,
    keys = {
      {
        "<leader>uN",
        function()
          vim.cmd("Neotree close")
          vim.cmd("NoNeckPain")
        end,
        desc = "No Neck Pain"
      },
    },
  }
}

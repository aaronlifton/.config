return {
  -- Core dependencies
  { "MunifTanjim/nui.nvim", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },
  { "nvim-tree/nvim-web-devicons", lazy = true },

  -- Mini plugins
  { "echasnovski/mini.surround", version = false },
  { "echasnovski/mini.diff", version = false },
  { "echasnovski/mini.move", version = false },
  { "echasnovski/mini.ai", version = false },
  { "echasnovski/mini.pairs", version = false },
  { "echasnovski/mini.files", version = false },
  { "echasnovski/mini.hipatterns", version = false },

  -- Navigation and editing
  { "gbprod/yanky.nvim", opts = {} },
  { "smoka7/multicursor.nvim", opts = {} },
  { "ggandor/leap.nvim", dependencies = { "tpope/vim-repeat" } },
  { "sm/inc-rename.nvim" },

  -- Git
  { "sindrets/diffview.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
  { "TimUntersberger/neogit", dependencies = { "nvim-lua/plenary.nvim" } },
  { "akinsho/git-conflict.nvim", version = "*" },
  { "FabijanZulj/blame.nvim" },

  -- Treesitter and related
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },
  { "RRethy/nvim-treesitter-endwise" },
  { "Wansmer/sibling-swap.nvim" },
  { "Wansmer/treesj" },
  { "nvim-treesitter/nvim-treesitter-context" },

  -- LSP and completion
  { "neovim/nvim-lspconfig" },
  { "mason-org/mason.nvim" },
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },

  -- File explorer and UI
  { "nvim-neo-tree/neo-tree.nvim" },
  { "folke/edgy.nvim" },
  { "akinsho/bufferline.nvim", version = "*" },
  { "nvim-lualine/lualine.nvim" },
  { "folke/noice.nvim" },
  { "folke/which-key.nvim" },

  -- Search and replace
  { "nvim-pack/nvim-spectre" },
  { "ibhagwan/fzf-lua" },

  -- AI and copilot
  { "zbirenbaum/copilot.lua" },
  { "gptlang/model.nvim" },

  -- Ruby specific
  { "tpope/vim-rails" },
  { "tpope/vim-bundler" },
  { "vim-test/vim-test" },
  { "nvim-neotest/neotest" },
  { "olimorris/neotest-rspec" },

  -- Documentation
  { "luckasRanarison/nvim-devdocs" },

  -- Utilities
  { "max397574/better-escape.nvim" },
  { "glacambre/firenvim" },
  { "mikesmithgh/kitty-scrollback.nvim" },
  { "folke/persistence.nvim" },
  { "mrjones2014/smart-splits.nvim" },
  { "ThePrimeagen/harpoon", dependencies = { "nvim-lua/plenary.nvim" } },
}

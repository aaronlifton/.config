return {
  "nvim-treesitter/nvim-treesitter",
  ---@type TSConfig
  ---@diagnostic disable-next-line: missing-fields
  opts = {
    -- From LazyVim treesitter config
    -- incremental_selection = {
    --   enable = true,
    --   keymaps = {
    --     init_selection = "<C-space>", -- Enter
    --     node_incremental = "<C-space>", -- Enter, v
    --     scope_incremental = false,
    --     node_decremental = "<bs>", -- V
    --   },
    -- },
    -- textobjects = {
    --   move = {
    --     enable = true,
    --     goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
    --     goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
    --     goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
    --     goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
    --   },
    -- },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },
    -- TODO: try treesitter-textsubjects
    -- https://github.com/RRethy/nvim-treesitter-textsubjects#quick-start
    -- textsubjects = {
    --   enable = true,
    --   prev_selection = ",",
    --   keymaps = {
    --     ["."] = "textsubjects-smart",
    --     [";"] = "textsubjects-container-inner",
    --     -- ['o;'] = 'textsubjects-container-outer',
    --   },
    -- },
    textobjects = {
      lsp_interop = {
        enable = true,
        border = "rounded",
        floating_preview_opts = { maximum_height = 12 },
        peek_definition_code = {
          ["<leader>gxf"] = "@function.outer",
          ["<leader>gxc"] = "@class.outer",
        },
      },
      -- select = {
      --   enable = true,
      --
      --   -- Automatically jump forward to textobj, similar to targets.vim
      --   lookahead = true,
      --   keymaps = {
      --     -- NOTE: These are handled by mini.ai. One day, these may replace it.
      --     -- You can use the capture groups defined in textobjects.scm
      --     -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/tree/master/queries
      --     -- ["am"] = { query = "@function.outer", desc = "a function definition" },
      --     -- ["im"] = { query = "@function.inner", desc = "a function body" },
      --     -- ["ac"] = { query = "@class.outer", desc = "a class" },
      --     -- ["ic"] = { query = "@class.inner", desc = "inner class" },
      --     -- ["id"] = { query = "@block.inner", desc = "inner block" },
      --     -- ["ad"] = { query = "@block.outer", desc = "a block" },
      --     ["rc"] = "@rspec.context",
      --     ["ri"] = "@rspec.it",
      --   },
      --   -- You can choose the select mode (default is charwise 'v')
      --   --
      --   -- Can also be a function which gets passed a table with the keys
      --   -- * query_string: eg '@function.inner'
      --   -- * method: eg 'v' or 'o'
      --   -- and should return the mode ('v', 'V', or '<c-v>') or a table
      --   -- mapping query_strings to modes.
      --   -- selection_modes = {
      --   --   ["@function.outer"] = "V",
      --   --   ["@class.outer"] = "V",
      --   -- },
      -- },

      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        -- LazyVim already sets @function and @class for move, select is
        -- handled by mini.ai.
        goto_next_start = {
          ["]]"] = "@structure.outer",
          ["]r"] = "@rspec.it",
        },
        goto_next_end = {
          ["]["] = "@structure.outer",
          ["[r"] = "@rspec.it",
        },
        -- TODO: try this out
        goto_previous_start = {
          ["[["] = "@structure.outer",
        },
        goto_previous_end = {
          ["[]"] = "@structure.outer",
        },
      },
      -- investigate replacing sibling-swap with this
      -- swap = {
      --   enable = true,
      --   swap_next = {
      --     ["<leader>a"] = "@parameter.inner",
      --   },
      --   swap_previous = {
      --     ["<leader>A"] = "@parameter.inner",
      --   },
      -- }
      -- -- Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
      -- -- Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
      -- -- Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>gX"] = { name = "Peek definition" },
      },
    },
  },
}

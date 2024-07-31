return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      {
        "andymass/vim-matchup",
        enabled = false,
        init = function()
          vim.g.loaded_matchit = 1
          vim.g.loaded_matchparen = 1
          vim.g.matchup_matchparen_enabled = 0
          -- disable middle-word (return) matching
          vim.g.matchup_delim_noskips = 1
          -- don't enable on startup
          vim.g.matchup_delim_start_plaintext = 0
        end,
      },
    },
    opts = {
      textobjects = {
        -- swap = {
        --   enable = true,
        --   swap_next = {
        --     ["[a"] = "@parameter.inner",
        --   },
        --   swap_previous = {
        --     ["]a"] = "@parameter.inner",
        --   },
        -- },
        lsp_interop = {
          enable = true,
          border = "rounded", -- "none"
          floating_preview_opts = { maximum_height = 12 },
          peek_definition_code = {
            ["<C-w>p"] = "@function.outer",
            ["<C-w>P"] = "@class.outer",
            -- ["df"] = "@function.outer",
            -- ["dF"] = "@class.outer",
          },
        },
        move = {
          goto_next_start = {
            ["]r"] = "@rspec.context",
            ["]i"] = "@rspec.it",
            ["]O"] = "@rspec.describe",
            -- ["]]"] = "@structure.outer",
          },
          goto_next_end = {
            ["]I"] = "@rspec.it",
            ["]R"] = "@rspec.context",
            -- ["]["] = "@structure.outer",
          },
          goto_previous_start = {
            ["[r"] = "@rspec.context",
            ["[i"] = "@rspec.it",
            ["[O"] = "@rspec.describe",
            -- ["[["] = "@structure.outer",
          },
          goto_previous_end = {
            ["[R"] = "@rspec.context",
            ["[I"] = "@rspec.it",
            -- ["[]"] = "@structure.outer",
          },
        },
      },
      matchup = { enable = true },
      -- textsubjects = {
      --   enable = true,
      --   prev_selection = ",",
      --   keymaps = {
      --     ["."] = "textsubjects-smart",
      --     [";"] = "textsubjects-container-inner",
      --     -- ['o;'] = 'textsubjects-container-outer',
      --   },
      -- },
    },
  },
  -- {
  --   "nvim-treesitter/nvim-treesitter",
  --   optional = true,
  --   ---@type TSConfig
  --   ---@diagnostic disable-next-line: missing-fields
  --   config = function(_, opts)
  --     -- From LazyVim treesitter config
  --     -- incremental_selection = {
  --     --   enable = true,
  --     --   keymaps = {
  --     --     init_selection = "<C-space>", -- Enter
  --     --     node_incremental = "<C-space>", -- Enter, v
  --     --     scope_incremental = false,
  --     --     node_decremental = "<bs>", -- V
  --     --   },
  --     -- },
  --     -- textobjects = {
  --     --   move = {
  --     --     enable = true,
  --     --     goto_next_start = { ["]f"] = "@function.outer", ["]c"] = "@class.outer" },
  --     --     goto_next_end = { ["]F"] = "@function.outer", ["]C"] = "@class.outer" },
  --     --     goto_previous_start = { ["[f"] = "@function.outer", ["[c"] = "@class.outer" },
  --     --     goto_previous_end = { ["[F"] = "@function.outer", ["[C"] = "@class.outer" },
  --     --   },
  --     -- },
  --     -- opts.query_linter = {
  --     --   enable = true,
  --     --   use_virtual_text = true,
  --     --   lint_events = { "BufWrite", "CursorHold" },
  --     -- }
  --     vim.api.nvim_echo({ { vim.inspect(opts), "Normal" } }, true, {})
  --     if LazyVim.is_loaded("nvim-treesitter") then
  --       vim.api.nvim_echo({ { "Loaded" }, "Title" }, true, {})
  --       -- local ts_opts = LazyVim.opts("nvim-treesitter")
  --       -- local config = {
  --       --   textobjects = vim.tbl_extend("force", ts_opts.textobjects, { lsp_interop = lsp_interop }),
  --       -- }
  --       require("nvim-treesitter.configs").setup({ text_objects = { lsp_interop = lsp_interop } })
  --     else
  --       vim.api.nvim_echo({ { "Not loaded" }, "Warning" }, true, {})
  --     end
  --     -- TODO: try treesitter-textsubjects
  --     -- https://github.com/RRethy/nvim-treesitter-textsubjects#quick-start
  --     -- select = {
  --     --   enable = true,
  --     --
  --     --   -- Automatically jump forward to textobj, similar to targets.vim
  --     --   lookahead = true,
  --     --   keymaps = {
  --     --     -- NOTE: These are handled by mini.ai. One day, these may replace it.
  --     --     -- You can use the capture groups defined in textobjects.scm
  --     --     -- https://github.com/nvim-treesitter/nvim-treesitter-textobjects/tree/master/queries
  --     --     -- ["am"] = { query = "@function.outer", desc = "a function definition" },
  --     --     -- ["im"] = { query = "@function.inner", desc = "a function body" },
  --     --     -- ["ac"] = { query = "@class.outer", desc = "a class" },
  --     --     -- ["ic"] = { query = "@class.inner", desc = "inner class" },
  --     --     -- ["id"] = { query = "@block.inner", desc = "inner block" },
  --     --     -- ["ad"] = { query = "@block.outer", desc = "a block" },
  --     --     ["rc"] = "@rspec.context",
  --     --     ["ri"] = "@rspec.it",
  --     --   },
  --     --   -- You can choose the select mode (default is charwise 'v')
  --     --   --
  --     --   -- Can also be a function which gets passed a table with the keys
  --     --   -- * query_string: eg '@function.inner'
  --     --   -- * method: eg 'v' or 'o'
  --     --   -- and should return the mode ('v', 'V', or '<c-v>') or a table
  --     --   -- mapping query_strings to modes.
  --     --   -- selection_modes = {
  --     --   --   ["@function.outer"] = "V",
  --     --   --   ["@class.outer"] = "V",
  --     --   -- },
  --     -- },
  --     -- move = {
  --     --   enable = true,
  --     --   set_jumps = true, -- whether to set jumps in the jumplist
  --     --   -- LazyVim already sets @function and @class for move, select is
  --     --   -- handled by mini.ai.
  --     --   goto_next_start = {
  --     --     -- ["]r"] = "@rspec.context",
  --     --     -- ["]i"] = "@rspec.it",
  --     --     -- ["]]"] = "@structure.outer",
  --     --   },
  --     --   goto_next_end = {
  --     --     -- ["[I"] = "@rspec.it",
  --     --     -- ["]R"] = "@rspec.context",
  --     --     -- ["]["] = "@structure.outer",
  --     --   },
  --     --   TODO: try this out
  --     --   goto_previous_start = {
  --     --     -- ["[r"] = "@rspec.context",
  --     --     -- ["[i"] = "@rspec.it",
  --     --     -- ["[C"] = "@rspec.context",
  --     --     -- ["[["] = "@structure.outer",
  --     --   },
  --     --   goto_previous_end = {
  --     --     -- ["[R"] = "@rspec.context",
  --     --     -- ["]I"] = "@rspec.it",
  --     --     -- ["[]"] = "@structure.outer",
  --     --   },
  --     -- },
  --     -- NOTE: investigate replacing sibling-swap with this
  --     -- swap = {
  --     --   enable = true,
  --     --   swap_next = {
  --     --     ["<leader>a"] = "@parameter.inner",
  --     --   },
  --     --   swap_previous = {
  --     --     ["<leader>A"] = "@parameter.inner",
  --     --   },
  --     -- }
  --   end,
  --   {
  --     "folke/which-key.nvim",
  --     opts = {
  --       spec = {
  --         mode = "n",
  --         { "<leader>gX", group = "Peek definition" },
  --       },
  --     },
  --   },
  -- },
}

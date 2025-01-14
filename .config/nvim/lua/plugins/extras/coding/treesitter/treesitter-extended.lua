return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      indent = { enable = true, disable = { "go" } },
      textobjects = {
        -- TODO: Investigate if this can replace sibling-swap.nvim
        -- swap = {
        --   enable = true,
        --   swap_next = {
        --     ["<C-.>"] = "@parameter.inner",
        --   },
        --   swap_previous = {
        --     ["<C-,>"] = "@parameter.inner",
        --   },
        -- },
        lsp_interop = {
          enable = true,
          border = "rounded", -- "none"
          floating_preview_opts = { maximum_height = 12 },
          peek_definition_code = {
            ["<C-w>p"] = "@function.outer",
            ["<C-w>P"] = "@class.outer",
            ["g<C-k>"] = "@function.outer",
            -- ["df"] = "@function.outer",
            -- ["dF"] = "@class.outer",
          },
        },
        move = {
          goto_next_start = {
            -- ["]r"] = "@rspec.context",
            -- ["]i"] = "@rspec.it",
            -- ["]O"] = "@rspec.describe",
            --
            -- ["]]"] = "@structure.outer",
            ["]if"] = "@function.inner",
          },
          goto_next_end = {
            -- ["]I"] = "@rspec.it",
            -- ["]R"] = "@rspec.context",
            --
            -- ["]["] = "@structure.outer",
          },
          goto_previous_start = {
            -- ["[r"] = "@rspec.context",
            -- ["[i"] = "@rspec.it",
            -- ["[O"] = "@rspec.describe",
            --
            -- ["[["] = "@structure.outer",
          },
          goto_previous_end = {
            -- ["[R"] = "@rspec.context",
            -- ["[I"] = "@rspec.it",
            --
            -- ["[]"] = "@structure.outer",
          },
        },
      },
      matchup = { enable = true },
      -- TODO: Investigate what this does
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
}

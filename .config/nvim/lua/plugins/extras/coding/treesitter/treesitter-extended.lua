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
            -- Overrides <C-w>p - previous window
            ["<C-w>p"] = "@function.outer",
            ["g<C-c>"] = "@class.outer",
            ["g<C-k>"] = "@function.outer",
            ["g<C-f>"] = "@function.outer",
            -- ["df"] = "@function.outer",
            -- ["dF"] = "@class.outer",
          },
        },
        move = {
          goto_next_start = {
            -- ["]]"] = "@structure.outer",
            ["]if"] = "@function.inner",
          },
          goto_next_end = {
            -- ["]["] = "@structure.outer",
          },
          goto_previous_start = {
            -- ["[["] = "@structure.outer",
          },
          goto_previous_end = {
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

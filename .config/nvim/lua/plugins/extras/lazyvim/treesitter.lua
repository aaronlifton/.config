return {
  "nvim-treesitter/nvim-treesitter",
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

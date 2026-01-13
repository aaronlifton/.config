return {
  {
    "folke/which-key.nvim",
    opts = {
      spec = {
        -- Disable LazyVim keymaps
        -- { "<BS>", false },
        -- { "<c-space>", false },
        { "<M-Down>", desc = "Decrement Selection", mode = "x" },
        { "<M-Up>", desc = "Increment Selection", mode = { "x", "n" } },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      indent = { enable = true, disable = { "go" } },
      incremental_selection = {
        enable = true,
        keymaps = {
          -- Helix keymaps
          -- (<A-o> <A-up>) Expand selection to parent syntax node
          -- (<A-down> <A-i>) Shrink selection to previously expanded syntax node
          init_selection = "<M-o>",
          scope_incremental = false,
          node_incremental = "<M-o>", -- v
          node_decremental = "<M-i>", -- V
        },
      },
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
            ["g<C-d>"] = "@function.outer",
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
            ["]<C-f>"] = "@function.inner",
            ["]f"] = { query = "@call.outer", desc = "Next function call start" },
            ["]o"] = { query = "@conditional.outer", desc = "Next conditional start" },
            ["]l"] = { query = "@loop.outer", desc = "Next loop start" },

            -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
            -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
            ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
            ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
          },
          goto_next_end = {
            -- ["]["] = "@structure.outer",
            ["]O"] = { query = "@conditional.outer", desc = "Next conditional end" },
            ["]L"] = { query = "@loop.outer", desc = "Next loop end" },
          },
          goto_previous_start = {
            -- ["[["] = "@structure.outer",
            ["[o"] = { query = "@conditional.outer", desc = "Prev conditional start" },
            ["[l"] = { query = "@loop.outer", desc = "Prev loop start" },
          },
          goto_previous_end = {
            -- ["[]"] = "@structure.outer",
            ["[O"] = { query = "@conditional.outer", desc = "Prev conditional end" },
            ["[L"] = { query = "@loop.outer", desc = "Prev loop end" },
          },
        },
        -- Experimental replacement of mini.ai
        -- select = {
        --   enable = true,
        --
        --   -- Automatically jump forward to textobj, similar to targets.vim
        --   lookahead = true,
        --   keymaps = {
        --     ["aa"] = { query = "@parameter.outer", desc = "Select outer part of a parameter/argument" },
        --     ["ia"] = { query = "@parameter.inner", desc = "Select inner part of a parameter/argument" },
        --
        --     ["al"] = { query = "@loop.outer", desc = "Select outer part of a loop" },
        --     ["il"] = { query = "@loop.inner", desc = "Select inner part of a loop" },
        --
        --     ["af"] = { query = "@call.outer", desc = "Select outer part of a function call" },
        --     ["if"] = { query = "@call.inner", desc = "Select inner part of a function call" },
        --
        --     ["am"] = { query = "@function.outer", desc = "Select outer part of a method/function definition" },
        --     ["im"] = { query = "@function.inner", desc = "Select inner part of a method/function definition" },
        --
        --     ["ac"] = { query = "@class.outer", desc = "Select outer part of a class" },
        --     ["ic"] = { query = "@class.inner", desc = "Select inner part of a class" },
        --   },
        -- },
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
    init = function()
      require("util.treesitter-textobjects")
    end,
  },
}

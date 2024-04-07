return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = {
        "astro",
        "bash",
        "fennel",
        "gitcommit",
        "gitignore",
        "go",
        "html",
        "javascript",
        "json",
        "json5",
        "lua",
        "latex",
        "markdown",
        "markdown_inline",
        "python",
        "query",
        "regex",
        "ruby",
        "svelte",
        "tsx",
        "typescript",
        "javascript",
        "vim",
        "yaml",
        "zig",
        "prisma",
      },
      ignore_install = { "haskell" }, -- list of parsers to ignore installing
      highlight = {
        enable = true,
        -- disable = { "c", "rust" },  -- list of language that will be disabled
        -- additional_vim_regex_highlighting = false,
      },
      incremental_selection = {
        enable = false,
        keymaps = {
          init_selection = "<leader>gnn",
          node_incremental = "<leader>gnr",
          scope_incremental = "<leader>gne",
          node_decremental = "<leader>gnt",
        },
      },
      indent = {
        enable = true,
      },
      textobjects = {
        move = {
          enable = true,
          set_jumps = true, -- whether to set jumps in the jumplist
          goto_next_start = {
            ["]]"] = "@function.outer",
            ["]m"] = "@class.outer",
          },
          goto_next_end = {
            ["]["] = "@function.outer",
            ["]M"] = "@class.outer",
          },
          goto_previous_start = {
            ["[["] = "@function.outer",
            ["[m"] = "@class.outer",
          },
          goto_previous_end = {
            ["[]"] = "@function.outer",
            ["[M"] = "@class.outer",
          },
        },
        select = {
          enable = true,

          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,

          keymaps = {
            -- You can use the capture groups defined in textobjects.scm
            ["af"] = "@function.outer",
            ["if"] = "@function.inner",
            ["ac"] = "@class.outer",
            ["ic"] = "@class.inner",
            ["aP"] = "@parameter.outer",
            ["iP"] = "@parameter.inner",
          },
        },
        swap = {
          enable = true,
          swap_next = {
            ["~"] = "@parameter.inner",
          },
        },
      },

      textsubjects = {
        enable = true,
        prev_selection = "<BS>",
        keymaps = {
          ["<CR>"] = "textsubjects-smart", -- works in visual mode
        },
      },
    },
  },
}

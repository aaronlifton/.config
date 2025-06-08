return {
  {
    "echasnovski/mini.nvim",
    optional = true,
    config = function()
      require("mini.pick").setup({
        mappings = {
          caret_left = "<Left>",
          caret_right = "<Right>",

          choose = "<CR>",
          choose_in_split = "<C-s>",
          choose_in_tabpage = "<C-t>",
          choose_in_vsplit = "<C-v>",
          choose_marked = "<M-CR>",

          delete_char = "<BS>",
          delete_char_right = "<Del>",
          delete_left = "<C-u>",
          delete_word = "<C-w>",

          mark = "<C-x>",
          mark_all = "<C-a>",

          move_down = "<C-n>",
          move_start = "<C-g>",
          move_up = "<C-p>",

          paste = "<C-r>",

          refine = "<C-Space>",
          refine_marked = "<M-Space>",

          scroll_down = "<C-f>",
          scroll_left = "<C-h>",
          scroll_right = "<C-l>",
          scroll_up = "<C-b>",

          stop = "<Esc>",

          toggle_info = "<S-Tab>",
          toggle_preview = "<Tab>",
        },
      })
    end,
    keys = {
      {
        "<leader>Pb",
        function()
          MiniExtra.pickers.buf_lines()
        end,
        desc = "Buffer lines",
      },
      {
        "<leader>Pf",
        function()
          MiniExtra.pickers.explorer()
        end,
        desc = "Explorer",
      },
      {
        "<leader>PF",
        function()
          MiniExtra.pickers.git_files({ scope = "modified" })
        end,
        desc = "Git files",
      },
      {
        "<leader>Pg",
        function()
          MiniExtra.pickers.git_branches()
        end,
        desc = "Git branches",
      },
      {
        "<leader>PG",
        function()
          MiniExtra.pickers.git_commits()
        end,
        desc = "Git commits",
      },
      {
        "<leader>Ph",
        function()
          MiniExtra.pickers.git_hunks()
        end,
        desc = "Git hunks",
      },
      {
        "<leader>PH",
        function()
          MiniExtra.pickers.hipatterns()
        end,
        desc = "Hitpatterns",
      },
      {
        "<leader>Pr",
        function()
          MiniExtra.pickers.registers()
        end,
        desc = "Registers",
      },
      {
        "<leader>Pu",
        function()
          MiniExtra.pickers.history()
        end,
        desc = "History",
      },
      {
        "<leader>Pg",
        function()
          MiniExtra.pickers.hl_groups()
        end,
        desc = "Hl groups",
      },
      {
        "<leader>Pk",
        function()
          MiniExtra.pickers.keymaps()
        end,
        desc = "Keymaps",
      },
      {
        "<leader>Pl",
        function()
          MiniExtra.pickers.list()
        end,
        desc = "List",
      },
      {
        "<leader>PL",
        function()
          MiniExtra.pickers.lsp("declaration")
          -- Needs an explicit scope from a list of supported ones:
          -- "declaration".
          -- "definition".
          -- "document_symbol".
          -- "implementation".
          -- "references".
          -- "type_definition".
          -- "workspace_symbol".
        end,
        desc = "LSP",
      },
      {
        "<leader>Pm",
        function()
          MiniExtra.pickers.marks()
        end,
        desc = "Marks",
      },
      {
        "<leader>Pb",
        function()
          MiniExtra.pickers.oldfiles()
        end,
        desc = "Buffers",
      },
      {
        "<leader>Pc",
        function()
          MiniExtra.pickers.commands()
        end,
        desc = "Commands",
      },
      {
        "<leader>Ph",
        function()
          MiniExtra.pickers.help_tags()
        end,
        desc = "Help",
      },
      {
        "<leader>Pv",
        function()
          MiniExtra.pickers.options()
        end,
        desc = "Vim options",
      },
      {
        "<leader>Pt",
        function()
          MiniExtra.pickers.treesitter()
        end,
        desc = "Treesitter nodes",
      },
      {
        "<leader>Pv",
        function()
          MiniExtra.pickers.visit_paths()
        end,
        desc = "Visit paths",
      },
      {
        "<leader>PV",
        function()
          MiniExtra.pickers.visit_labels()
        end,
        desc = "Visit labels",
      },
      {
        "<leader>Pd",
        function()
          MiniExtra.pickers.diagnostic()
        end,
        desc = "Diagnostics",
      },
    },
  },
}

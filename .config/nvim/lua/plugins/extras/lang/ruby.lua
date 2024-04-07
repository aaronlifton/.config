return {
  {
    "tpope/vim-rails",
    ft = "ruby",
    -- config = function()
    --   require("vim-rails").setup()
    -- end,
  },
  {
    "tpope/vim-bundler",
    ft = "ruby",
    -- config = function()
    -- config = function()
    --   require("vim-bundler").setup()
    -- end,
  },
  {
    "weizheheng/ror.nvim",
    config = function()
      require("ror").setup({
        test = {
          message = {
            -- These are the default title for nvim-notify
            file = "Running test file...",
            line = "Running single test...",
          },
          coverage = {
            -- To customize replace with the hex color you want for the highlight
            -- guibg=#354a39
            up = "DiffAdd",
            -- guibg=#4a3536
            down = "DiffDelete",
          },
          notification = {
            -- Using timeout false will replace the progress notification window
            -- Otherwise, the progress and the result will be a different notification window
            timeout = false,
          },
          pass_icon = "✅",
          fail_icon = "❌",
        },
      })
    end,
    keys = {
      { "<Leader>Rc", ":lua require('ror.commands').list_commands()<CR>" },
    },
  },
  {
    "folke/which-key.nvim",
    opts = {
      defaults = {
        ["<leader>R"] = { name = "Rails" },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        solargraph = {},
        standardrb = {},
        yamlls = {
          settings = {
            yaml = {
              validate = true,
              schemaStore = {
                enable = true,
              },
            },
          },
        },
      },
    },
  },
  -- {
  --   "otavioschwanck/tmux-awesome-manager.nvim",
  --   optional = true,
  --   event = "VeryLazy",
  --   config = function()
  --     local tmux_term = require("tmux-awesome-manager.src.term")
  --     local wk = require("which-key")
  --
  --     wk.register({
  --       r = {
  --         -- name = 'Rails',
  --         R = tmux_term.run_wk({
  --           cmd = "bundle exec rails s",
  --           name = "Rails Server",
  --           visit_first_call = false,
  --           open_as = "separated_session",
  --           session_name = "My Terms",
  --         }),
  --         r = require("tmux-awesome-manager.src.term").run_wk({ cmd = "bundle exec rails c", name = "Rails Console", open_as = "window" }),
  --         b = tmux_term.run_wk({
  --           cmd = "bundle install",
  --           name = "Bundle Install",
  --           open_as = "pane",
  --           close_on_timer = 2,
  --           visit_first_call = false,
  --           focus_when_call = false,
  --         }),
  --         t = tmux_term.run_wk({
  --           cmd = "bundle exec rails test",
  --           name = "Run all minitests",
  --           open_as = "pane",
  --           close_on_timer = 2,
  --           visit_first_call = false,
  --           focus_when_call = false,
  --         }),
  --         g = tmux_term.run_wk({
  --           cmd = "bundle exec rails generate %1",
  --           name = "Rails Generate",
  --           questions = {
  --             {
  --               question = "Rails generate: ",
  --               required = true,
  --               open_as = "pane",
  --               close_on_timer = 4,
  --               visit_first_call = false,
  --               focus_when_call = false,
  --             },
  --           },
  --         }),
  --         d = tmux_term.run_wk({
  --           cmd = "bundle exec rails destroy %1",
  --           name = "Rails Destroy",
  --           questions = {
  --             {
  --               question = "Rails destroy: ",
  --               required = true,
  --               open_as = "pane",
  --               close_on_timer = 4,
  --               visit_first_call = false,
  --               focus_when_call = false,
  --             },
  --           },
  --         }),
  --       },
  --     }, { prefix = "<leader>", silent = true })
  --   end,
  -- },
}

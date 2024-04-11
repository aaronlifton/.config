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
    "nvimtools/none-ls.nvim",
    enabled = true,
    optional = true,
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = function(_, opts)
          opts.ensure_installed = opts.ensure_installed or {}
          vim.list_extend(opts.ensure_installed, { "gomodifytags", "impl" })
        end,
      },
    },
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources or {}, {
        nls.builtins.diagnostics.rubocop.with({
          prefer_local = ".bundle/bin",
          condition = function(utils)
            return utils.root_has_file({ ".rubocop.yml" })
          end,
        }),
        nls.builtins.diagnostics.yamllint,
        nls.builtins.formatting.rubyfmt,
        nls.builtins.formatting.rubocop.with({
          prefer_local = ".bundle/bin",
          condition = function(utils)
            return utils.root_has_file({ ".rubocop.yml" })
          end,
        }),
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        solargraph = {},
        standardrb = {},
        rubocop = {},
        ruby_ls = {
          default_config = {
            cmd = { "bundle", "exec", "ruby-lsp" },
            filetypes = { "ruby" },
            root_dir = require("lspconfig.util").root_pattern("Gemfile", ".git"),
            init_options = {
              enabledFeatures = {
                "documentHighlights",
                "documentSymbols",
                "foldingRanges",
                "selectionRanges",
                -- "semanticHighlighting",
                "formatting",
                "codeActions",
              },
            },
            settings = {},
          },
          -- commands = {
          --   FormatRuby = {
          --     function()
          --       vim.lsp.buf.format({
          --         name = "ruby_lsp",
          --         async = true,
          --       })
          --     end,
          --     description = "Format using ruby-lsp",
          --   },
          -- },
        },
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
      setup = {
        ruby_ls = function(_, opts)
          local ruby_lsp_config = require("util.ruby-lsp")
          -- local config = require("lsp.config")

          require("lspconfig").ruby_ls.setup({
            -- on_attach = config.on_attach
            -- capabilities = config.capabilities
            on_attach = function(client, buffer)
              ruby_lsp_config.setup_diagnostics(client, buffer)
              ruby_lsp_config.add_ruby_deps_command(client, buffer)
              vim.api.nvim_create_user_command("FormatRuby", function()
                vim.lsp.buf.format({
                  name = "ruby_lsp",
                  async = true,
                })
              end, {})
            end,
            -- default_config = {
            -- },
          })
        end,
      },
      sorbet = function()
        local ruby_lsp_config = require("plugins.extras.lang.ruby-lsp")
        local function sorbet_root_pattern(...)
          local patterns = { "sorbet/config" }
          return require("lspconfig.util").root_pattern(unpack(patterns))(...)
        end

        require("lspconfig").sorbet.setup({
          cmd = { "srb", "tc", "--lsp" },
          filetypes = { "ruby" },
          on_attach = ruby_lsp_config.on_attach,
          capabilities = ruby_lsp_config.capabilities,
          root_dir = function(fname)
            return sorbet_root_pattern(fname)
          end,
        })
      end,
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local lsp_util = require("util.lsp")
      lsp_util.add_linters(opts, {
        -- ["ruby"] = { "rubocop" },
        ["ruby"] = { "standardrb", "rubocop" },
      })

      -- opts.linters_by_ft.markdown = opts.linters_by_ft.markdown or {}
      -- table.insert(opts.linters_by_ft.markdown, "vale")
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      local lsp_util = require("util.lsp")
      lsp_util.add_formatters(opts, {
        ["ruby"] = { "rubyfmt" },
      })
    end,
  },
  -- enable if bundled rspec is needed
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "olimorris/neotest-rspec",
    },
    opts = {
      adapters = {
        ["neotest-rspec"] = {
          -- NOTE: By default neotest-rspec uses the system wide rspec gem instead of the one through bundler
          rspec_cmd = function()
            return vim.tbl_flatten({
              "bundle",
              "exec",
              "rspec",
            })
          end,
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

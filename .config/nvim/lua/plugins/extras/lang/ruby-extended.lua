return {
  { import = "lazyvim.plugins.extras.lang.ruby" },
  { "tpope/vim-rails", ft = "ruby" },
  { "tpope/vim-bundler", ft = "ruby" },
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
          vim.list_extend(opts.ensure_installed, { "rubocop" })
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
        -- nls.builtins.diagnostics.erb_lint,
        -- nls.builtins.diagnostics.reek,
        -- nls.builtins.formatting.erb_format, -- htmlbeautifier
      })
    end,
  },
  -- https://github.com/prdanelli/dotfiles/blob/main/neovim/lua/plugins/formatter.lua
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        sorbet = {},
        standardrb = {
          on_new_config = function(new_config)
            new_config.enabled = false
          end,
        },
        rubocop = {
          on_new_config = function(new_config)
            new_config.enabled = false
          end,
        },
        solargraph = {
          on_new_config = function(new_config)
            new_config.enabled = false
          end,
          --   enabled = false,
          --   diagnostics = false,
          --   formatting = false,
        },
        -- solargraph = {
        -- },
        ruby_lsp = {
          cmd = { "bundle", "exec", "ruby-lsp" },
          filetypes = { "ruby" },
          root_dir = require("lspconfig.util").root_pattern("Gemfile", ".git"),
          init_options = {
            enabledFeatures = {
              "documentHighlights",
              "documentSymbols",
              "foldingRanges",
              "selectionRanges",
              "semanticHighlighting",
              -- "formatting",
              "diagnostics",
              "signatureHelp",
              --
              "codeActions",
              "hover",
              -- "onTypeFormatting",
              "codeActionResolve",
              "inlayHints",
              "completion",
              "codeLens",
              "documentLink",
            },
            formatter = "rubocop",
          },
          settings = {},
          commands = {
            FormatRuby = {
              function()
                vim.lsp.buf.format({
                  name = "ruby_lsp",
                  async = true,
                })
              end,
              description = "Format using ruby-lsp",
            },
          },
        },
        -- yamlls = {
        --   settings = {
        --     yaml = {
        --       validate = true,
        --       schemaStore = {
        --         enable = true,
        --       },
        --     },
        --   },
        -- },
        yamlls = require("util.yamlls_config").get_yamlls_config(),
      },
      setup = {
        ruby_lsp = function(_, opts)
          local ruby_lsp_config = require("util.ruby-lsp")
          -- local config = require("lsp.config")
          require("lspconfig").ruby_lsp.setup({
            -- on_attach = config.on_attach
            -- capabilities = config.capabilities
            on_attach = function(client, buffer)
              ruby_lsp_config.on_attach(client, buffer)
              -- vim.api.nvim_create_user_command("FormatRuby", function()
              --   vim.lsp.buf.format({
              --     name = "ruby_lsp",
              --     async = true,
              --   })
              -- end, {})
            end,
          })

          -- local should_disable = function(root_dir, config)
          --   return true
          -- end
          -- LazyVim.lsp.disable("solargraph", should_disable)
          -- LazyVim.lsp.disable("rubocop", should_disable)
        end,
      },
      sorbet = function()
        -- https://github.com/arandilopez/doom-neovim/blob/50ee5c1bd4bfb0686157ecfe545596c22b2173f9/lua/lsp/ruby.lua#L20
        local sorbet_util = require("util.ruby.sorbet")
        local function sorbet_root_pattern(...)
          local patterns = { "sorbet/config" }
          return require("lspconfig.util").root_pattern(unpack(patterns))(...)
        end

        require("lspconfig").sorbet.setup({
          -- init_options = { documentFormatting = false, codeAction = true },
          -- cmd = {"srb", "tc", "--typed", "true", "--enable-all-experimental-lsp-features", "--lsp", "--disable-watchman",},
          -- cmd = sorbet_util.cmd(),
          cmd = { "srb", "tc", "--lsp" }, -- optionally "bundle" exec", "--disable-watchman"
          filetypes = { "ruby" },
          root_dir = function(fname)
            return sorbet_root_pattern(fname)
          end,
        })
      end,
    },
  },
  -- {
  --   "neovim/nvim-lspconfig",
  --   init = function() end,
  -- },
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
      automatic_installation = {
        exclude = { "solargraph" },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      local lsp_util = require("util.lsp")
      local gems_util = require("util.ruby.gems")
      if not gems_util.has_ruby_lsp() and gems_util.has_rubocop() then
        lsp_util.add_linters(opts, {
          ["ruby"] = { "rubocop" },
        })
      elseif gems_util.in_bundle("standard") then
        lsp_util.add_linters(opts, {
          ["ruby"] = { "standardrb" },
        })
      else
        -- lsp_util.add_linters(opts, {
        --   ["ruby"] = { "ruby" },
        -- })
      end
    end,
  },
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      local lsp_util = require("util.lsp")
      local gems_util = require("util.ruby.gems")
      -- Ruby-lsp has built-in Rubocop diagnostics, so check for ruby-lsp.
      if gems_util.has_rubocop() then
        lsp_util.add_formatters(opts, {
          ["ruby"] = { "rubocop" },
        })
      elseif gems_util.in_bundle("ruby-lsp-rubyfmt") then
        lsp_util.add_formatters(opts, {
          ["ruby"] = { "rubyfmt" },
        })
      end
    end,
  },
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
}

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
-- Use neotest instead
-- {
--   "weizheheng/ror.nvim",
--   config = function()
--     require("ror").setup({
--       test = {
--         message = {
--           -- These are the default title for nvim-notify
--           file = "Running test file...",
--           line = "Running single test...",
--         },
--         coverage = {
--           -- To customize replace with the hex color you want for the highlight
--           -- guibg=#354a39
--           up = "DiffAdd",
--           -- guibg=#4a3536
--           down = "DiffDelete",
--         },
--         notification = {
--           -- Using timeout false will replace the progress notification window
--           -- Otherwise, the progress and the result will be a different notification window
--           timeout = false,
--         },
--         pass_icon = "✅",
--         fail_icon = "❌",
--       },
--     })
--   end,
--   keys = {
--     { "<Leader>Rc", ":lua require('ror.commands').list_commands()<CR>" },
--   },
-- },

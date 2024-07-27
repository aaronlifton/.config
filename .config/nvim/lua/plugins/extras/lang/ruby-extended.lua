local lsp_util = require("util.lsp")
local gems_util = require("util.ruby.gems")
local system_util = require("util.system")

local ruby_lsp_path = function()
  vim.api.nvim_exec(":! type -p ruby-lsp", true)
end

return {
  { import = "lazyvim.plugins.extras.lang.ruby" },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "solargraph",
        "rubocop",
        "ruby-lsp",
        "cucumber-language-server",
        "sorbet",
      })
    end,
  },
  {
    "tpope/vim-rails",
    ft = "ruby",
    config = function()
      vim.g.rails_projections = {
        ["app/controllers/*_controller.rb"] = {
          test = {
            "spec/requests/{}_controller_spec.rb",
            "spec/controllers/{}_controller_spec.rb",
          },
        },
        ["spec/requests/*_spec.rb"] = {
          alternate = {
            "app/controllers/{}.rb",
          },
        },
        ["app/lib/*.rb"] = {
          test = "spec/lib/{}_spec.rb",
        },
        ["lib/tasks/*.rake"] = {
          test = {
            "spec/tasks/{dirname}/{basename}_spec.rb",
            "spec/tasks/{basename}_spec.rb",
          },
        },
        ["spec/tasks/*_spec.rb"] = {
          alternate = {
            "lib/tasks/{}.rake",
          },
        },
      }
    end,
  },
  { "tpope/vim-bundler", ft = "ruby" },
  {
    "nvimtools/none-ls.nvim",
    cond = function()
      return LazyVim.has_extra("lsp.none-ls")
    end,
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
        nls.builtins.diagnostics.erb_lint,
        nls.builtins.diagnostics.reek,
        nls.builtins.formatting.erb_format, -- htmlbeautifier
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        standardrb = {
          on_new_config = function(new_config)
            new_config.enabled = gems_util.in_bundle("standard")
          end,
        },
        -- rubocop = {
        --   on_new_config = function(new_config)
        --     new_config.enabled = not gems_util.has_ruby_lsp() and gems_util.has_rubocop()
        --   end,
        -- },
        sorbet = {
          -- init_options = { documentFormatting = false, codeAction = true },
          on_new_config = function(new_config)
            new_config.enabled = vim.fn.filereadable("sorbet/config") == 1
          end,
        },
        ruby_lsp = {
          -- cmd = { "bundle", "exec", "ruby-lsp" },
          cmd = { "/Users/" .. system_util.user() .. "/.asdf/shims/ruby-lsp" },
          filetypes = { "ruby" },
          root_dir = require("lspconfig.util").root_pattern("Gemfile", ".git"),
          -- init_options = {
          --   enabledFeatures = {
          --     "codeActions",
          --     -- "diagnostics",
          --     "documentHighlights",
          --     "documentLink",
          --     "documentSymbols",
          --     "foldingRanges",
          --     -- "formatting", -- needed for formatting
          --     "hover",
          --     "inlayHints",
          --     -- "onTypeFormatting",
          --     "selectionRanges",
          --     "semanticHighlighting",
          --     "completion",
          --     "codeLens",
          --     "definition",
          --     "workspaceSymbol",
          --     "signatureHelp",
          --     "typeHeirarchy",
          --   },
          --   -- when auto, formatter will detect formatter from bundle
          --   formatter = "auto",
          -- },
          settings = {
            rubyLsp = {
              bundleGemfile = ".lsp/Gemfile",
            },
          },
          on_new_config = function(new_config)
            -- if vim.g.lazyvim_ruby_lsp ~= "ruby_lsp" or not gems_util.has_ruby_lsp() then
            --   new_config.enabled = false
            -- end
            -- ruby-lsp-rubyfmt needs formatter to be set to rubyfmt
            -- https://github.com/jscharf/ruby-lsp-rubyfmt/blob/b28e16e9b847f70dc1ee2012296fda92cb30e7f5/README.md?plain=1#L41
            if gems_util.in_bundle("ruby-lsp-rubyfmt") then
              new_config.init_options.formatter = "rubyfmt"
            end
          end,
        },
        cucumber_language_server = {
          settings = {
            cucumber = {
              features = { "**/*.feature" },
              glue = { "step-definitions/**/*.js" },
            },
          },
        },
      },
      setup = {
        ruby_lsp = function(_, opts)
          local ruby_lsp_config = require("util.lsp.ruby")
          -- local config = require("lsp.config")
          require("lspconfig").ruby_lsp.setup(vim.tbl_extend("force", {
            -- on_attach = config.on_attach,
            on_attach = function(client, buffer)
              ruby_lsp_config.add_ruby_deps_command(client, buffer)
            end,
          }, opts))
        end,
        sorbet = function(_, opts)
          local function sorbet_root_pattern(...)
            local patterns = { "sorbet/config" }
            return require("lspconfig.util").root_pattern(unpack(patterns))(...)
          end

          require("lspconfig").sorbet.setup(vim.tbl_extend("force", {
            -- cmd = {"srb", "tc", "--typed", "true", "--enable-all-experimental-lsp-features", "--lsp", "--disable-watchman",},
            cmd = { "srb", "tc", "--lsp" }, -- optionally "bundle" exec", "--disable-watchman"
            filetypes = { "ruby" },
            root_dir = function(fname)
              return sorbet_root_pattern(fname)
            end,
          }, opts))
        end,
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        -- ruby = { "rubocop" }, -- already covered by LSP
        ruby = { "rubocop" },
        eruby = { "erb_lint" },
      },
      linters = {
        rubocop = {
          prepend_args = function()
            local hostname = require("util.system").hostname()
            if hostname == "ali-d7jf7y.local" then
              return {
                "-c",
                ".rubocop_ci.yml",
              }
            end
          end,
          -- prepend_args = {
          --   "-c",
          --   "rubocop_ci.yml",
          -- },
          condition = function(ctx)
            -- ruby-lsp already provides diagnostics from rubocop
            return gems_util.has_rubocop()
          end,
        },
        standardrb = {
          condition = function(ctx)
            return gems_util.in_bundle("standard")
          end,
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ruby = { "rubocop", "rubyfmt" },
        eruby = { "erb_format" },
      },
      formatters = {
        rubocop = {
          prepend_args = function()
            local hostname = require("util.system").hostname()
            if hostname == "ali-d7jf7y.local" then
              return {
                "-c",
                ".rubocop_ci.yml",
              }
            end
          end,
          condition = function(ctx)
            -- Ruby LSP contains rubocop diagnostics itself
            return gems_util.has_rubocop()
          end,
        },
        rubyfmt = {
          condition = function(ctx)
            return gems_util.in_bundle("ruby-lsp-rubyfmt")
          end,
        },
      },
    },
  },
  {
    "nvim-neotest/neotest",
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

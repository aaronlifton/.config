local lsp_util = require("util.lsp")
local gems_util = require("util.ruby.gems")
local has_sorbet_config = function()
  return vim.fn.filereadable("sorbet/config") == 1
end

return {
  { import = "lazyvim.plugins.extras.lang.ruby" },
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
      }
    end,
  },
  { "tpope/vim-bundler", ft = "ruby" },
  -- {
  --   "folke/which-key.nvim",
  --   opts = {
  --     defaults = {
  --       ["<leader>R"] = { name = "Rails" },
  --     },
  --   },
  -- },
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
        standardrb = {
          on_new_config = function(new_config)
            new_config.enabled = gems_util.in_bundle("standard")
          end,
        },
        rubocop = {
          on_new_config = function(new_config)
            new_config.enabled = not gems_util.has_ruby_lsp() and gems_util.has_rubocop()
          end,
        },
        solargraph = {
          on_new_config = function(new_config)
            new_config.enabled = not gems_util.has_ruby_lsp() -- and gems_util.in_bundle("solargraph")
          end,
          -- filetypes = { "eruby" },
          --   enabled = false,
          --   diagnostics = false,
          --   formatting = false,
        },
        sorbet = {
          on_new_config = function(new_config)
            new_config.enabled = has_sorbet_config()
          end,
        },
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
              "formatting", -- needed for formatting
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
            -- when auto, formatter will detect formatter from bundle
            formatter = "auto",
          },
          settings = {},
          on_new_config = function(new_config)
            -- ruby-lsp-rubyfmt needs formatter to be set to rubyfmt
            -- https://github.com/jscharf/ruby-lsp-rubyfmt/blob/b28e16e9b847f70dc1ee2012296fda92cb30e7f5/README.md?plain=1#L41
            if not gems_util.has_ruby_lsp() then
              new_config.enabled = false
            end
            -- if gems_util.has_rubocop() then
            --   new_config.init_options.formatter = "rubocop"
            if gems_util.in_bundle("ruby-lsp-rubyfmt") then
              new_config.init_options.formatter = "rubyfmt"
            end
            vim.api.nvim_echo({
              { "Ruby LSP formatter: " .. new_config.init_options.formatter },
              { "enabled: " .. tostring(new_config.enabled) },
            }, true, {})
          end,
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
            end,
          })
        end,
        sorbet = function()
          -- https://github.com/arandilopez/doom-neovim/blob/50ee5c1bd4bfb0686157ecfe545596c22b2173f9/lua/lsp/ruby.lua#L20
          -- local sorbet_util = require("util.ruby.sorbet")
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
    -- config = function(_, opts)
    --   local function inverse_sorbet_root_pattern(...)
    --     local patterns = { "sorbet/config" }
    --     return not require("lspconfig.util").root_pattern(unpack(patterns))(...)
    --   end
    --   if LazyVim.lsp.get_config("ruby_lsp") then
    --     LazyVim.lsp.disable("ruby_lsp", function()
    --       return not gems_util.has_ruby_lsp()
    --     end)
    --   end
    --   if LazyVim.lsp.get_config("rubocop") then
    --     LazyVim.lsp.disable("rubocop", function()
    --       return not gems_util.has_rubocop() or (gems_util.has_ruby_lsp() and gems_util.has_rubocop())
    --       -- return not gems_util.has_rubocop() or LazyVim.lsp.get_config("ruby_lsp"g
    --     end)
    --   end
    --
    --   if LazyVim.lsp.get_config("solargraph") then
    --     LazyVim.lsp.disable("solargraph", function()
    --       return not gems_util.in_bundle("solargraph")
    --     end)
    --   end
    --
    --   if LazyVim.lsp.get_config("standardrb") then
    --     LazyVim.lsp.disable("standardrb", function()
    --       return not gems_util.in_bundle("standard")
    --     end)
    --   end
    --
    --   if LazyVim.lsp.get_config("sorbet") then
    --     LazyVim.lsp.disable("sorbet", inverse_sorbet_root_pattern)
    --   end
    -- end,
  },
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        ruby = { "rubocop", "standardrb" },
        eruby = { "erb_lint" },
      },
      linters = {
        rubocop = {
          condition = function(ctx)
            -- return vim.fs.find({ ".rubocop.yml" }, { type = "file", path = ctx.filename, upward = true })[1]
            -- ruby-lsp already provides diagnostics from rubocop
            return not gems_util.has_ruby_lsp() and gems_util.has_rubocop()
          end,
        },
        standardrb = {
          condition = function(ctx)
            -- return vim.fs.find({ ".standard.yml" }, { type = "file", path = ctx.filename, upward = true })[1]
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
          condition = function(ctx)
            -- Ruby LSP contains rubocop diagnostics itself
            return not gems_util.has_ruby_lsp() and gems_util.has_rubocop()
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
    -- optional = true,
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
  --   "williamboman/mason-lspconfig.nvim",
  --   opts = {
  --     automatic_installation = {
  --       exclude = { "solargraph" },
  --     },
  --   },
  -- },
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

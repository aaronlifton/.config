-- local gems_util = require("util.ruby.gems")
local rubocop_provider = "rubocop" -- "ruby_lsp"
local add_ruby_deps_command = false

-- https://github.com/Shopify/ruby-lsp/blob/4f7ce060de3257c35028ccb70e1854da952cdb95/vscode/package.json#L231
local enabledFeatures = {
  "codeActions",
  -- "diagnostics", -- doesn't support custom Rubocop config
  "documentHighlights",
  "documentLink",
  "documentSymbols",
  "foldingRanges",
  -- "formatting", -- doesn't support custom Rubocop config
  "hover",
  "inlayHint",
  -- "onTypeFormatting",
  "selectionRanges",
  "semanticHighlighting",
  "completion",
  "codeLens",
  "definition",
  "workspaceSymbol",
  "signatureHelp",
  "typeHierarchy",
}

if rubocop_provider == "ruby_lsp" then
  vim.list_extend(enabledFeatures, {
    "diagnostics",
    "formatting",
    -- "onTypeFormatting",
  })
end

return {
  { import = "lazyvim.plugins.extras.lang.ruby" },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "solargraph",
        "rubocop",
        "ruby-lsp",
        "cucumber-language-server",
        "sorbet",
      },
    },
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
            new_config.enabled = require("util.ruby.gems").in_bundle("standard")
          end,
        },
        rubocop = {
          enabled = rubocop_provider ~= "ruby_lsp",
        },
        sorbet = {
          -- init_options = { documentFormatting = false, codeAction = true },
          on_new_config = function(new_config)
            new_config.enabled = vim.fn.filereadable("sorbet/config") == 1
          end,
        },
        ruby_lsp = {
          init_options = {
            enabledFeatures = enabledFeatures,
          },
          settings = {
            rubyLsp = {
              bundleGemfile = ".lsp/Gemfile",
            },
          },
          on_new_config = function(new_config)
            -- ruby-lsp-rubyfmt needs formatter to be set to rubyfmt
            -- https://github.com/jscharf/ruby-lsp-rubyfmt/blob/b28e16e9b847f70dc1ee2012296fda92cb30e7f5/README.md?plain=1#L41
            if require("util.ruby.gems").in_bundle("ruby-lsp-rubyfmt") then
              new_config.init_options.formatter = "rubyfmt"
            end
          end,
          on_attach = function(client, buffer)
            if add_ruby_deps_command then require("util.lsp.ruby").add_ruby_deps_command(client, buffer) end
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
        sorbet = function(_, opts)
          local function sorbet_root_pattern(...)
            local patterns = { "sorbet/config" }
            return require("lspconfig.util").root_pattern(unpack(patterns))(...)
          end

          require("lspconfig").sorbet.setup(vim.tbl_extend("force", {
            -- cmd = {"srb", "tc", "--typed", "true", "--enable-all-experimental-lsp-features", "--lsp", "--disable-watchman",},
            cmd = { "srb", "tc", "--lsp" }, -- optionally "bundle", "exec", "--disable-watchman"
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
    optional = true,
    opts = {
      linters_by_ft = {
        ruby = { "rubocop" },
        eruby = { "erb_lint" },
      },
      linters = {
        rubocop = {
          -- cmd = "bundle",
          -- args = {
          --   "exec",
          --   "rubocop",
          --   "--format",
          --   "json",
          --   "--force-exclusion",
          --   "--server",
          --   "--stdin",
          --   function()
          --     return vim.api.nvim_buf_get_name(0)
          --   end,
          -- },
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
            return require("util.ruby.gems").has_rubocop()
          end,
        },
        standardrb = {
          condition = function(ctx)
            return require("util.ruby.gems").in_bundle("standard")
          end,
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        ruby = { "rubocop", "rubyfmt", stop_after_first = true },
        eruby = { "erb_format" },
      },
      formatters = {
        rubocop = {
          -- command = "bundle",
          -- args = {
          --   "exec",
          --   "rubocop",
          --   "--server",
          --   "-a",
          --   "-f",
          --   "quiet",
          --   "--stderr",
          --   "--stdin",
          --   "$FILENAME",
          -- },
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
            return require("util.ruby.gems").has_rubocop()
          end,
        },
        rubyfmt = {
          condition = function(ctx)
            return require("util.ruby.gems").in_bundle("ruby-lsp-rubyfmt")
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

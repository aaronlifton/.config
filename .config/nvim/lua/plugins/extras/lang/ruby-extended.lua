LazyVim.on_very_lazy(function()
  vim.filetype.add({
    yml = "yaml",
  })
  vim.treesitter.language.register("yaml", "yml")
end)

local has_rubocop_config = function()
  local buf = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(buf)
  return vim.fs.find(".rubocop.yml", { path = filename, upward = true })
end

local use_rubyfmt = true
local use_ruby_lsp_rubocop = true
local add_ruby_deps_command = false

-- https://github.com/Shopify/ruby-lsp/blob/4f7ce060de3257c35028ccb70e1854da952cdb95/vscode/package.json#L231
local enabledFeatures = {
  "codeActions",
  -- "codeLens", -- adds "Run/Debug Test" lenses and ruby-lsp-rails "Go to Controller Action Route"
  "completion",
  "definition",
  -- "diagnostics", -- doesn't support custom Rubocop config
  "documentHighlights",
  "documentLink",
  "documentSymbols",
  "foldingRanges",
  -- "formatting", -- doesn't support custom Rubocop config
  "hover",
  "inlayHint",
  -- "onTypeFormatting", -- replacement for endwise
  "selectionRanges",
  "semanticHighlighting",
  "signatureHelp",
  "typeHierarchy",
  "workspaceSymbol",
}
local excludedGems = {
  "libv8-node",
  "google-api-client",
  "grpc",
  "mini_racer",
  "nokogiri",
  "brakeman",
  "rbtrace",
  "faker",
  "aws-sdk-s3",
  "google-protobuf",
  "google-cloud-pubsub",
  "rubocop",
  "google-iam",
  "caxlsx",
  "rubycritic",
  "rubocop-ast",
  "rubocop-capybara",
  "rubocop-faker",
  "rubocop-performance",
  "rubocop-rails",
  "rubocop-rake",
  "rubocop-rspec",
  "rubocop-thread_safety",
}
if use_ruby_lsp_rubocop then
  -- Without these 2 features, the initialization options 'linters' and
  -- 'formatters' are ignored.
  vim.list_extend(enabledFeatures, {
    "diagnostics",
    -- "formatting",
    -- "onTypeFormatting",
  })
end

return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "solargraph",
        "rubocop",
        "cucumber-language-server",
        "sorbet",
      },
    },
  },
  { "tpope/vim-endwise", ft = "ruby" },
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
          -- Added
          alternate = {
            "spec/requests/{}_spec.rb",
            "spec/requests/{}_request_spec.rb",
            "spec/requests/{}_controller_spec.rb",
            "spec/{}_controller_spec.rb",
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
        -- Added
        ["app/*.rb"] = {
          alternate = "spec/{}_spec.rb",
        },
        ["spec/*_spec.rb"] = {
          alternate = "app/{}.rb",
        },
        ["spec/requests/*_spec.rb"] = {
          alternate = { "app/controllers/{}_controller.rb", "app/controllers/{}.rb" },
        },
        ["spec/requests/*_request_spec.rb"] = {
          alternate = { "app/controllers/{}_controller.rb", "app/controllers/{}.rb" },
        },
      }
    end,
  },
  { "tpope/vim-bundler", ft = "ruby" },
  {
    "neovim/nvim-lspconfig",
    optional = true,
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        ruby_lsp = {
          init_options = {
            -- bundleGemfile = ".ruby-lsp/Gemfile",
            formatter = "rubyfmt",
          },
          -- useBundler = true,
          -- mason = false,
          -- cmd = { "bundle", "exec", "ruby-lsp" },
          -- cmd = { "/Users/alifton/.asdf/installs/ruby/3.3.2/lib/ruby/gems/3.3.0/gems/ruby-lsp-0.22.1/exe/ruby-lsp-launcher", },
          -- cmd = { "/Users/alifton/.asdf/installs/ruby/3.3.2/bin/ruby-lsp" },
          -- cmd = { vim.fn.expand("~/.local/share/mise/installs/ruby/3.4.8/bin/ruby-lsp ") },
          -- flags = {
          --   debounce_text_changes = 150,
          -- },
          -- -- NOTE: https://shopify.github.io/ruby-lsp/editors.html#all-initialization-options
          -- init_options = {
          --   enabledFeatures = enabledFeatures,
          --   experimentalFeaturesEnabled = true,
          --   -- featuresConfiguration = {
          --   --   inlayHints = {
          --   --     implicitHashValue = true,
          --   --     implicitRescue = true,
          --   --   },
          --   -- },
          --   -- https://github.com/search?q=path%3A**%2Fnvim%2F**%2F*.lua+excludedGems&type=code
          --   -- indexing = {
          --   --   -- __mocks__/
          --   --   -- app/
          --   --   -- config/
          --   --   -- db/
          --   --   -- git_hooks/
          --   --   -- k8s/
          --   --   -- lib/
          --   --   -- log/
          --   --   -- public/
          --   --   -- script/
          --   --   -- spec/
          --   --   -- swagger/
          --   --   -- test/
          --   --   -- tmp/
          --   --   -- vendor/
          --   --   -- includedPatterns = { "**/bin/**/*" },,
          --   --   excludedPatterns = {
          --   --     -- "**/test/**/*.rb",
          --   --     -- "**/spec/**/*.rb",
          --   --     -- "**/db/**/*.rb",
          --   --     -- "**/vendor/**/*.rb",
          --   --     -- "**/activerecord-*/examples/**/*.rb",
          --   --     --
          --   --     "__mocks__/**",
          --   --     -- "app/**",
          --   --     "config/**",
          --   --     "db/**",
          --   --     "git_hooks/**",
          --   --     "k8s/**",
          --   --     "lib/**",
          --   --     "log/**",
          --   --     "public/**",
          --   --     "script/**",
          --   --     -- "spec/**",
          --   --     -- Spec sub-folders
          --   --     "spec/controllers/**",
          --   --     "spec/db/**",
          --   --     "spec/decorators/**",
          --   --     "spec/deprecations/**",
          --   --     "spec/emails/**",
          --   --     "spec/factories/**",
          --   --     "spec/fixtures/**",
          --   --     "spec/helpers/**",
          --   --     "spec/http_services/**",
          --   --     "spec/integration/**",
          --   --     "spec/legacy_policies/**",
          --   --     "spec/lib/**",
          --   --     "spec/mailers/**",
          --   --     "spec/models/**",
          --   --     "spec/modules/**",
          --   --     "spec/policies/**",
          --   --     "spec/presenters/**",
          --   --     "spec/queries/**",
          --   --     "spec/resources/**",
          --   --     "spec/routes/**",
          --   --     "spec/services/**",
          --   --     "spec/shared_contexts/**",
          --   --     "spec/support/**",
          --   --     "spec/tasks/**",
          --   --     "spec/validators/**",
          --   --     "spec/values/**",
          --   --     "spec/vendor/**",
          --   --     "spec/vendors/**",
          --   --     "spec/workers/**",
          --   --     -- /Spec sub-folders
          --   --     "swagger/**",
          --   --     "test/**",
          --   --     "tmp/**",
          --   --     "vendor/**",
          --   --     -- App
          --   --     "app/assets/**",
          --   --     -- "app/controllers/**",
          --   --     "app/decorators/**",
          --   --     "app/emails/**",
          --   --     "app/helpers/**",
          --   --     "app/http_services/**",
          --   --     "app/jobs/**",
          --   --     "app/legacy_policies/**",
          --   --     -- "app/lib/**",
          --   --     "app/mailers/**",
          --   --     -- "app/models/**",
          --   --     -- "app/policies/**",
          --   --     -- "app/presenters/**",
          --   --     -- "app/queries/**",
          --   --     -- "app/services/**",
          --   --     -- "app/values/**",
          --   --     -- "app/views/**",
          --   --     -- "app/workers/**"
          --   --   },
          --   --   excludedGems = excludedGems,
          --   --   -- excludedMagicComments = { "compiled:true" },
          --   -- },
          --   -- bundleGemfile = ".ruby-lsp/Gemfile",
          --   linters = use_ruby_lsp_rubocop and { "rubocop" } or {},
          -- },
          -- on_new_config = function(new_config)
          --   -- ruby-lsp-rubyfmt needs formatter to be set to rubyfmt
          --   -- https://github.com/jscharf/ruby-lsp-rubyfmt/blob/b28e16e9b847f70dc1ee2012296fda92cb30e7f5/README.md?plain=1#L41
          --   if require("util.ruby.gems").in_bundle("ruby-lsp-rubyfmt") then
          --     new_config.init_options.formatter = "rubyfmt"
          --   end
          -- end,
          -- on_attach = function(client, buffer)
          --   if add_ruby_deps_command then require("util.lsp.ruby").add_ruby_deps_command(client, buffer) end
          -- end,
        },
        solargraph = {
          enabled = false,
          on_new_config = function(new_config)
            new_config.enabled = not require("util.ruby.gems").in_bundle("ruby-lsp")
          end,
        },
        rubocop = {
          -- NOTE: already disabled in LazyVim/lua/lazyvim/plugins/extras/lang/ruby.lua
          -- Disabled since rubocop diagnostics come from either ruby-lsp or nvim-lint
          enabled = false,
        },
        standardrb = {
          enabled = false,
          on_new_config = function(new_config)
            new_config.enabled = require("util.ruby.gems").in_bundle("standard")
          end,
        },
        sorbet = {
          enabled = false,
          -- init_options = { documentFormatting = false, codeAction = true },
          on_new_config = function(new_config)
            new_config.enabled = vim.fn.filereadable("sorbet/config") == 1
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
      -- setup = {
      --   sorbet = function(_, opts)
      --     local function sorbet_root_pattern(...)
      --       local patterns = { "sorbet/config" }
      --       return require("lspconfig.util").root_pattern(unpack(patterns))(...)
      --     end
      --
      --     require("lspconfig").sorbet.setup(vim.tbl_extend("force", {
      --       -- cmd = {"srb", "tc", "--typed", "true", "--enable-all-experimental-lsp-features", "--lsp", "--disable-watchman",},
      --       cmd = { "srb", "tc", "--lsp" }, -- optionally "bundle", "exec", "--disable-watchman"
      --       filetypes = { "ruby" },
      --       root_dir = function(fname)
      --         return sorbet_root_pattern(fname)
      --       end,
      --     }, opts))
      --   end,
      -- },
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
          -- prepend_args = function()
          --   local hostname = require("util.system").hostname()
          --   if hostname == "ali-d7jf7y.local" then
          --     return {
          --       "-c",
          --       ".rubocop_ci.yml",
          --     }
          --   end
          -- end,
          condition = function(ctx)
            return not use_ruby_lsp_rubocop and require("util.ruby.gems").has_rubocop()
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
        --- ruby /Users/$USER/.local/share/nvim/mason/packages/rubocop/bin/rubocop -c .rubocop_ci.yml --force-exclusion --server -a -f quiet --stderr --stdin $path
        rubocop = {
          -- Bundle version (1.50.2 does not work with nvim)
          -- command = "bundle",
          -- args = {
          --   "exec",
          --   "rubocop",
          --   "-c",
          --   ".rubocop_ci.yml",
          --   "--force-exclusion",
          --   "--server",
          --   "-a",
          --   "-f",
          --   "quiet",
          --   "--stderr",
          --   "--stdin",
          --   "$FILENAME",
          -- },
          --
          prepend_args = function()
            local hostname = require("util.system").hostname()
            if hostname == "ali-d7jf7y.local" then
              return {
                "-c",
                ".rubocop_ci.yml",
                "--force-exclusion",
                -- "-A"
              }
            end
          end,
          condition = function(ctx)
            -- Determine if buffer has ruby-lsp:
            -- local lsp_clients =
            --   require("conform.lsp_format").get_format_clients({ bufnr = vim.api.nvim_get_current_buf() })
            -- local has_lsp_formatter = not vim.tbl_isempty(lsp_clients)

            -- Ruby LSP contains rubocop diagnostics itself
            return vim.b.disable_lsp_format
              or (not use_ruby_lsp_rubocop and not use_rubyfmt and require("util.ruby.gems").has_rubocop())
          end,
        },
        rubyfmt = {
          condition = function(ctx)
            return use_rubyfmt and require("util.ruby.gems").in_bundle("ruby-lsp-rubyfmt")
            -- or not vim.fs.find(".rubocop.yml", { path = ctx.filename, upward = true })
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
    ops = {
      adapters = {
        ["neotest-rspec"] = {
          -- NOTE: By default neotest-rspec uses the system wide rspec gem instead of the one through bundler
          rspec_cmd = function()
            return vim
              .iter({
                "bundle",
                "exec",
                "rspec",
              })
              :flatten()
              :totable()
          end,
        },
      },
    },
  },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "ruby-3.3",
        "ruby-3.4",
        "rails-7.0",
        "rails-7.1",
        "rails-7.2",
        "rails-8.0",
      },
    },
  },
}

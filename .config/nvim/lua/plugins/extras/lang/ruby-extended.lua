LazyVim.on_very_lazy(function()
  vim.filetype.add({
    yml = "yaml",
  })
  vim.treesitter.language.register("yaml", "yml")
end)

local use_ruby_lsp_rubocop = true
---@diagnostic disable-next-line: unused-local
local add_ruby_deps_command = false
local lsp = vim.g.lazyvim_ruby_lsp or "ruby_lsp"
local formatter = vim.g.lazyvim_ruby_formatter or "rubocop"
local ruby_lsp_cmd = vim.g.work and { "ruby-lsp" } or { "mise", "x", "--", "ruby-lsp" }

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
      ---@type table<string, lazyvim.lsp.Config|boolean>
      servers = {
        ruby_lsp = {
          enabled = lsp == "ruby_lsp",
          mason = false,
          -- cmd = { "mise", "exec", "--", "bundle", "exec", "ruby-lsp" },
          -- cmd = { "mise", "exec", "--", "ruby-lsp" },
          cmd = ruby_lsp_cmd,
          -- bundleGemfile = ".ruby-lsp/Gemfile",
          experimentalFeaturesEnabled = false,
          -- https://shopify.github.io/ruby-lsp/editors.html#all-initialization-options
          init_options = {
            -- formatter = "rubyfmt",
            -- https://github.com/search?q=path%3A**%2Fnvim%2F**%2F*.lua+excludedGems&type=code
            excludedPatterns = {
              "**/db/*",
              "**/server/app/models/utilities/schema.rb",
            },
            addonSettings = {
              ["Ruby LSP Rails"] = {
                enablePendingMigrationsPrompt = false,
              },
            },
          },
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
          enabled = lsp == "solargraph",
          -- on_new_config = function(new_config)
          --   new_config.enabled = not require("util.ruby.gems").in_bundle("ruby-lsp")
          -- end,
        },
        -- NOTE: prefer configuration from LazyVim
        -- NOTE: Need to re-disable since this config overrides LazyVim/lua/lazyvim/plugins/extras/lang/ruby.lua
        rubocop = {
          -- Disabled since rubocop diagnostics come from either ruby-lsp or nvim-lint
          enabled = formatter == "rubocop" and lsp ~= "solargraph",
          on_new_config = function(new_config)
            -- If rubocop is in the Gemfile, it will be used as the formatter for ruby-lsp
            new_config.enabled = not vim.g.work and require("util.ruby.gems").in_bundle("rubocop")
          end,
        },
        standardrb = {
          enabled = formatter == "standardrb",
          on_new_config = function(new_config)
            -- If standard is in the Gemfile, it will be used as the formatter for ruby-lsp
            new_config.enabled = not vim.g.work and require("util.ruby.gems").in_bundle("standard")
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
        -- NOTE: prefer Rubocop LSP
        -- ruby = { "rubocop" },
        eruby = { "erb_lint" },
      },
      linters = {
        -- rubocop = {
        --   condition = function(ctx)
        --     return not use_ruby_lsp_rubocop and require("util.ruby.gems").has_rubocop()
        --   end,
        -- },
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
          condition = function(ctx)
            -- Determine if buffer has ruby-lsp:
            -- local lsp_clients =
            --   require("conform.lsp_format").get_format_clients({ bufnr = vim.api.nvim_get_current_buf() })
            -- local has_lsp_formatter = not vim.tbl_isempty(lsp_clients)

            -- Ruby LSP contains rubocop diagnostics itself
            return not use_ruby_lsp_rubocop and require("util.ruby.gems").has_rubocop()
          end,
        },
        rubyfmt = {
          condition = function(ctx)
            return false
            -- return require("util.ruby.gems").in_bundle("ruby-lsp-rubyfmt")
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

-- TODO: https://github.com/ngalaiko/tree-sitter-go-template
--
local use_golangci_lint_lsp = true
local use_golang_ci_lintv1 = true

return {
  { import = "lazyvim.plugins.extras.lang.go" },
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- "golangci-lint", -- Installed v1 locally
        "golangci-lint-langserver",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- https://github.com/nametake/golangci-lint-langserver/issues/60
        -- https://github.com/nvimtools/none-ls.nvim/commit/2f6a433e62d0fab6a03dadf2c207fcbe409416c4
        golangci_lint_ls = {
          init_options = use_golang_ci_lintv1
              and {
                -- nvim-lspconfig @ b542bd594a8b9ab76926721e9815ec4b0b1b3c16
                command = { "golangci-lint", "run", "--out-format", "json" },
                -- command = { "golangci-lint", "run", "--out-format=json", "--show-stats=false" },
              }
            or {},
        },
        gopls = {
          settings = {
            -- https://github.com/golang/tools/blob/master/gopls/doc/settings.md
            gopls = {
              analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
                fieldalignment = true,
              },
              gofumpt = false,
              buildFlags = { "-tags", "integration,unit,build" },
              staticcheck = true,
              directoryFilters = {
                -- "-vendor",
                "-.git",
                "-.github",
                "-.vscode",
                "-.cursor",
                "-.idea",
                "-.jira",
                "-.vscode-test",
                "-node_modules",
              },
            },
          },
        },
      },
    },
  },
  {
    "mfussenegger/nvim-lint",
    cond = not use_golangci_lint_lsp,
    opts = function(_, opts)
      Util.lint.add_linters({
        ["go"] = { "golangcilint" },
        ["gomod"] = { "golangcilint" },
        ["gowork"] = { "golangcilint" },
      })

      return opts
    end,
  },
  {
    "hexdigest/go-enhanced-treesitter.nvim",
    build = ":TSInstall go sql",
    ft = "go",
  },
  {
    "olexsmir/gopher.nvim",
    ft = "go",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      { "williamboman/mason.nvim", optional = true }, -- by default use Mason for go dependencies
      {
        "folke/which-key.nvim",
        opts = {
          spec = {
            mode = "n",
            { "<leader>cg", group = "gopher", icon = { icon = " " } }, --    󰟓
          },
        },
      },
    },
    -- branch = "develop"
    -- (optional) will update plugin's deps on every update
    build = function()
      -- vim.cmd.GoInstallDeps()
      if not require("lazy.core.config").spec.plugins["mason.nvim"] then
        vim.print("Installing go dependencies...")
        vim.cmd.GoInstallDeps()
        vim.fn.system("go install github.com/koron/iferr@latest")
      end
    end,
    -- Config for gopher.nvim
    opts = {},
    config = function()
      -- This ensures the plugin is only configured for Go files
      local gopher = require("gopher")
      gopher.setup({})

      -- Create keymaps only for Go files
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "go",
        callback = function()
          -- Generate test for function under cursor
          vim.keymap.set(
            "n",
            "<leader>cgx",
            "<cmd>GoTestAdd<cr>",
            { buffer = true, desc = "Generate test for function under cursor" }
          )
          -- Generate test for current file
          vim.keymap.set(
            "n",
            "<leader>cgT",
            "<cmd>GoTestsAll<cr>",
            { buffer = true, desc = "Generate test for current file" }
          )
          -- Generate tests for exported functions
          vim.keymap.set(
            "n",
            "<leader>cgE",
            "<cmd>GoTestsExp<cr>",
            { buffer = true, desc = "Generate tests for exported functions" }
          )
          -- Add struct tags (json, yaml, etc)
          vim.keymap.set("n", "<leader>cga", "<cmd>GoTagAdd<cr>", { buffer = true, desc = "Add struct tags" })
          -- Remove struct tags
          vim.keymap.set("n", "<leader>cgr", "<cmd>GoTagRm<cr>", { buffer = true, desc = "Remove struct tags" })
          -- Generate if err != nil check
          vim.keymap.set(
            "n",
            "<leader>cge",
            "<cmd>GoIfErr<cr>",
            { buffer = true, desc = "Generate if err != nil check" }
          )
          -- Generate function implementation
          vim.keymap.set(
            "n",
            "<leader>cgf",
            "<cmd>GoImpl<cr>",
            { buffer = true, desc = "Generate function implementation" }
          )
          -- Generate interface stubs
          vim.keymap.set("n", "<leader>cgs", "<cmd>GoImpl<cr>", { buffer = true, desc = "Generate interface stubs" })
          -- Add imports
          vim.keymap.set("n", "<leader>cgp", "<cmd>GoGet<cr>", { buffer = true, desc = "Add imports" })
          -- Generate doc comments
          vim.keymap.set("n", "<leader>cgc", "<cmd>GoCmt<cr>", { buffer = true, desc = "Generate doc comments" })
          -- Run go mod tidy
          vim.keymap.set("n", "<leader>cgm", "<cmd>GoMod tidy<cr>", { buffer = true, desc = "Run go mod tidy" })
          -- Run go generate
          vim.keymap.set("n", "<leader>cgG", "<cmd>GoGenerate<cr>", { buffer = true, desc = "Run go generate" })
          -- Run go generate for current file
          vim.keymap.set(
            "n",
            "<leader>cgg",
            "<cmd>GoGenerate %<cr>",
            { buffer = true, desc = "Run go generate for current file" }
          )
        end,
      })
    end,
  },
  -- {
  --   "nvim-neotest/neotest",
  --   dependencies = {
  --     "nvim-contrib/nvim-ginkgo",
  --   },
  --   opts = {
  --     adapters = {
  --       ["nvim-ginkgo"] = {},
  --     },
  --   },
  -- },
  --
  -- LazyVim sets this as { "goimports", "gofumpt" }
  -- {
  --   "stevearc/conform.nvim",
  --   opts = {
  --     formatters_by_ft = {
  --       go = { "gofmt" },
  --     },
  --   },
  -- },
  {
    "luckasRanarison/nvim-devdocs",
    optional = true,
    opts = {
      ensure_installed = {
        "go",
      },
    },
  },
  {
    "ray-x/go.nvim",
    enabled = false,
    dependencies = {
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {},
    ft = { "go", "gomod" },
    build = function()
      require("go.install").update_all_sync()
      require("go").setup({
        lsp_keymaps = false,
        dap_debug_keymap = false,
        icons = false,
        gofmt = "gopls",
        goimports = "gopls",
        lsp_gofumpt = "false",
        lup_inlay_hints = { enable = false },
        lsp_codelens = { enable = false },
        run_in_floaterm = true,
        trouble = true,
        lsp_cfg = {
          flags = { debounce_text_changes = 500 },
          cmd = { "gopls", "-remote=auto" },
          settings = {
            gopls = {
              gofumpt = true,
              codelenses = {
                gc_details = false,
                generate = true,
                regenerate_cgo = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
              analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
              },
              usePlaceholders = true,
              completeUnimported = true,
              staticcheck = true,
              directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
              semanticTokens = true,
            },
          },
        },
      })
    end,
  },
  {
    "maxandron/goplements.nvim",
    ft = "go",
    cmd = {
      "GoplementEnable",
      "GoplementDisable",
      "GoplementToggle",
      -- Also available as Lua functions
      -- require("goplements").enable()
      -- require("goplements").disable()
      -- require("goplements").toggle()
    },
    opts = {
      -- Defaults
      prefix = {
        interface = "implemented by: ",
        struct = "implements: ",
      },
      -- Whether to display the package name along with the type name (i.e., builtins.error vs error)
      display_package = false,
      -- The namespace to use for the extmarks (no real reason to change this except for testing)
      namespace_name = "goplements",
      -- The highlight group to use (if you want to change the default colors)
      -- The default links to DiagnosticHint
      highlight = "Goplements",
    },
  },
  {
    -- https://github.com/fredrikaverpil/godoc.nvim
    "fredrikaverpil/godoc.nvim",
    version = "*",
    dependencies = {
      -- { "nvim-telescope/telescope.nvim" }, -- optional
      -- { "folke/snacks.nvim" }, -- optional
      -- { "echasnovski/mini.pick" }, -- optional
      { "ibhagwan/fzf-lua" }, -- optional
      {
        "nvim-treesitter/nvim-treesitter",
        opts = {
          ensure_installed = { "go" },
        },
      },
    },
    build = "go install github.com/lotusirous/gostdsym/stdsym@latest", -- optional
    cmd = { "GoDoc" }, -- optional
    opts = {}, -- see further down below for configuration
  },
  -- {
  --   "yanskun/gotests.nvim",
  --   ft = "go",
  --   config = function()
  --     require("gotests").setup()
  --   end,
  -- },
  -- {
  --   "romus204/go-tagger.nvim",
  --   cmd = { "AddGoTags", "RemoveGoTags" },
  --   config = function()
  --     require("go_tagger").setup({
  --       skip_private = true, -- Skip unexported fields (starting with lowercase)
  --     })
  --     -- TODO: convert to keymaps
  --     vim.keymap.set("v", "<leader>at", ":AddGoTags<CR>", { desc = "Add Go struct tags", silent = true })
  --     vim.keymap.set("v", "<leader>rt", ":RemoveGoTags<CR>", { desc = "Remove Go struct tags", silent = true })
  --   end,
  -- },
}

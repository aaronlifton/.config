return {
  -- {
  --   "williamboman/mason.nvim",
  --   -- dependencies = {
  --   --   "zapling/mason-lock.nvim",
  --   --   cmd = { "MasonLock", "MasonLockRestore" },
  --   --   opts = {},
  --   -- },
  --   opts = {
  --     ensure_installed = {
  --       -- Go
  --       -- "go-debug-adapter",
  --       "gofumpt",
  --       "goimports",
  --       "goimports-reviser",
  --       "golangci-lint",
  --       "golangci-lint-langserver",
  --       "golines",
  --       "gomodifytags",
  --       "gopls",
  --       "gotests",
  --       "gotestsum",
  --       -- Markdown
  --       "markdownlint",
  --       "markdownlint-cli2",
  --       "mdformat",
  --       -- Lua
  --       "lua-language-server",
  --       "stylua",
  --       -- TODO: configure selene
  --       -- "selene",
  --       -- Web
  --       "prettier",
  --       "eslint-lsp",
  --       "biome",
  --       "dprint",
  --       -- Ruby
  --       "rubocop",
  --       "ruby-lsp",
  --       "rubyfmt",
  --       "solargraph",
  --       "sorbet",
  --       -- Shell
  --       "shellcheck",
  --       "shfmt",
  --     },
  --     ui = {
  --       border = "rounded",
  --       icons = {
  --         package_installed = "✓",
  --         package_pending = "➜",
  --         package_uninstalled = "✗",
  --       },
  --     },
  --   },
  --   keys = {
  --     { "<leader>cm", false },
  --     { "<leader>cim", "<cmd>Mason<cr>", desc = "Mason" },
  --   },
  --   config = function(_, opts)
  --     -- Replacement for mason-tools-installer
  --     vim.api.nvim_create_user_command("MasonInstallAll", function()
  --       local packages = table.concat(opts.ensure_installed, " ")
  --       vim.cmd("MasonInstall " .. packages)
  --     end, {})
  --   end,
  -- },
  -- {
  --   "WhoIsSethDaniel/mason-tool-installer.nvim",
  --   after = "mason.nvim",
  --   cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
  --   opts = {
  --     ensure_installed = {
  --       "astro-language-server", -- astro
  --       "biome",
  --       "cbfmt",
  --       "chrome-debug-adapter",
  --       "commitlint",
  --       "cspell",
  --       "css-lsp", -- csslss
  --       "css-variables-language-server",
  --       "cssmodules-language-server", -- cssmodules_ls
  --       "deno", -- denols
  --       "docker-compose-language-service", -- docker_compose_language_service
  --       "dockerfile-language-server", -- dockerls
  --       "dprint",
  --       "elixir-ls",
  --       "emmet-language-server",
  --       "emmet-ls",
  --       "eslint-lsp",
  --       "eslint_d",
  --       -- "fennel-language-server",
  --       "fixjson",
  --       "go-debug-adapter",
  --       "gofumpt",
  --       "goimports",
  --       "goimports-reviser",
  --       "golangci-lint",
  --       "golangci-lint-langserver", -- golangci_lint_ls
  --       "golines",
  --       "gomodifytags",
  --       "gopls",
  --       "gotests",
  --       "gotestsum",
  --       "graphql-language-service-cli", -- graphql
  --       "hadolint",
  --       "html-lsp", -- html
  --       "htmx-lsp", -- htmx
  --       "impl", -- go (none-ls)
  --       "jq",
  --       "js-debug-adapter",
  --       "json-lsp", -- jsonls
  --       "lua-language-server", -- lua_ls
  --       "luacheck",
  --       "markdown-toc",
  --       "markdownlint-cli2",
  --       "node-debug2-adapter",
  --       "oxlint",
  --       "prettier",
  --       "prettierd",
  --       "prisma-language-server",
  --       "revive", -- drop in replacement for golint
  --       "ripper-tags",
  --       "rstcheck",
  --       "rubocop",
  --       "rubocop",
  --       "ruby-lsp",
  --       "rubyfmt",
  --       "rust-analyzer",
  --       "rustywind",
  --       "selene",
  --       "shellcheck",
  --       "shfmt",
  --       "solargraph",
  --       "sorbet",
  --       "sourcery",
  --       "sqlls",
  --       "standardjs",
  --       "standardrb",
  --       "staticcheck", -- golang
  --       "stylelint",
  --       "stylua",
  --       "svelte-language-server",
  --       "tailwindcss-language-server", -- tailwindcss
  --       "taplo",
  --       "terraform-ls", -- terraformls,
  --       -- "typescript-language-server", --tsserver
  --       "vtsls"
  --       "typos",
  --       "vim-language-server", -- vimls
  --       "yaml-language-server", -- yamlls
  --       "yamllint", -- install via pip (or brew)
  --       "zls",
  --       "zprint",
  --       -- "angular-language-server", -- angularls
  --       -- "ansible-language-server", -- ansiblels
  --       -- "autotools-language-server", -- autotools_ls
  --       -- "bash-debug-adapter",
  --       -- "bash-debug-adapter",
  --       -- "bash-language-server",
  --       -- "bash-language-server", -- bashls
  --       -- "buf-language-server", -- bufls
  --       -- "clangd",
  --       -- "clojure-lsp", -- clojure_lsp
  --       -- "cmake-language-server", --cmake -- cmake works with none-ls
  --       -- "cmakelint",
  --       -- "codelldb",
  --       -- "debugpy",
  --       -- "debugpy",
  --       -- "delve",
  --       -- "delve",
  --       -- "elm-language-server" -- elmls
  --       -- "erg",
  --       -- "flake8",
  --       -- "foam-language-server", -- foam_ls
  --       -- "gci",
  --       -- "iferr",
  --       -- "impl",
  --       -- "impl",
  --       -- "intelephense",
  --       -- "jedi-language-server", -- jedi_language_server
  --       -- "lemminx",
  --       -- "marksman",
  --       -- "neocmakelsp", -- neocmake -- investigate this for C++
  --       -- "nil nil_ls",
  --       -- "nilaway",
  --       -- "prettierd",
  --       -- "pylint",
  --       -- "pylyzer",
  --       -- "pyre",
  --       -- "pyright",
  --       -- "pyright",
  --       -- "python-lsp-server", -- pylsp
  --       -- "rnix-lsp" -- rnix"
  --       -- "ruff",
  --       -- "ruff-lsp" -- ruff_lsp
  --       -- "ruff-lsp",
  --       -- "salt-lsp" -- salt_ls
  --       -- "shellharden",
  --       -- "texlab",
  --       -- "vue-language-server" -- volar
  --     },
  --   },
  -- },
}

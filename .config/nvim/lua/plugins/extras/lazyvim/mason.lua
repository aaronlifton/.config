return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shellcheck",
        "shfmt",
        "flake8",
        "mdformat",
        "prettier",
        "markdownlint",
        "markdownlint-cli2",
      },
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    keys = {
      { "<leader>cm", false },
      { "<leader>cim", "<cmd>Mason<cr>", desc = "Mason" },
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    cmd = { "MasonToolsInstall", "MasonToolsUpdate", "MasonToolsClean" },
    opts = {
      ensure_installed = {
        "astro-language-server", -- astro"
        "biome",
        "cbfmt",
        "chrome-debug-adapter",
        "commitlint",
        "cspell",
        "css-lsp", -- csslss
        "cssmodules-language-server", --- cssmodules_ls",
        "deno denols",
        "docker-compose-language-service", -- docker_compose_language_service",
        "dockerfile-language-server", --dockerls",
        "elixir-ls",
        "emmet-language-server",
        "emmet-ls",
        "eslint-lsp",
        "fennel-language-server",
        "fixjson",
        "go-debug-adapter",
        "gofumpt",
        "gofumpt",
        "goimports",
        "goimports",
        "goimports-reviser",
        "golangci-lint",
        "golangci-lint-langserver", -- golangci_lint_ls",
        "golines",
        "gomodifytags",
        "gopls",
        "gotests",
        "gotestsum",
        "graphql-language-service-cli", -- graphql",
        "hadolint",
        "html-lsp", --html
        "htmx-lsp", --htmx
        "jq",
        "js-debug-adapter",
        "json-lsp", --jsonls
        "lua-language-server", -- lua_ls",
        "luacheck",
        "markdown-toc",
        "markdownlint-cli2",
        "node-debug2-adapter",
        "oxlint",
        "prettier",
        "prisma-language-server",
        "revive", -- drop in replacement for golint
        "ripper-tags",
        "rstcheck",
        "rubocop",
        "ruby-lsp", -- ruby_ls",
        "rust-analyzer",
        "rustywind",
        "selene",
        "shellcheck",
        "shfmt",
        "solargraph",
        "sorbet",
        "sourcery",
        "sqlls",
        "standardjs",
        "standardrb",
        "staticcheck", -- golang
        "stylelint",
        "stylua",
        "svelte-language-server svelte",
        "tailwindcss-language-server", -- tailwindcss,
        "taplo",
        "terraform-ls", -- terraformls,
        "typescript-language-server", --tsserver,
        "typos",
        "vim-language-server", -- vimls,
        "yaml-language-server", --yamlls",
        "zls",
        "zprint",
        -- "angular-language-server",, -- angularls
        -- "ansible-language-server", -- ansiblels
        -- "autotools-language-server", -- autotools_ls"
        -- "bash-debug-adapter",
        -- "bash-debug-adapter",
        -- "bash-language-server",
        -- "bash-language-server", -- bashls"
        -- "buf-language-server", -- bufls
        -- "clangd",
        -- "clojure-lsp clojure_lsp",
        -- "cmake-language-server cmake",
        -- "cmakelint",
        -- "codelldb",
        -- "debugpy",
        -- "debugpy",
        -- "delve",
        -- "delve",
        -- "elm-language-server elmls",
        -- "erg",
        -- "flake8",
        -- "foam-language-server foam_ls",
        -- "gci",
        -- "iferr",
        -- "impl",
        -- "impl",
        -- "intelephense",
        -- "jedi-language-server jedi_language_server",
        -- "lemminx",
        -- "marksman",
        -- "marksman",
        -- "neocmakelsp neocmake",
        -- "nil nil_ls",
        -- "nilaway",
        -- "prettierd",
        -- "pylint",
        -- "pylyzer",
        -- "pyre",
        -- "pyright",
        -- "pyright",
        -- "python-lsp-server pylsp",
        -- "rnix-lsp rnix",
        -- "ruff",
        -- "ruff-lsp ruff_lsp",
        -- "ruff-lsp",
        -- "salt-lsp salt_ls",
        -- "shellharden",
        -- "texlab",
        -- "vue-language-server volar",
        -- more
      },
    },
  },
}

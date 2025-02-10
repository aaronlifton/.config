-- TODO: https://github.com/ngalaiko/tree-sitter-go-template

return {
  { import = "lazyvim.plugins.extras.lang.go" },
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = { "golangci-lint" },
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = {
        go = { "golangcilint" },
        gomod = { "golangcilint" },
        gowork = { "golangcilint" },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        go = { "gofmt" },
      },
    },
  },
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
        lsp_gofumpt = "true",
        lup_inlay_hints = { enable = false },
        lsp_codelens = { enable = false },
        run_in_floaterm = true,
        trouble = true,
        lsp_cfg = {
          flags = { debounce_text_changes = 500 },
          cmd = { "gopls", "-remote=auto" },
          settings = {
            gopls = {
              usePlaceholders = true,
              analyses = {
                nilness = true,
                shadow = true,
                unusedparams = true,
                unusewrites = true,
              },
              hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                constantValues = true,
                functionTypeParameters = true,
                parameterNames = true,
                rangeVariableTypes = true,
              },
            },
          },
        },
      })
    end,
  },
  -- {
  --   "yanskun/gotests.nvim",
  --   ft = "go",
  --   config = function()
  --     require("gotests").setup()
  --   end,
  -- },
  -- {
  --   "neovim/nvim-lspconfig",
  --   optional = true,
  --   opts = {
  --     setup = {
  --       gopls = function(_, opts)
  --         LazyVim.lsp.on_attach(function(client, _)
  --           -- `vim.lsp.handlers["textDocument/signatureHelp"]` has been overwritten by another plugin?
  --           -- Either disable the other plugin or set `config.lsp.signature.enabled = false` in your **Noice** config.
  --           --   - plugin: nvim
  --           --   - file: /Users/aaron/.local/share/bob/nightly/nvim-macos/share/nvim/runtime/lua/vim/lsp.lua
  --           --   - line: 1390
  --           require("lsp_signature").on_attach({ bind = true, handler_opts = { border = "rounded" } }, bufnr)
  --           -- vim.lsp.codelens.refresh()
  --         end)
  --       end,
  --     },
  --   },
  -- },
}

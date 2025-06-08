local cmd = function(use_homebrew)
  local arch = {
    ["arm64"] = "arm64",
    ["aarch64"] = "arm64",
    ["amd64"] = "amd64",
    ["x86_64"] = "amd64",
  }

  local os_name = string.lower(vim.uv.os_uname().sysname)
  local current_arch = arch[string.lower(vim.uv.os_uname().machine)]
  local build_bin = fmt("next_ls_%s_%s", os_name, current_arch)

  if use_homebrew then
    return { "nextls", "--stdio" }
  end
  return { fmt("%s/lsp/nextls/burrito_out/%s", vim.env.XDG_DATA_HOME, build_bin), "--stdio" }
end

return {
  {
    "nvim-treesitter/nvim-treesitter",
    optional = true,
    opts = {
      ensure_installed = { "elixir", "heex", "eex" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        elixirls = {},
      },
    },
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    dependencies = {
      "jfpedroza/neotest-elixir",
    },
    opts = {
      adapters = {
        ["neotest-elixir"] = {},
      },
    },
  },
  {
    "elixir-tools/elixir-tools.nvim",
    version = "*",
    event = { "BufReadPre", "BufNewFile" },
    commands = {},
    config = function()
      local elixir = require("elixir")
      local elixirls = require("elixir.elixirls")

      elixir.setup({
        -- nextls = { enable = true },
        nextls = {
          enable = false, -- defaults to false
          port = 9000, -- connect via TCP with the given port. mutually exclusive with `cmd`. defaults to nil
          cmd = "/opt/homebrew/bin/nextls", -- path to the executable. mutually exclusive with `port`
          init_options = {
            mix_env = "dev",
            mix_target = "host",
            experimental = {
              completions = {
                enable = false, -- control if completions are enabled. defaults to false
              },
            },
          },
          on_attach = function(client, bufnr)
            -- custom keybinds
          end,
        },
        elixirls = {
          -- specify a repository and branch
          -- repo = "mhanberg/elixir-ls", -- defaults to elixir-lsp/elixir-ls
          -- branch = "mh/all-workspace-symbols", -- defaults to nil, just checkouts out the default branch, mutually exclusive with the `tag` option
          -- tag = "v0.14.6", -- defaults to nil, mutually exclusive with the `branch` option

          -- alternatively, point to an existing elixir-ls installation (optional)
          -- not currently supported by elixirls, but can be a table if you wish to pass other args `{"path/to/elixirls", "--foo"}`
          -- cmd = "/usr/local/bin/elixir-ls.sh",

          -- default settings, use the `settings` function to override settings
          settings = elixirls.settings({
            dialyzerEnabled = true,
            fetchDeps = false,
            enableTestLenses = true, -- false,
            suggestSpecs = true, -- false,
          }),
          on_attach = function(client, bufnr)
            vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
            vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
            vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
          end,
        },
        -- credo = {},
        -- elixirls = {
        --   enable = true,
        --   settings = elixirls.settings({
        --     dialyzerEnabled = false,
        --     enableTestLenses = false,
        --   }),
        --   on_attach = function(client, bufnr)
        --     vim.keymap.set("n", "<space>fp", ":ElixirFromPipe<cr>", { buffer = true, noremap = true })
        --     vim.keymap.set("n", "<space>tp", ":ElixirToPipe<cr>", { buffer = true, noremap = true })
        --     vim.keymap.set("v", "<space>em", ":ElixirExpandMacro<cr>", { buffer = true, noremap = true })
        --   end,
        -- },
      })

      -- Unbind the :M command
      vim.api.nvim_del_user_command("M")
    end,
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
}

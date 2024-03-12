return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {},
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")
      lspconfig.fennel_lsp.setup(opts)
      require("lspconfig.configs").fennel_language_server = {
        default_config = {
          -- replace it with true path
          cmd = { "/PATH/TO/BINFILE" },
          filetypes = { "fennel" },
          single_file_support = true,
          -- source code resides in directory `fnl/`
          root_dir = lspconfig.util.root_pattern("fnl"),
          settings = {
            fennel = {
              workspace = {
                -- If you are using hotpot.nvim or aniseed,
                -- make the server aware of neovim runtime files.
                library = vim.api.nvim_list_runtime_paths(),
              },
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },
      }
    end,
  },
}

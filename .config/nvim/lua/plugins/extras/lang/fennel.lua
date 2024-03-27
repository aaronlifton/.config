return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        fennel_language_server = {
          default_config = {
            -- replace it with true path
            cmd = { "/usr/local/bin/fennel" },
            filetypes = { "fennel" },
            single_file_support = true,
            -- source code resides in directory `fnl/`
            root_dir = require("lspconfig.util").root_pattern("fnl"),
            settings = {
              fennel = {
                workspace = {
                  -- -- If you are using hotpot.nvim or aniseed,
                  -- -- make the server aware of neovim runtime files.
                  -- library = vim.api.nvim_list_runtime_paths(),
                },
                diagnostics = {
                  globals = { "vim" },
                },
              },
            },
          },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "fennel-language-server" })
    end,
  },
  -- {
  --   "rktjmp/hotpot.nvim",
  --   lazy = false,
  --   config = function()
  --     require("hotpot").setup()
  --   end,
  -- },
  {
    "Olical/nfnl",
    ft = "fennel",
    init = function() require("nfnl").setup({}) end,
  },
  {
    -- "atweiden/vim-fennel",
    "bakpakin/fennel.vim",
  },
}

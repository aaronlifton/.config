return {
  "nvim-treesitter/nvim-treesitter",
  optional = true,
  dependencies = {
    "LiadOz/nvim-dap-repl-highlights",
    opts = {},
  },
  opts = {
    ensure_installed = { "dap_repl" },
  },
}

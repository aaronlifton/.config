return {
  "zeioth/garbage-day.nvim",
  event = "LspAttach",
  opts = {
    notifications = true,
    grace_period = 60 * 10,
    excluded_lsp_clients = { "copilot", "ruby_lsp", "rust-analyzer" },
  },
}

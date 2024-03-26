return {
  "ckolkey/ts-node-action",
  dependencies = { "nvim-treesitter" },
  opts = {},
  --stylua: ignore
  keys = { { "T", "<cmd>NodeAction<cr>", desc = "Node action" } },
}

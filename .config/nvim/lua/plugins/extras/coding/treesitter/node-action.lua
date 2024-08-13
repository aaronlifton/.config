return {
  "ckolkey/ts-node-action",
  dependencies = { "nvim-treesitter" },
  opts = {},
  --stylua: ignore
  keys = { { "<C-t>", "<cmd>NodeAction<cr>", desc = "Node action" } },
}

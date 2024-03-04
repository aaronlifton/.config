return {
  "ckolkey/ts-node-action",
  dependencies = { "nvim-treesitter" },
  opts = {},
  --stylua: ignore
  keys = { { "<C-S-j>", "<cmd>NodeAction<cr>", desc = "Node action" } },
}

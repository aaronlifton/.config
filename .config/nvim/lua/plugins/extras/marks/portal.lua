return {
  "cbochs/portal.nvim",
  cmd = { "Portal" },
  keys = {
    { "<M-o>", "<cmd>Portal jumplist backward<cr>", desc = "Portal Jumplist Prev" },
    { "<M-i>", "<cmd>Portal jumplist forward<cr>", desc = "Portal Jumplist Next" },
    { "<C-S-N>", "<CMD>Portal grapple forward<CR>", desc = "Portal Grapple Next" },
    { "<C-S-P>", "<CMD>Portal grapple backward<CR>", desc = "Portal Grapple Next" },
  },
  opts = {
    -- labels = { "n", "e", "m", "i" },
    -- window_options = {
    --   width = 50,
    --   height = 5,
    --   border = "rounded",
    -- },
  },
  -- Optional dependencies
  dependencies = {
    "cbochs/grapple.nvim",
    -- "ThePrimeagen/harpoon"
  },
  config = function(_, opts)
    require("portal").setup(opts)
    vim.api.nvim_set_hl(0, "PortalLabel", { link = "Normal" })
    vim.api.nvim_set_hl(0, "PortalTitle", { link = "Normal" })
    vim.api.nvim_set_hl(0, "PortalBorder", { link = "Normal" })
    vim.api.nvim_set_hl(0, "PortalNormal", { link = "Normal" })
  end,
}

-- https://github.com/kosayoda/nvim-lightbulb
return {
  "kosayoda/nvim-lightbulb",
  event = "LspAttach",
  opts = {
    autocmd = { enabled = true },
    sign = { enabled = true, text = "" },
    action_kinds = { "quickfix", "refactor" },
    ignore = {
      actions_without_kind = true,
    },
  },
  keys = function()
    local nvim_lightbulb = require("nvim-lightbulb")
    return {
      {
        "<leader>ch",
        function()
          vim.cmd("echo 'hello'")
          local bufnr = vim.api.nvim_get_current_buf()
          local status_text = require("nvim-lightbulb").get_status_text(0)
          vim.cmd("echo " .. status_text)
        end,
        desc = "Lightbulb - status text",
      },
      {
        "<leader>cD",
        function()
          nvim_lightbulb.debug()
        end,
        desc = "Lightbub - debug",
      },
      {
        "<leader>lU",
        function()
          nvim_lightbulb.update_lightbulb()
        end,
        desc = "Lightbulb - update",
      },
    }
  end,
  -- config = function()
  --   vim.api.nvim_set_hl(0, "LightBulbSign", { link = "DiagnosticSignWarn" })
  -- end,
}

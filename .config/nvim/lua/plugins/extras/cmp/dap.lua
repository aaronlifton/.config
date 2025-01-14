return {
  "hrsh7th/nvim-cmp",
  lazy = true,
  optional = true,
  dependencies = {
    { "rcarriga/cmp-dap", ft = { "dap-repl" } },
  },
  opts = function(_, _opts)
    local cmp = require("cmp")
    cmp.register_source("dap", require("cmp_dap").new())
    cmp.setup({
      enabled = function()
        return vim.api.nvim_get_option_value("buftype", { buf = 0 }) ~= "prompt" or require("cmp_dap").is_dap_buffer()
      end,
    })

    cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
      sources = {
        { name = "dap" },
      },
    })
  end,
}

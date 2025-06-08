return {
  -- { "rcarriga/nvim-dap-ui", enabled = false },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    dependencies = {
      {
        "igorlfs/nvim-dap-view",
        opts = {},
        keys = {
          {
            "<leader>du",
            function()
              require("dap-view").toggle()
            end,
            desc = "Dap View",
          },
          {
            "<leader>de",
            function()
              require("dap-view").add_expr()
            end,
            desc = "Dap View - Add Expr",
          },
        },
      },
    },
    -- config = function(_, opts)
    --   require("dap-view").open()
    --   require("dap-view").close()
    --   require("dap-view").toggle()
    --   require("dap-view").add_expr()
    --
    --   vim.api.nvim_create_autocmd({ "FileType" }, {
    --     pattern = { "dap-view", "dap-view-term", "dap-repl" }, -- dap-repl is set by `nvim-dap`
    --     callback = function(evt)
    --       vim.keymap.set("n", "q", "<C-w>q", { silent = true, buffer = evt.buf })
    --     end,
    --   })
    -- end,
  },
}

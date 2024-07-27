return {
  { import = "lazyvim.plugins.extras.dap.core" },
  {
    "mfussenegger/nvim-dap",
    opts = {
      defaults = {
        fallback = {
          external_terminal = {
            command = "/opt/homebrew/bin/kitty",
            args = { "--class", "kitty-dap", "--hold", "--detach", "nvim-dap", "-c", "DAP" },
          },
        },
      },
    },
    --   -- stylua: ignore
    keys = {
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "Debug: Continue",
      },
      {
        "<F6>",
        function()
          require("dap").step_over()
        end,
        desc = "Debug: Step over",
      },
      {
        "<F7>",
        function()
          require("dap").step_into()
        end,
        desc = "Debug: Step into",
      },
      {
        "<F8>",
        function()
          require("dap").step_out()
        end,
        desc = "Debug: Step out",
      },
      {
        "<F9>",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "Debug: Toggle breakpoint",
      },
      {
        "<F10>",
        function()
          require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end,
        desc = "Breakpoint Condition",
      },
      {
        "<leader>dx",
        function()
          require("dap.ui.widgets").scopes()
        end,
        desc = "Scopes",
      },
    },
  },
  {
    "nvim-neotest/neotest",
    optional = true,
    -- stylua: ignore
    keys = {
      { "<leader>tL", function() require("neotest").run.run_last({ strategy = "dap" }) end, desc = "Debug Last Test" },
    },
  },
}

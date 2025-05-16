return {
  { import = "lazyvim.plugins.extras.dap.core" },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    opts = {
      defaults = {
        fallback = {
          external_terminal = {
            command = "/usr/local/bin/kitty",
            args = { "--class", "kitty-dap", "--hold", "--detach", "nvim-dap", "-c", "DAP" },
            -- args = { "-e" },
          },
          force_external_terminal = true,
          -- terminal_win_cmd = "50vsplit new",
          -- focus_terminal = true,
        },
      },
    },
    -- stylua: ignore
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug: Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug: Step over" },
      { "<F11>", function() require("dap").step_into() end, desc = "Debug: Step into" },
      { "<F12>", function() require("dap").step_out() end, desc = "Debug: Step out" },
      { "<F2>", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle breakpoint" },
      { "<M-C-S-D-2>", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
      { "<leader>dQ", function() require('dap').list_breakpoints() end, desc = "Add breakpoints to qflist"}
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    optional = true,
    opts = {
      layouts = {
        {
          elements = {
            {
              id = "breakpoints",
              size = 0.10,
            },
            {
              id = "scopes",
              size = 0.40,
            },
            {
              id = "stacks",
              size = 0.40,
            },
          },
          position = "left",
          size = 40,
        },
        {
          elements = {
            {
              id = "repl",
              size = 1.0,
            },
          },
          position = "bottom",
          size = 8,
        },
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

return {
  {
    "anuvyklack/hydra.nvim",
    optional = true,
    opts = {
      specs = {
        test = function()
          local cmd = require("hydra.keymap-util").cmd
          local hint = [[
^
_f_: File
_F_: All Files
_l_: Last
_n_: Nearest
^
_d_: Debug File
_L_: Debug Last
_N_: Debug Nearest
^
_o_: Output
_S_: Summary
^
_a_: Attach
_s_: Stop
^
^ ^  _q_: Quit 
          ]]
          return {
            name = "Test",
            hint = hint,
            config = {
              color = "pink",
              invoke_on_body = true,
              hint = {
                border = "rounded",
                position = "top-left",
              },
            },
            mode = "n",
            body = "<A-t>",
            heads = {
              { "F", cmd("w|lua require('neotest').run.run(vim.loop.cwd())"), desc = "All Files" },
              { "L", cmd("w|lua require('neotest').run.run_last({strategy = 'dap'})"), desc = "Debug Last" },
              { "N", cmd("w|lua require('neotest').run.run({strategy = 'dap'})"), desc = "Debug Nearest" },
              { "S", cmd("w|lua require('neotest').summary.toggle()"), desc = "Summary" },
              { "a", cmd("w|lua require('neotest').run.attach()"), desc = "Attach" },
              {
                "d",
                cmd("w|lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'}"),
                desc = "Debug File",
              },
              { "f", cmd("w|lua require('neotest').run.run(vim.fn.expand('%'))"), desc = "File" },
              { "l", cmd("w|lua require('neotest').run.run_last()"), desc = "Last" },
              { "n", cmd("w|lua require('neotest').run.run()"), desc = "Nearest" },
              { "o", cmd("w|lua require('neotest').output.open({ enter = true })"), desc = "Output" },
              { "s", cmd("w|lua require('neotest').run.stop()"), desc = "Stop" },
              { "q", nil, { exit = true, nowait = true, desc = "Exit" } },
            },
          }
        end,
      },
    },
  },
}
